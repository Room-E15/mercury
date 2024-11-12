package com.mercury.demo.mail;

import com.mercury.demo.entities.Carrier;

public interface SMSManager {
    void dispatchSMS(String code, String countryCode, String phoneNumber, Carrier carrier);
}