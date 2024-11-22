package com.mercury.demo.entities.responses;

import com.mercury.demo.entities.Member;
import com.mercury.demo.entities.MemberAlertResponse;

import java.util.HashMap;
import java.util.List;

// If the user is not a leader, responses will be null
public class GetGroupsResponse extends HashMap<String, Object> {
    public GetGroupsResponse(final String id, final String name, final List<Member> members,
                             final List<Member> leaders, final List<MemberAlertResponse> responses) {
        super.put("id", id);
        super.put("name", name);
        super.put("members", members);
        super.put("leaders", leaders);
        super.put("responses", responses);
    }
}
