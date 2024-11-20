package com.mercury.demo.entities.responses;

import com.mercury.demo.entities.Member;

import java.util.HashMap;

public class MemberAddResponse extends HashMap<String, Object> {
    public MemberAddResponse(Member member) {
        super.put("status", "success");
        super.put("user", member);
    }

    public MemberAddResponse(String message) {
        super.put("status", "error");
        super.put("description", message);
    }
}
