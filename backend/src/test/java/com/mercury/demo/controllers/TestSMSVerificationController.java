
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

import java.util.Optional;

class TestSMSVerificationController {
    private static final Member MEMBER = new Member("Giorno", "Giovanna", 39, "12345678910");
    private static final String CARRIER_NAME = "Verizon";

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
        final Carrier carrier = new Carrier(Carrier.CommType.SMS, "1", CARRIER_NAME, "vibes", false);
        final SMSVerification smsVerification = new SMSVerification(MEMBER.getCountryCode(), MEMBER.getPhoneNumber(), 12, "12");
        smsVerification.setId("1");
        final SMSDispatchResponse expectedDispatchResponse = new SMSDispatchResponse(true, smsVerification.getId());

        Mockito.when(mockCarrierRepository.findById(CARRIER_NAME)).thenReturn(Optional.of(carrier));
        Mockito.when(mockSmsVerificationRepository.save(Mockito.any(SMSVerification.class))).thenReturn(smsVerification);

        Assertions.assertEquals(expectedDispatchResponse, controller.requestSMSDispatch(MEMBER.getCountryCode(), MEMBER.getPhoneNumber(), CARRIER_NAME));

        Mockito.verify(mockCarrierRepository, Mockito.times(1)).findById(Mockito.any());
        Mockito.verify(mockSmsVerificationRepository, Mockito.times(1)).save(Mockito.any());
        Mockito.verify(mockMailService, Mockito.times(1)).dispatchSMS(Mockito.anyString(), Mockito.anyInt(), Mockito.anyString(), Mockito.any());
    }

    @Test
    void testRequestSMSDispatchWithoutCarrier() {
        final SMSDispatchResponse expectedDispatchResponse = new SMSDispatchResponse(false, null);

        Mockito.when(mockCarrierRepository.findById("SimpleMobile")).thenReturn(Optional.empty());

        Assertions.assertEquals(expectedDispatchResponse, controller.requestSMSDispatch(MEMBER.getCountryCode(), MEMBER.getPhoneNumber(), "SimpleMobile"));

        Mockito.verify(mockCarrierRepository, Mockito.times(1)).findById("SimpleMobile");
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
    void testRegister() {
        final Member expectedMember = new Member("Giorno", "Giovanna", 39, "12345678910");
        expectedMember.setId("123");
        MEMBER.setId(null);

        final String expectedToken = "1234567890";
        final SMSVerification expectedSMSVerification = new SMSVerification(expectedMember.getCountryCode(),
                expectedMember.getPhoneNumber(),
                0L, "");
        expectedSMSVerification.setId(expectedToken);
        expectedSMSVerification.setVerified(true);
        final MemberAddResponse expectedResponse = new MemberAddResponse(expectedMember);

        Mockito.when(mockMemberRepository.save(MEMBER)).thenReturn(expectedMember);
        Mockito.when(mockSmsVerificationRepository
                        .findFirstByIdAndVerified(expectedToken, true))
                .thenReturn(Optional.of(expectedSMSVerification));

        Assertions.assertEquals(
                expectedResponse,
                controller.registerMember(
                        MEMBER.getFirstName(),
                        MEMBER.getLastName(),
                        expectedToken));

        Mockito.verify(mockMemberRepository, Mockito.times(1)).save(MEMBER);
        Mockito.verify(mockSmsVerificationRepository, Mockito.times(1))
                .findFirstByIdAndVerified(expectedToken, true);
    }
}