package com.mercury.demo.controllers;

import com.mercury.demo.entities.Member;
import com.mercury.demo.entities.SMSVerification;
import com.mercury.demo.entities.responses.MemberAddResponse;
import com.mercury.demo.repositories.MemberRepository;
import com.mercury.demo.repositories.SMSVerificationRepository;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.MockitoAnnotations;

import java.util.Optional;

public class TestMemberController {
    private static final String FIRST_NAME = "Giorno";
    private static final String LAST_NAME = "Giovanna";
    private static final int COUNTRY_CODE = 1;
    private static final String PHONE_NUMBER = "1234567890";
    private static final Member MEMBER = new Member(FIRST_NAME, LAST_NAME, COUNTRY_CODE, PHONE_NUMBER);

    @Mock
    private MemberRepository mockMemberRepository;

    @Mock
    private SMSVerificationRepository mockSMSVerificationRepository;

    @InjectMocks
    private MemberController controller;

    @BeforeEach
    public void setup() {
        MockitoAnnotations.openMocks(this); // Initializes mocks and injects them into the controller
    }

    @Test
    public void testAddMember() {
        final Member expectedMember = new Member("Giorno", "Giovanna", 123, "12345678910");
        expectedMember.setId("123");
        MEMBER.setId(null);

        Mockito.when(mockSMSVerificationRepository.getFirstByPhoneNumberAndCountryCodeAndVerified(PHONE_NUMBER, COUNTRY_CODE, true)).thenReturn(Optional.of(new SMSVerification(COUNTRY_CODE, PHONE_NUMBER, 10L, "abcd")));
        Mockito.when(mockMemberRepository.save(MEMBER)).thenReturn(expectedMember);

        Assertions.assertEquals(new MemberAddResponse(expectedMember), controller.addNewMember(MEMBER.getFirstName(), MEMBER.getLastName(), MEMBER.getCountryCode(), MEMBER.getPhoneNumber()));

        Mockito.verify(mockSMSVerificationRepository, Mockito.times(1)).getFirstByPhoneNumberAndCountryCodeAndVerified(Mockito.anyString(), Mockito.anyInt(), Mockito.anyBoolean());
        Mockito.verify(mockMemberRepository, Mockito.times(1)).save(MEMBER);
    }
    @Test
    public void testAddMemberWithoutVerifiedNumber() {
        final MemberAddResponse expectedResponse = new MemberAddResponse("The phone number has not yet been verified.");
        Mockito.when(mockSMSVerificationRepository
                        .getFirstByPhoneNumberAndCountryCodeAndVerified(MEMBER.getPhoneNumber(),
                                MEMBER.getCountryCode(),
                                true))
                .thenReturn(Optional.empty());

        Assertions.assertEquals(
                expectedResponse,
                controller.addNewMember(
                        MEMBER.getFirstName(),
                        MEMBER.getLastName(),
                        MEMBER.getCountryCode(),
                        MEMBER.getPhoneNumber()));

        Mockito.verify(mockSMSVerificationRepository, Mockito.times(1))
                .getFirstByPhoneNumberAndCountryCodeAndVerified(MEMBER.getPhoneNumber(),
                        MEMBER.getCountryCode(),
                        true);
    }
}
