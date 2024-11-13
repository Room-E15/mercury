package com.mercury.demo.entities.responses;

import java.util.HashMap;

public class SMSDispatchResponse extends HashMap<String, Object> {
    public SMSDispatchResponse(final boolean carrierFound, final String token) {
        super.put("carrierFound", carrierFound);
        super.put("token", token);
    }
}