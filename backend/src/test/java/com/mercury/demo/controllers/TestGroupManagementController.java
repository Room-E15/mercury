package com.mercury.demo.controllers;

import com.mercury.demo.entities.AlertGroup;
import com.mercury.demo.entities.Member;
import com.mercury.demo.entities.Membership;
import com.mercury.demo.repositories.AlertGroupRepository;
import com.mercury.demo.repositories.MemberRepository;
import com.mercury.demo.repositories.MembershipRepository;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.MockitoAnnotations;

import java.util.Optional;

public class TestGroupManagementController {
    private static Member member = new Member("Giorno", "Giovanna", "123",
            "1226765555");

    @Mock
    private MembershipRepository mockMembershipRepository;

    @Mock
    private MemberRepository mockMemberRepository;

    @Mock
    private AlertGroupRepository mockAlertGroupRepository;

    @InjectMocks
    private GroupManagementController controller;

    @BeforeEach
    public void setUp() {
        MockitoAnnotations.openMocks(this); // Initializes mocks and injects them into the controller
    }

    @Test
    public void testCreateGroup() {
        final AlertGroup expectedAlertGroup = new AlertGroup("AIA");
        final Membership expectedMembership = new Membership(member.getId(), expectedAlertGroup.getId(), true);
        member.setId("123");

        // Stubbings for functions that cannot be unit-tested as they are handled by external packages
        Mockito.when(mockMemberRepository.findById(member.getId())).thenReturn(Optional.of(member));
        Mockito.when(mockMembershipRepository.save(expectedMembership)).thenReturn(expectedMembership);
        Mockito.when(mockAlertGroupRepository.save(expectedAlertGroup)).thenReturn(expectedAlertGroup);

        Assertions.assertEquals("Saved", controller.createGroup("AIA", "123"));
    }

    @Test
    public void testCreateGroupUserNotFound() {
        final AlertGroup expectedAlertGroup = new AlertGroup("AIA");
        final Membership expectedMembership = new Membership(member.getId(), expectedAlertGroup.getId(), true);

        // Stubbings for functions that cannot be unit-tested as they are handled by external packages
        Mockito.when(mockMemberRepository.findById(member.getId())).thenReturn(Optional.empty());

        Assertions.assertThrows(RuntimeException.class, () -> controller.createGroup("AIA", "123"));
    }
}
