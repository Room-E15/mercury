package com.mercury.demo.controllers;

import com.mercury.demo.entities.AlertGroup;
import com.mercury.demo.entities.Member;
import com.mercury.demo.entities.Membership;
import com.mercury.demo.entities.exceptions.DatabaseStateException;
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

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

class TestGroupManagementController {
    private static final Member MEMBER = new Member("Giorno", "Giovanna", 123,
            "1226765555");
    private static final String PHONE_NUMBER = "1234567890";
    private static final String GROUP_NAME = "AIA";
    private static final String ALERT_GROUP_ID = UUID.randomUUID().toString();
    private static final AlertGroup ALERT_GROUP = new AlertGroup(GROUP_NAME);
    private static final String MEMBER_ID = UUID.randomUUID().toString();

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
        MEMBER.setId(MEMBER_ID);
        ALERT_GROUP.setId(ALERT_GROUP_ID);
    }

    @Test
    void testCreateGroup() {
        final AlertGroup expectedAlertGroup = new AlertGroup(GROUP_NAME);
        final Membership expectedMembership = new Membership(MEMBER.getId(), expectedAlertGroup.getId(), true);

        // Stubbings for functions that cannot be unit-tested as they are handled by external packages
        Mockito.when(mockMemberRepository.findById(MEMBER.getId())).thenReturn(Optional.of(MEMBER));
        Mockito.when(mockMembershipRepository.save(expectedMembership)).thenReturn(expectedMembership);
        Mockito.when(mockAlertGroupRepository.save(expectedAlertGroup)).thenReturn(expectedAlertGroup);

        Assertions.assertEquals("Saved", controller.createGroup(GROUP_NAME, MEMBER_ID));

        Mockito.verify(mockMemberRepository, Mockito.times(1)).findById(MEMBER.getId());
        Mockito.verify(mockMembershipRepository, Mockito.times(1)).save(expectedMembership);
        Mockito.verify(mockAlertGroupRepository, Mockito.times(1)).save(expectedAlertGroup);
    }

    @Test
    void testCreateGroupUserNotFound() {
        // Stubbings for functions that cannot be unit-tested as they are handled by external packages
        Mockito.when(mockMemberRepository.findById(MEMBER.getId())).thenReturn(Optional.empty());

        Assertions.assertThrows(DatabaseStateException.class, () -> controller.createGroup(GROUP_NAME, MEMBER_ID));

        Mockito.verify(mockMemberRepository, Mockito.times(1)).findById(MEMBER.getId());
    }

    @Test
    void testJoinGroup() {
        final AlertGroup alertGroup = new AlertGroup(GROUP_NAME);
        alertGroup.setId(PHONE_NUMBER);
        final Member member = new Member("Test", "ing", 1, PHONE_NUMBER);

        final Membership membership = new Membership(member.getId(), alertGroup.getId(), false);

        final JoinGroupResponse expectedJoinGroupResponse = new JoinGroupResponse(member.getId(), alertGroup.getId());

        // Stubbings for functions that cannot be unit-tested as they are handled by external packages
        Mockito.when(mockMemberRepository.findById(member.getId())).thenReturn(Optional.of(member));
        Mockito.when(mockAlertGroupRepository.findById(alertGroup.getId())).thenReturn(Optional.of(alertGroup));
        Mockito.when(mockMembershipRepository.save(membership)).thenReturn(membership);

        Assertions.assertEquals(expectedJoinGroupResponse, controller.joinGroup(member.getId(), alertGroup.getId()));

        Mockito.verify(mockMemberRepository).findById(member.getId());
        Mockito.verify(mockAlertGroupRepository).findById(alertGroup.getId());
        Mockito.verify(mockMembershipRepository).save(membership);
    }

    @Test
    void testJoinGroupUserNotFound() {
        // Stubbings for functions that cannot be unit-tested as they are handled by external packages
        Mockito.when(mockMemberRepository.findById(MEMBER.getId())).thenReturn(Optional.empty());

        Assertions.assertThrows(DatabaseStateException.class, () -> controller.joinGroup(MEMBER_ID, PHONE_NUMBER));

        Mockito.verify(mockMemberRepository, Mockito.times(1)).findById(MEMBER.getId());
    }

    @Test
    void testJoinGroupGroupNotFound() {
        Mockito.when(mockMemberRepository.findById(MEMBER_ID)).thenReturn(Optional.of(MEMBER));
        Mockito.when(mockAlertGroupRepository.findById(ALERT_GROUP.getId())).thenReturn(Optional.empty());

        Assertions.assertThrows(DatabaseStateException.class, () -> controller.joinGroup(MEMBER_ID, ALERT_GROUP_ID));

        Mockito.verify(mockMemberRepository, Mockito.times(1)).findById(MEMBER_ID);
        Mockito.verify(mockAlertGroupRepository, Mockito.times(1)).findById(ALERT_GROUP.getId());
    }

    @Test
    void testGetGroupWithOneMember() {
        final AlertGroup alertGroup = new AlertGroup(GROUP_NAME);
        alertGroup.setId(PHONE_NUMBER);
        final Membership membership = new Membership(MEMBER.getId(), alertGroup.getId(), true);
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
    void testGetGroupWithTwoMembers() {
        final AlertGroup alertGroup = new AlertGroup(GROUP_NAME);
        alertGroup.setId(PHONE_NUMBER);
        final Member memberTwo = new Member("Test", "ing", 4, PHONE_NUMBER);
        memberTwo.setId("1234");
        final Membership membership = new Membership(MEMBER.getId(), alertGroup.getId(), true);
        final Membership membershipTwo = new Membership(memberTwo.getId(), alertGroup.getId(), false);
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
    void testGetGroupWithNoGroups() {
        final List<GetGroupsResponse> expectedResponses = new ArrayList<>();

        Mockito.when(mockMembershipRepository.findByMemberId(MEMBER_ID)).thenReturn(List.of());

        Assertions.assertEquals(expectedResponses, controller.getGroups(MEMBER.getId()));

        // These verifications confirm that each method with these parameters were used this number of times
        Mockito.verify(mockMembershipRepository, Mockito.times(1)).findByMemberId(MEMBER.getId());
    }

    @Test
    void testGetGroupWithOneGroup() {
        final Membership membership = new Membership(MEMBER_ID, ALERT_GROUP_ID, true);
        final GetGroupsResponse expectedResponse = new GetGroupsResponse(ALERT_GROUP_ID, ALERT_GROUP.getGroupName(), 1, 0,
                true, List.of(), List.of(MEMBER));

        Mockito.when(mockMembershipRepository.findByMemberId(MEMBER_ID)).thenReturn(List.of(membership));
        Mockito.when(mockAlertGroupRepository.findById(ALERT_GROUP_ID)).thenReturn(Optional.of(ALERT_GROUP));
        Mockito.when(mockMembershipRepository.findByGroupId(ALERT_GROUP_ID)).thenReturn(List.of(membership));
        Mockito.when(mockMemberRepository.findById(MEMBER.getId())).thenReturn(Optional.of(MEMBER));

        Assertions.assertEquals(List.of(expectedResponse), controller.getGroups(MEMBER.getId()));

        // These verifications confirm that each method with these parameters were used this number of times
        Mockito.verify(mockMembershipRepository, Mockito.times(1)).findByMemberId(MEMBER.getId());
        Mockito.verify(mockAlertGroupRepository, Mockito.times(1)).findById(Mockito.anyString());
        Mockito.verify(mockMemberRepository, Mockito.times(1)).findById(MEMBER.getId());
        Mockito.verify(mockMembershipRepository, Mockito.times(1)).findByGroupId(Mockito.anyString());
    }

    @Test
    void testGetGroupWithTwoGroups() {
        final AlertGroup alertGroup = new AlertGroup(GROUP_NAME);
        alertGroup.setId(PHONE_NUMBER);
        final AlertGroup alertGroupTwo = new AlertGroup("Test");
        alertGroupTwo.setId("0987654321");
        final Membership membership = new Membership(MEMBER.getId(), alertGroup.getId(), true);
        final Membership membershipTwo = new Membership(MEMBER.getId(), alertGroupTwo.getId(), false);
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
    void testGetGroupWithTwentyGroups() {
        final List<Membership> memberships = new ArrayList<>();
        final List<GetGroupsResponse> expectedResponses = new ArrayList<>();
        for (int i = 0; i < 20; i++) {
            final Membership newMembership = new Membership(MEMBER_ID, String.valueOf(i), i == 0);
            memberships.add(newMembership);
            final AlertGroup newAlertGroup = new AlertGroup("Group" + i);
            newAlertGroup.setId(String.valueOf(i));
            expectedResponses.add(new GetGroupsResponse(newAlertGroup.getId(), newAlertGroup.getGroupName(), 1, 0,
                    newMembership.isLeader(), i != 0 ? List.of(MEMBER) : List.of(), i == 0 ? List.of(MEMBER) : List.of()));

            Mockito.when(mockAlertGroupRepository.findById(newAlertGroup.getId())).thenReturn(Optional.of(newAlertGroup));
            Mockito.when(mockMembershipRepository.findByGroupId(newAlertGroup.getId())).thenReturn(List.of(newMembership));
            Mockito.when(mockMemberRepository.findById(MEMBER.getId())).thenReturn(Optional.of(MEMBER));
        }
        Mockito.when(mockMembershipRepository.findByMemberId(MEMBER_ID)).thenReturn(memberships);

        Assertions.assertEquals(expectedResponses, controller.getGroups(MEMBER.getId()));

        // These verifications confirm that each method with these parameters were used this number of times
        Mockito.verify(mockMembershipRepository, Mockito.times(1)).findByMemberId(MEMBER.getId());
        Mockito.verify(mockAlertGroupRepository, Mockito.times(20)).findById(Mockito.anyString());
        Mockito.verify(mockMemberRepository, Mockito.times(20)).findById(MEMBER.getId());
        Mockito.verify(mockMembershipRepository, Mockito.times(20)).findByGroupId(Mockito.anyString());
    }


    @Test
    void testGetGroupGroupNotFound() {
        final Membership membership = new Membership(MEMBER.getId(), "1234567890", true);

        Mockito.when(mockMembershipRepository.findByMemberId(MEMBER.getId())).thenReturn(List.of(membership));
        Mockito.when(mockAlertGroupRepository.findById(membership.getGroupId())).thenReturn(Optional.empty());

        Assertions.assertThrows(DatabaseStateException.class, () -> controller.getGroups(MEMBER_ID));

        // These verifications confirm that each method with these parameters were used this number of times
        Mockito.verify(mockMembershipRepository, Mockito.times(1)).findByMemberId(MEMBER.getId());
        Mockito.verify(mockAlertGroupRepository, Mockito.times(1)).findById(membership.getGroupId());
    }

    @Test
    void testGetGroupMemberNotFound() {
        final AlertGroup alertGroup = new AlertGroup(GROUP_NAME);
        alertGroup.setId(PHONE_NUMBER);
        final Membership membership = new Membership(MEMBER_ID, alertGroup.getId(), true);

        Mockito.when(mockMembershipRepository.findByMemberId(MEMBER_ID)).thenReturn(List.of(membership));
        Mockito.when(mockAlertGroupRepository.findById(membership.getGroupId())).thenReturn(Optional.of(alertGroup));
        Mockito.when(mockMemberRepository.findById(MEMBER_ID)).thenReturn(Optional.empty());
        Mockito.when(mockMembershipRepository.findByGroupId(membership.getGroupId())).thenReturn(List.of(membership));

        Assertions.assertThrows(DatabaseStateException.class, () -> controller.getGroups(MEMBER_ID));

        // These verifications confirm that each method with these parameters were used this number of times
        Mockito.verify(mockMembershipRepository, Mockito.times(1)).findByMemberId(MEMBER_ID);
        Mockito.verify(mockMemberRepository, Mockito.times(1)).findById(membership.getMemberId());
        Mockito.verify(mockMembershipRepository, Mockito.times(1)).findByGroupId(membership.getGroupId());
        Mockito.verify(mockAlertGroupRepository, Mockito.times(1)).findById(membership.getGroupId());
    }
}
