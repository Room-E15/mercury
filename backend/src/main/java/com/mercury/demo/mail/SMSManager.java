package com.mercury.demo.mail;

import com.mercury.demo.entities.Carrier;

public interface SMSManager {
    void dispatchSMS(final String code,
                     final String countryCode,
                     final String phoneNumber,
                     final Carrier carrier);
}