package com.mercury.demo.entities.responses;

import com.mercury.demo.entities.Member;

import java.util.HashMap;
import java.util.List;

public class GetGroupsResponse extends HashMap<String, Object> {
    public GetGroupsResponse(final String id, final String name, final int memberCount, final int responseCount,
                             final int unsafe, final boolean isLeader, final List<Member> members, final List<Member> leaders) {
        super.put("id", id);
        super.put("name", name);
        super.put("memberCount", memberCount);
        super.put("responseCount", responseCount);
        super.put("unsafe", unsafe);
        super.put("isLeader", isLeader);
        super.put("members", members);
        super.put("leaders", leaders);
    }

    public GetGroupsResponse(final String id, final String name, final int memberCount,
                             final int unsafe, final boolean isLeader, final List<Member> members, final List<Member> leaders) {
        super.put("id", id);
        super.put("name", name);
        super.put("memberCount", memberCount);
        super.put("unsafe", unsafe);
        super.put("isLeader", isLeader);
        super.put("members", members);
        super.put("leaders", leaders);
    }
}
