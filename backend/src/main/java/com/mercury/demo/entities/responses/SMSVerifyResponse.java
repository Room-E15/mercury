package com.mercury.demo.entities.responses;

import java.util.HashMap;

import com.mercury.demo.entities.Member;

public class SMSVerifyResponse extends HashMap<String, Object> {
    public SMSVerifyResponse(boolean correctCode, Member userInfo) {
        super.put("correctCode", correctCode);
        super.put("userInfo", userInfo);
    }
}