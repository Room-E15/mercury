package com.mercury.demo.entities.responses;

import com.mercury.demo.entities.Alert;
import com.mercury.demo.entities.Member;
import com.mercury.demo.entities.MemberAlertResponse;
import lombok.EqualsAndHashCode;
import lombok.Getter;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Getter
@EqualsAndHashCode(callSuper = true)
class MemberWithResponse extends Member {
    private final MemberAlertResponse response;
    public MemberWithResponse(Member member, MemberAlertResponse response) {
        super(member);
        this.response = response;
    }
}

// If the user is not a leader, responses will be null
public class GetGroupsResponse extends HashMap<String, Object> {
    // Constructors for leader group response, leaders provide a map of responses

    // Without alert
    public GetGroupsResponse(final String groupId, final String name, final boolean isLeader, final List<Member> members,
                             final List<Member> leaders, final Map<String, MemberAlertResponse> memberToResponses) {
        super.put("id", groupId);
        super.put("name", name);
        super.put("isLeader", isLeader);

        // If the member is a leader, members and leaders will be lists of members with their responses (if that member has responded).
        // If the member is not a leader, no members will have responses

        if (!memberToResponses.isEmpty()) {
            super.put("members", members.stream().map(member -> getMemberWithResponse(member, memberToResponses)).toList());
            super.put("leaders", leaders.stream().map(leader -> getMemberWithResponse(leader, memberToResponses)).toList());
        } else {
            super.put("members", members);
            super.put("leaders", leaders);
        }
    }

    // With alert
    public GetGroupsResponse(final String groupId, final String name, final boolean isLeader, final Alert latestAlert, final List<Member> members,
                             final List<Member> leaders, final Map<String, MemberAlertResponse> memberToResponses) {
        this(groupId, name, isLeader, members, leaders, memberToResponses);
        super.put("latestAlert", latestAlert);
    }

    // Constructor for member group response, a leader would call the constructor with responses
    public GetGroupsResponse(final String groupId, final String name, final boolean isLeader, final List<Member> members,
                             final List<Member> leaders) {
        this(groupId, name, isLeader, members, leaders, new HashMap<>());
    }

    // Attaches a response to a member if present
    private Member getMemberWithResponse(final Member member, final Map<String, MemberAlertResponse> memberToResponses) {
        if (memberToResponses.containsKey(member.getId())) {
            return new MemberWithResponse(member, memberToResponses.get(member.getId()));
        } else {
            return member;
        }
    }
}
