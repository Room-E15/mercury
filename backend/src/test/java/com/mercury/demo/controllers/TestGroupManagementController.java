package com.mercury.demo.controllers;

import com.mercury.demo.entities.AlertGroup;
import com.mercury.demo.entities.Member;
import com.mercury.demo.entities.Membership;
import com.mercury.demo.entities.responses.GetGroupsResponse;
import com.mercury.demo.entities.responses.JoinGroupResponse;
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

import java.util.List;
import java.util.Optional;

public class TestGroupManagementController {
    private static Member MEMBER = new Member("Giorno", "Giovanna", "123",
            "1226765555");
    private static final AlertGroup ALERT_GROUP = new AlertGroup("AIA");

    @Mock
    private MembershipRepository mockMembershipRepository;

    @Mock
    private MemberRepository mockMemberRepository;

    @Mock
    private AlertGroupRepository mockAlertGroupRepository;

    @InjectMocks
    private GroupManagementController controller;

    @BeforeEach
    public void setup() {
        MockitoAnnotations.openMocks(this); // Initializes mocks and injects them into the controller
    }

    @Test
    public void testCreateGroup() {
        final AlertGroup expectedAlertGroup = new AlertGroup("AIA");
        final Membership expectedMembership = new Membership(MEMBER.getId(), expectedAlertGroup.getId(), true);
        MEMBER.setId("123");

        // Stubbings for functions that cannot be unit-tested as they are handled by external packages
        Mockito.when(mockMemberRepository.findById(MEMBER.getId())).thenReturn(Optional.of(MEMBER));
        Mockito.when(mockMembershipRepository.save(expectedMembership)).thenReturn(expectedMembership);
        Mockito.when(mockAlertGroupRepository.save(expectedAlertGroup)).thenReturn(expectedAlertGroup);

        Assertions.assertEquals("Saved", controller.createGroup("AIA", "123"));

        Mockito.verify(mockMemberRepository, Mockito.times(1)).findById(MEMBER.getId());
        Mockito.verify(mockMembershipRepository, Mockito.times(1)).save(expectedMembership);
        Mockito.verify(mockAlertGroupRepository, Mockito.times(1)).save(expectedAlertGroup);
    }

    @Test
    public void testCreateGroupUserNotFound() {
        final AlertGroup expectedAlertGroup = new AlertGroup("AIA");

        // Stubbings for functions that cannot be unit-tested as they are handled by external packages
        Mockito.when(mockMemberRepository.findById(MEMBER.getId())).thenReturn(Optional.empty());

        Assertions.assertThrows(RuntimeException.class, () -> controller.createGroup("AIA", "123"));

        Mockito.verify(mockMemberRepository, Mockito.times(1)).findById(MEMBER.getId());
    }

    @Test
    public void testJoinGroup() {
        final AlertGroup alertGroup = new AlertGroup("AIA");
        alertGroup.setId(123L);
        final Member member = new Member("Test", "ing", "1", "1234567890");
        member.setId("123");

        final Membership membership = new Membership(member.getId(), alertGroup.getId(), false);

        final Membership membershipWithId = membership;
        final JoinGroupResponse expectedJoinGroupResponse = new JoinGroupResponse(member.getId(), alertGroup.getId(), membershipWithId.getId());

        // Stubbings for functions that cannot be unit-tested as they are handled by external packages
        Mockito.when(mockMemberRepository.findById(member.getId())).thenReturn(Optional.of(member));
        Mockito.when(mockAlertGroupRepository.findById(alertGroup.getId())).thenReturn(Optional.of(alertGroup));
        Mockito.when(mockMembershipRepository.save(membership)).thenReturn(membershipWithId);

        Assertions.assertEquals(expectedJoinGroupResponse, controller.joinGroup(member.getId(), alertGroup.getId()));

        Mockito.verify(mockMemberRepository).findById(member.getId());
        Mockito.verify(mockAlertGroupRepository).findById(alertGroup.getId());
        Mockito.verify(mockMembershipRepository).save(membership);
    }

    @Test
    public void testJoinGroupUserNotFound() {
        // Stubbings for functions that cannot be unit-tested as they are handled by external packages
        Mockito.when(mockMemberRepository.findById(MEMBER.getId())).thenReturn(Optional.empty());

        Assertions.assertThrows(RuntimeException.class, () -> controller.joinGroup(MEMBER.getId(), 123L));

        Mockito.verify(mockMemberRepository, Mockito.times(1)).findById(MEMBER.getId());
    }

    @Test
    public void testJoinGroupGroupNotFound() {
        final Member member = new Member("Test", "ing", "1", "1234567890");
        member.setId("123");

        Mockito.when(mockMemberRepository.findById(member.getId())).thenReturn(Optional.of(member));
        Mockito.when(mockAlertGroupRepository.findById(ALERT_GROUP.getId())).thenReturn(Optional.empty());

        Assertions.assertThrows(RuntimeException.class, () -> controller.joinGroup(member.getId(), ALERT_GROUP.getId()));

        Mockito.verify(mockMemberRepository, Mockito.times(1)).findById(member.getId());
        Mockito.verify(mockAlertGroupRepository, Mockito.times(1)).findById(ALERT_GROUP.getId());
    }

    @Test
    public void testGetGroupWithOneMember() {
        final AlertGroup alertGroup = new AlertGroup("AIA");
        alertGroup.setId(123L);
        MEMBER.setId("123");
        final Membership membership = new Membership(MEMBER.getId(), alertGroup.getId(), true);
        membership.setId(1L);
        final GetGroupsResponse expectedGetGroupsResponse = new GetGroupsResponse(alertGroup.getId(), alertGroup.getGroupName(), 1, 0, true, List.of(), List.of(MEMBER));

        Mockito.when(mockMembershipRepository.findByMemberId(MEMBER.getId())).thenReturn(List.of(membership));
        Mockito.when(mockMemberRepository.findById(MEMBER.getId())).thenReturn(Optional.of(MEMBER));
        Mockito.when(mockAlertGroupRepository.findById(membership.getGroupId())).thenReturn(Optional.of(alertGroup));
        Mockito.when(mockMembershipRepository.findByGroupId(alertGroup.getId())).thenReturn(List.of(membership));

        Assertions.assertEquals(List.of(expectedGetGroupsResponse), controller.getGroups(MEMBER.getId()));

        // These verifications confirm that each method with these parameters were used this number of times
        Mockito.verify(mockMembershipRepository, Mockito.times(1)).findByMemberId(MEMBER.getId());
        Mockito.verify(mockMemberRepository, Mockito.times(1)).findById(membership.getMemberId());
        Mockito.verify(mockAlertGroupRepository, Mockito.times(1)).findById(membership.getGroupId());
        Mockito.verify(mockMembershipRepository, Mockito.times(1)).findByGroupId(alertGroup.getId());
    }

    @Test
    public void testGetGroupWithTwoMembers() {
        final AlertGroup alertGroup = new AlertGroup("AIA");
        alertGroup.setId(123L);
        MEMBER.setId("123");
        final Member memberTwo = new Member("Test", "ing", "4", "1234567890");
        memberTwo.setId("1234");
        final Membership membership = new Membership(MEMBER.getId(), alertGroup.getId(), true);
        membership.setId(1L);
        final Membership membershipTwo = new Membership(memberTwo.getId(), alertGroup.getId(), false);
        membership.setId(2L);
        final GetGroupsResponse expectedGetGroupsResponse = new GetGroupsResponse(alertGroup.getId(), alertGroup.getGroupName(), 2, 0, true, List.of(memberTwo), List.of(MEMBER));

        Mockito.when(mockMembershipRepository.findByMemberId(MEMBER.getId())).thenReturn(List.of(membership));
        Mockito.when(mockMemberRepository.findById(MEMBER.getId())).thenReturn(Optional.of(MEMBER));
        Mockito.when(mockAlertGroupRepository.findById(membership.getGroupId())).thenReturn(Optional.of(alertGroup));
        Mockito.when(mockMembershipRepository.findByGroupId(alertGroup.getId())).thenReturn(List.of(membership, membershipTwo));
        Mockito.when(mockMemberRepository.findById(memberTwo.getId())).thenReturn(Optional.of(memberTwo));

        Assertions.assertEquals(List.of(expectedGetGroupsResponse), controller.getGroups(MEMBER.getId()));

        // These verifications confirm that each method with these parameters were used this number of times
        Mockito.verify(mockMembershipRepository, Mockito.times(1)).findByMemberId(MEMBER.getId());
        Mockito.verify(mockAlertGroupRepository, Mockito.times(1)).findById(membership.getGroupId());
        Mockito.verify(mockMemberRepository, Mockito.times(1)).findById(MEMBER.getId());
        Mockito.verify(mockMemberRepository, Mockito.times(1)).findById(memberTwo.getId());
        Mockito.verify(mockMembershipRepository, Mockito.times(1)).findByGroupId(alertGroup.getId());
    }

    @Test
    public void testGetGroupWithTwoGroups() {
        final AlertGroup alertGroup = new AlertGroup("AIA");
        alertGroup.setId(123L);
        MEMBER.setId("123");
        final AlertGroup alertGroupTwo = new AlertGroup("Test");
        alertGroupTwo.setId(122L);
        final Membership membership = new Membership(MEMBER.getId(), alertGroup.getId(), true);
        membership.setId(1L);
        final Membership membershipTwo = new Membership(MEMBER.getId(), alertGroupTwo.getId(), false);
        membership.setId(2L);
        final List<GetGroupsResponse> expectedGetGroupsResponse = List.of(
                new GetGroupsResponse(alertGroup.getId(), alertGroup.getGroupName(), 1, 0, true, List.of(), List.of(MEMBER)),
                new GetGroupsResponse(alertGroupTwo.getId(), alertGroupTwo.getGroupName(), 1, 0, false, List.of(MEMBER), List.of()));

        Mockito.when(mockMembershipRepository.findByMemberId(MEMBER.getId())).thenReturn(List.of(membership, membershipTwo));
        Mockito.when(mockMemberRepository.findById(MEMBER.getId())).thenReturn(Optional.of(MEMBER));
        Mockito.when(mockAlertGroupRepository.findById(membership.getGroupId())).thenReturn(Optional.of(alertGroup));
        Mockito.when(mockAlertGroupRepository.findById(membershipTwo.getGroupId())).thenReturn(Optional.of(alertGroupTwo));
        Mockito.when(mockMembershipRepository.findByGroupId(alertGroup.getId())).thenReturn(List.of(membership));
        Mockito.when(mockMembershipRepository.findByGroupId(alertGroupTwo.getId())).thenReturn(List.of(membershipTwo));

        Assertions.assertEquals(expectedGetGroupsResponse, controller.getGroups(MEMBER.getId()));

        // These verifications confirm that each method with these parameters were used this number of times
        Mockito.verify(mockMembershipRepository, Mockito.times(1)).findByMemberId(MEMBER.getId());
        Mockito.verify(mockAlertGroupRepository, Mockito.times(1)).findById(membership.getGroupId());
        Mockito.verify(mockAlertGroupRepository, Mockito.times(1)).findById(membershipTwo.getGroupId());
        Mockito.verify(mockMemberRepository, Mockito.times(2)).findById(MEMBER.getId());
        Mockito.verify(mockMembershipRepository, Mockito.times(1)).findByGroupId(alertGroup.getId());
        Mockito.verify(mockMembershipRepository, Mockito.times(1)).findByGroupId(alertGroupTwo.getId());
    }

    @Test
    public void testGetGroupGroupNotFound() {
        MEMBER.setId("123");
        final Membership membership = new Membership(MEMBER.getId(), 123L, true);
        membership.setId(1L);

        Mockito.when(mockMembershipRepository.findByMemberId(MEMBER.getId())).thenReturn(List.of(membership));
        Mockito.when(mockAlertGroupRepository.findById(membership.getGroupId())).thenReturn(Optional.empty());

        Assertions.assertThrows(RuntimeException.class, () -> controller.getGroups(MEMBER.getId()));

        // These verifications confirm that each method with these parameters were used this number of times
        Mockito.verify(mockMembershipRepository, Mockito.times(1)).findByMemberId(MEMBER.getId());
        Mockito.verify(mockAlertGroupRepository, Mockito.times(1)).findById(membership.getGroupId());
    }

    @Test
    public void testGetGroupMemberNotFound() {
        final AlertGroup alertGroup = new AlertGroup("AIA");
        alertGroup.setId(123L);
        final Membership membership = new Membership("123", alertGroup.getId(), true);
        membership.setId(1L);

        Mockito.when(mockMembershipRepository.findByMemberId("123")).thenReturn(List.of(membership));
        Mockito.when(mockAlertGroupRepository.findById(membership.getGroupId())).thenReturn(Optional.of(alertGroup));
        Mockito.when(mockMemberRepository.findById("123")).thenReturn(Optional.empty());
        Mockito.when(mockMembershipRepository.findByGroupId(membership.getGroupId())).thenReturn(List.of(membership));

        Assertions.assertThrows(RuntimeException.class, () -> controller.getGroups("123"));

        // These verifications confirm that each method with these parameters were used this number of times
        Mockito.verify(mockMembershipRepository, Mockito.times(1)).findByMemberId("123");
        Mockito.verify(mockMemberRepository, Mockito.times(1)).findById(membership.getMemberId());
        Mockito.verify(mockMembershipRepository, Mockito.times(1)).findByGroupId(membership.getGroupId());
        Mockito.verify(mockAlertGroupRepository, Mockito.times(1)).findById(membership.getGroupId());
    }
}
