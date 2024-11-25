package com.mercury.demo.entities.responses;

import com.mercury.demo.entities.Alert;
import com.mercury.demo.entities.Member;
import com.mercury.demo.entities.MemberAlertResponse;
import lombok.Getter;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

@Getter
class MemberWithResponse extends Member {
    private final MemberAlertResponse response;
    public MemberWithResponse(Member member, MemberAlertResponse response) {
        super(member);
        this.response = response;
    }

    @Override
    public boolean equals(Object o) {
        if (o == null || o.getClass() != MemberWithResponse.class) return false;
        final MemberWithResponse m = (MemberWithResponse) o;
        return this.response.equals(m.response)
                && this.getId().equals(m.getId())
                && this.getFirstName().equals(m.getFirstName())
                && this.getLastName().equals(m.getLastName())
                && this.getPhoneNumber().equals(m.getPhoneNumber())
                && this.getCountryCode() == m.getCountryCode();

    }

    @Override
    public int hashCode() {
        return Objects.hash(
                response,
                getId(),
                getFirstName(),
                getLastName(),
                getCountryCode(),
                getPhoneNumber()
        );
    }
}

// If the user is not a leader, responses will be null
public class GetGroupsResponse extends HashMap<String, Object> {
    final Map<String, MemberAlertResponse> memberToResponses;

    private Member getMemberWithResponse(Member member) {
        if (memberToResponses.containsKey(member.getId())) {
            return new MemberWithResponse(member, memberToResponses.get(member.getId()));
        } else {
            return member;
        }
    }

    // Constructors for leader group response, leaders provide a map of responses

    // Without alert
    public GetGroupsResponse(final String groupId, final String name, final boolean isLeader, final List<Member> members,
                             final List<Member> leaders, final Map<String, MemberAlertResponse> memberToResponses) {
        super.put("id", groupId);
        super.put("name", name);
        super.put("isLeader", isLeader);

        // If the member is a leader, members and leaders will be lists of members with their responses (if that member has responded).
        // If the member is not a leader, no members will have responses
        this.memberToResponses = memberToResponses;

        if (!memberToResponses.isEmpty()) {
            super.put("members", members.stream().map(this::getMemberWithResponse).toList());
            super.put("leaders", leaders.stream().map(this::getMemberWithResponse).toList());
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
}
