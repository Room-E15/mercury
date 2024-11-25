package com.mercury.demo.entities.responses;

import java.util.HashMap;

import com.mercury.demo.entities.Member;

public class SMSVerifyResponse extends HashMap<String, Object> {
    public SMSVerifyResponse(final boolean correctCode, final Member userInfo) {
        super.put("correctCode", correctCode);
        if (userInfo != null) super.put("userInfo", userInfo);
    }
}