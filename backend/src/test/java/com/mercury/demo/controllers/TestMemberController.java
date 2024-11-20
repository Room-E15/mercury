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
    private static final Member MEMBER = new Member("Giorno", "Giovanna", "123",
            "12345678910");

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
        final Member expectedMember = new Member("Giorno", "Giovanna", "123", "12345678910");
        expectedMember.setId("123");
        MEMBER.setId(null);

        final SMSVerification expectedSMSVerification = new SMSVerification(expectedMember.getCountryCode(),
                                                                            expectedMember.getPhoneNumber(),
                                                                            0L, "");
        final MemberAddResponse expectedResponse = new MemberAddResponse(expectedMember);

        Mockito.when(mockMemberRepository.save(MEMBER)).thenReturn(expectedMember);
        Mockito.when(mockSMSVerificationRepository
                        .findByPhoneNumberAndCountryCodeAndVerified(MEMBER.getPhoneNumber(),
                                                                    MEMBER.getCountryCode(),
                                                                    true))
                .thenReturn(Optional.of(expectedSMSVerification));

        Assertions.assertEquals(
                expectedResponse,
                controller.addNewMember(
                        MEMBER.getFirstName(),
                        MEMBER.getLastName(),
                        MEMBER.getCountryCode(),
                        MEMBER.getPhoneNumber()));

        Mockito.verify(mockMemberRepository, Mockito.times(1)).save(MEMBER);
        Mockito.verify(mockSMSVerificationRepository, Mockito.times(1))
                .findByPhoneNumberAndCountryCodeAndVerified(MEMBER.getPhoneNumber(),
                                                            MEMBER.getCountryCode(),
                                                            true);
    }
}
