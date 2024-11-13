package com.mercury.demo.controllers;

import com.mercury.demo.entities.Member;
import com.mercury.demo.repositories.MemberRepository;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.MockitoAnnotations;

public class TestMemberController {
    private static final Member MEMBER = new Member("Giorno", "Giovanna", "123",
            "12345678910");

    @Mock
    private MemberRepository mockMemberRepository;

    @InjectMocks
    private MemberController controller;

    @BeforeEach
    public void setUp() {
        MockitoAnnotations.openMocks(this); // Initializes mocks and injects them into the controller
    }

    @Test
    public void testAddMember() {
        final Member expectedMember = new Member("Giorno", "Giovanna", "123", "12345678910");
        expectedMember.setId("123");
        MEMBER.setId(null);

        Mockito.when(mockMemberRepository.save(MEMBER)).thenReturn(expectedMember);

        Assertions.assertEquals(expectedMember.getId(), controller.addNewMember(MEMBER.getFirstName(), MEMBER.getLastName(), MEMBER.getCountryCode(), MEMBER.getPhoneNumber()));

        Mockito.verify(mockMemberRepository, Mockito.times(1)).save(MEMBER);
    }

}
