
package com.mercury.demo.controllers;

import com.mercury.demo.entities.Carrier;
import com.mercury.demo.entities.Member;
import com.mercury.demo.entities.SMSVerification;
import com.mercury.demo.entities.responses.MemberAddResponse;
import com.mercury.demo.entities.responses.SMSDispatchResponse;
import com.mercury.demo.entities.responses.SMSVerifyResponse;
import com.mercury.demo.mail.SMSEmailService;
import com.mercury.demo.repositories.CarrierRepository;
import com.mercury.demo.repositories.MemberRepository;
import com.mercury.demo.repositories.SMSVerificationRepository;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.MockitoAnnotations;
import org.springframework.util.DigestUtils;

import java.util.*;

class TestSMSVerificationController {
    private static final Member MEMBER = new Member("Giorno", "Giovanna", 39, "12345678910");
    private static final Carrier CARRIER = new Carrier(Carrier.CommType.SMS, "1", "Verizon", "vibes", false);
    private static final String FAKE_CARRIER = "SimpleMobile";
    private static final String TOKEN = "1234567890";
    private static final SMSVerification VERIFICATION = new SMSVerification(MEMBER.getCountryCode(), MEMBER.getPhoneNumber(), 12, "12");

    @Mock
    private SMSVerificationRepository mockSmsVerificationRepository;

    @Mock
    private CarrierRepository mockCarrierRepository;

    @Mock
    private SMSEmailService mockMailService;

    @Mock
    private MemberRepository mockMemberRepository;

    @InjectMocks
    private SMSVerificationController controller;

    @BeforeEach
    public void setup() {
        MockitoAnnotations.openMocks(this);
    }

    @Test
    void testRequestSMSDispatch() {
        final SMSVerification smsVerification = VERIFICATION;
        smsVerification.setId("1");
        final SMSDispatchResponse expectedDispatchResponse = new SMSDispatchResponse(true, smsVerification.getId());

        Mockito.when(mockCarrierRepository.findById(CARRIER.getName())).thenReturn(Optional.of(CARRIER));
        Mockito.when(mockSmsVerificationRepository.save(Mockito.any(SMSVerification.class))).thenReturn(smsVerification);

        Assertions.assertEquals(expectedDispatchResponse, controller.requestSMSDispatch(MEMBER.getCountryCode(), MEMBER.getPhoneNumber(), CARRIER.getName()));

        Mockito.verify(mockCarrierRepository, Mockito.times(1)).findById(Mockito.any());
        Mockito.verify(mockSmsVerificationRepository, Mockito.times(1)).save(Mockito.any());
        Mockito.verify(mockMailService, Mockito.times(1)).dispatchSMS(Mockito.anyString(), Mockito.anyInt(), Mockito.anyString(), Mockito.any());
    }

    @Test
    void testRequestSMSDispatchWithoutCarrier() {
        final SMSDispatchResponse expectedDispatchResponse = new SMSDispatchResponse(false, null);

        Mockito.when(mockCarrierRepository.findById(FAKE_CARRIER)).thenReturn(Optional.empty());

        Assertions.assertEquals(expectedDispatchResponse, controller.requestSMSDispatch(MEMBER.getCountryCode(), MEMBER.getPhoneNumber(), FAKE_CARRIER));

        Mockito.verify(mockCarrierRepository, Mockito.times(1)).findById(FAKE_CARRIER);
    }

    @Test
    void testVerifySMSCode() {
        final String code = "123";
        final String token = "abcd";
        final SMSVerification verification = new SMSVerification(MEMBER.getCountryCode(), MEMBER.getPhoneNumber(), 12, DigestUtils.md5DigestAsHex(code.getBytes()));
        final SMSVerifyResponse expectedVerifyResponse = new SMSVerifyResponse(true, MEMBER);

        Mockito.when(mockSmsVerificationRepository.findById(token)).thenReturn(Optional.of(verification));
        Mockito.when(mockMemberRepository.findByPhoneNumberAndCountryCode(
                verification.getPhoneNumber(),
                verification.getCountryCode())).thenReturn(Optional.of(MEMBER));

        Assertions.assertEquals(expectedVerifyResponse, controller.verifySMSCode(token, code));

        Mockito.verify(mockSmsVerificationRepository, Mockito.times(1)).findById(Mockito.any());
        Mockito.verify(mockMemberRepository, Mockito.times(1)).findByPhoneNumberAndCountryCode(Mockito.any(), Mockito.anyInt());
    }

    @Test
    void testVerifySMSCodeNoResponse() {
        final String code = "123";
        final String token = "abcd";
        final SMSVerifyResponse expectedVerifyResponse = new SMSVerifyResponse(false, null);

        Mockito.when(mockSmsVerificationRepository.findById(token)).thenReturn(Optional.empty());

        Assertions.assertEquals(expectedVerifyResponse, controller.verifySMSCode(token, code));

        Mockito.verify(mockSmsVerificationRepository, Mockito.times(1)).findById(Mockito.any());
    }

    @Test
    void testVerifySMSCodeIncorrectCode() {
        final String code = "123";
        final String token = "abcd";
        final SMSVerification verification = new SMSVerification(MEMBER.getCountryCode(), MEMBER.getPhoneNumber(), 12, "def not correct");
        final SMSVerifyResponse expectedVerifyResponse = new SMSVerifyResponse(false, null);

        Mockito.when(mockSmsVerificationRepository.findById(token)).thenReturn(Optional.of(verification));

        Assertions.assertEquals(expectedVerifyResponse, controller.verifySMSCode(token, code));

        Mockito.verify(mockSmsVerificationRepository, Mockito.times(1)).findById(Mockito.any());
    }

    @Test
    void testGetCarriers() {
        final List<Map<String, Object>> expectedCarrierInfo = new ArrayList<>();
        expectedCarrierInfo.add(new HashMap<>());
        expectedCarrierInfo.get(0).put("type", "sms");
        expectedCarrierInfo.get(0).put("displayName", "Text Message");
        expectedCarrierInfo.get(0).put("carriers", List.of(CARRIER));

        Mockito.when(mockCarrierRepository.findAllByType(Carrier.CommType.SMS)).thenReturn(List.of(CARRIER));

        Assertions.assertEquals(expectedCarrierInfo, controller.getAllCarriers());

        Mockito.verify(mockCarrierRepository, Mockito.times(Carrier.CommType.values().length)).findAllByType(Mockito.any());
    }

    @Test
    void testRegister() {
        final Member expectedMember = new Member("Giorno", "Giovanna", 39, "12345678910");
        expectedMember.setId("123");
        MEMBER.setId(null);

        final SMSVerification expectedSMSVerification = new SMSVerification(expectedMember.getCountryCode(),
                expectedMember.getPhoneNumber(),
                0L, "");
        expectedSMSVerification.setId(TOKEN);
        expectedSMSVerification.setVerified(true);

        Mockito.when(mockSmsVerificationRepository.findFirstByIdAndVerified(TOKEN, true)).thenReturn(Optional.of(new SMSVerification(MEMBER.getCountryCode(), MEMBER.getPhoneNumber(), 10L, "abcd")));
        Mockito.when(mockMemberRepository.save(MEMBER)).thenReturn(expectedMember);
        Mockito.when(mockSmsVerificationRepository
                        .findFirstByIdAndVerified(TOKEN, true))
                .thenReturn(Optional.of(expectedSMSVerification));

        Assertions.assertEquals(
                new MemberAddResponse(expectedMember),
                controller.registerMember(
                        MEMBER.getFirstName(),
                        MEMBER.getLastName(),
                        TOKEN));

        Mockito.verify(mockMemberRepository, Mockito.times(1)).save(MEMBER);
        Mockito.verify(mockSmsVerificationRepository, Mockito.times(1))
                .findFirstByIdAndVerified(Mockito.anyString(), Mockito.anyBoolean());
        Mockito.verify(mockMemberRepository, Mockito.times(1)).save(MEMBER);
    }

    @Test
    void testAddMemberWithoutVerifiedNumber() {
        final MemberAddResponse expectedResponse = new MemberAddResponse("The phone number has not yet been verified.");
        Mockito.when(mockSmsVerificationRepository
                        .findFirstByIdAndVerified(TOKEN, true))
                .thenReturn(Optional.empty());

        Assertions.assertEquals(
                expectedResponse,
                controller.registerMember(
                        MEMBER.getFirstName(),
                        MEMBER.getLastName(),
                        TOKEN));

        Mockito.verify(mockSmsVerificationRepository, Mockito.times(1))
                .findFirstByIdAndVerified(TOKEN, true);
    }
}