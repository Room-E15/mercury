package com.mercury.demo.entities.responses;

import java.util.HashMap;

public class JoinGroupResponse extends HashMap<String, Object> {
    public JoinGroupResponse(final String memberId, final String groupId) {
        super.put("memberId", memberId);
        super.put("groupId", groupId);
    }
}
