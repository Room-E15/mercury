package com.mercury.demo.entities;

import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;

import java.time.Instant;
import java.util.UUID;

class TestMemberAlertResponse {
    private static final String MEMBER_ID = UUID.randomUUID().toString();
    private static final String ALERT_ID = UUID.randomUUID().toString();
    private static final boolean IS_SAFE = true;
    private static final double LATITUDE = 10.0;
    private static final double LONGITUDE = 20.0;
    private static final int BATTERY = 70;
    private static final MemberAlertResponse ALERT_RESPONSE = new MemberAlertResponse(MEMBER_ID, ALERT_ID, IS_SAFE, LATITUDE, LONGITUDE, BATTERY);

    @Test
    void testMemberAlertResponseConstructor() {
        final MemberAlertResponse response = new MemberAlertResponse();
        final MemberAlertResponse allConstructor = new MemberAlertResponse(MEMBER_ID, ALERT_ID, Instant.now(), IS_SAFE, LATITUDE, LONGITUDE, BATTERY);

        Assertions.assertNotEquals(response, allConstructor);
    }

    @Test
    void testMemberAlertResponseSetter() {
        final MemberAlertResponse response = new MemberAlertResponse();
        response.setAlertId(ALERT_ID);
        response.setMemberId(MEMBER_ID);
        response.setIsSafe(IS_SAFE);
        response.setLatitude(LATITUDE);
        response.setLongitude(LONGITUDE);
        response.setBattery(BATTERY);

        Assertions.assertEquals(ALERT_RESPONSE, response);
    }

    @Test
    void testMemberAlertResponseToString() {
        final String expectedString = String.format("MemberAlertResponse(memberId=%s, alertId=%s, creationTime=null, isSafe=%s, latitude=%s, longitude=%s, battery=%s)",
                MEMBER_ID, ALERT_ID, IS_SAFE, LATITUDE, LONGITUDE, BATTERY);

        Assertions.assertEquals(expectedString, ALERT_RESPONSE.toString());
    }
}
