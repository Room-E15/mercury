package com.mercury.demo.controllers;

import com.mercury.demo.entities.Alert;
import com.mercury.demo.entities.AlertGroup;
import com.mercury.demo.entities.Member;
import com.mercury.demo.entities.MemberAlertResponse;
import com.mercury.demo.entities.Membership;
import com.mercury.demo.entities.exceptions.DatabaseStateException;
import com.mercury.demo.entities.responses.GetGroupsResponse;
import com.mercury.demo.entities.responses.JoinGroupResponse;
import com.mercury.demo.repositories.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.function.Function;
import java.util.stream.Collectors;

@RestController // This means that this class is a Controller
@RequestMapping(path="/group") // This means URL's start with /group (after Application path)
public class GroupManagementController {
    private final AlertGroupRepository alertGroupRepository;

    private final MembershipRepository membershipRepository;

    private final MemberRepository memberRepository;

    private final AlertRepository alertRepository;

    private final MemberAlertResponseRepository responseRepository;

    // This means to get the bean called userRepository
    // Which is auto-generated by Spring, we will use it to handle the data
    @Autowired
    public GroupManagementController(final AlertGroupRepository alertGroupRepository,
                                     final MembershipRepository membershipRepository,
                                     final MemberRepository memberRepository,
                                     final AlertRepository alertRepository,
                                     final MemberAlertResponseRepository responseRepository) {
        this.alertGroupRepository = alertGroupRepository;
        this.membershipRepository = membershipRepository;
        this.memberRepository = memberRepository;
        this.alertRepository = alertRepository;
        this.responseRepository = responseRepository;
    }

    @PostMapping(path="/createGroup") // Map ONLY POST Requests
    public String createGroup (@RequestParam final String groupName,
                               @RequestParam final String memberId
    ) {
        AlertGroup group = new AlertGroup(groupName);
        final Optional<Member> user = memberRepository.findById(memberId);

        if (user.isEmpty()) {
            throw new DatabaseStateException(String.format("User with the id %s not found", memberId));
        }
        group = alertGroupRepository.save(group);

        Membership membership = new Membership(user.get().getId(), group.getId(), true);

        membershipRepository.save(membership);
        return "Saved";
    }

    // TODO change to GET request
    @PostMapping(path="/getGroups") // Map ONLY POST Requests
    public List<GetGroupsResponse> getGroups (@RequestParam final String memberId
    ) {
        // TODO: optimize, this code has tooooo many streams
        final List<Membership> groupMemberships = membershipRepository.findByMemberId(memberId);
        List<GetGroupsResponse> groupResponseList = new ArrayList<>();

        for (final Membership membership : groupMemberships) {
            final AlertGroup correspondingGroup = alertGroupRepository.findById(membership.getGroupId()).orElseThrow(() -> new DatabaseStateException(
                    String.format("Corresponding group with groupId %s not found.", membership.getGroupId())));

            final List<Membership> allMembersInGroup = membershipRepository.findByGroupId(correspondingGroup.getId());
            final Map<Membership, Member> membersByMembership = allMembersInGroup.stream().collect(Collectors.toMap(Function.identity(),
                    newMembership -> memberRepository.findById(newMembership.getMemberId()).orElseThrow(() -> new DatabaseStateException(String.format("Corresponding member with memberId %s not found.", membership.getMemberId())))));

            final List<Member> membersList = membersByMembership.entrySet().stream().filter(entry -> !entry.getKey().isLeader()).map(Map.Entry::getValue).toList();
            final List<Member> leadersList = membersByMembership.entrySet().stream().filter(entry -> entry.getKey().isLeader()).map(Map.Entry::getValue).toList();
            final List<Member> allMembers = new ArrayList<>(membersList);
            allMembers.addAll(leadersList);

            Optional<Alert> latestAlert = alertRepository.findFirstByGroupIdOrderByCreationTimeDesc(correspondingGroup.getId());

            if (membership.isLeader() && latestAlert.isPresent()) {
                // get map of latest responses to link members to their responses
                Map<String, MemberAlertResponse> memberToLatestResponses = allMembers
                        .stream()
                        .map(member -> responseRepository.findFirstByMemberIdAndAlertIdOrderByCreationTimeDesc(member.getId(), latestAlert.get().getId()))
                        .filter(Optional::isPresent)
                        .map(Optional::get)
                        .collect(Collectors.toMap(MemberAlertResponse::getMemberId, response -> response));

                groupResponseList.add(new GetGroupsResponse(correspondingGroup.getId(), correspondingGroup.getGroupName(), true, latestAlert.get(), membersList, leadersList, memberToLatestResponses));
            } else {
                groupResponseList.add(new GetGroupsResponse(correspondingGroup.getId(), correspondingGroup.getGroupName(), false, membersList, leadersList));
            }
        }
        return groupResponseList;
    }

    @PostMapping(path="/joinGroup") // Map ONLY POST Requests
    public JoinGroupResponse joinGroup (@RequestParam final String memberId,
                                        @RequestParam final String groupId
    ) {
        final Member user = memberRepository.findById(memberId).orElseThrow(() -> new DatabaseStateException(String.format("User with the id %s not found", memberId)));
        final AlertGroup group = alertGroupRepository.findById(groupId).orElseThrow(() -> new DatabaseStateException(String.format("Group with the id %s not found", groupId)));

        final Membership membership = new Membership(user.getId(), group.getId(), false);
        membershipRepository.save(membership);

        return new JoinGroupResponse(memberId, groupId);
    }
}