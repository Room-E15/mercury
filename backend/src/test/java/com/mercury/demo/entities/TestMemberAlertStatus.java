package com.mercury.demo.entities;

import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;

import java.time.Instant;
import java.util.UUID;

public class TestMemberAlertStatus {
    private static final String MEMBER_ID = UUID.randomUUID().toString();
    private static final String ALERT_ID = UUID.randomUUID().toString();
    private static final MemberAlertStatus ALERT_STATUS = new MemberAlertStatus(ALERT_ID, MEMBER_ID, MemberAlertStatus.Status.UNSEEN);

    @Test
    public void testMemberAlertStatusConstructor() {
        final MemberAlertStatus noConstructor = new MemberAlertStatus();
        final MemberAlertStatus allConstructor = new MemberAlertStatus(ALERT_ID, MEMBER_ID, Instant.now(), MemberAlertStatus.Status.UNSEEN);

        Assertions.assertNotEquals(noConstructor, allConstructor);
    }

    @Test
    public void testMemberAlertStatusSetter() {
        final MemberAlertStatus response = new MemberAlertStatus();
        response.setAlertId(ALERT_ID);
        response.setMemberId(MEMBER_ID);
        response.setStatus(MemberAlertStatus.Status.UNSEEN);

        Assertions.assertEquals(response, ALERT_STATUS);
    }

    @Test
    public void testMemberAlertStatusToString() {
        final String expectedString = String.format("MemberAlertStatus(alertId=%s, memberId=%s, lastSeen=null, status=UNSEEN)",
                ALERT_ID, MEMBER_ID, MemberAlertStatus.Status.UNSEEN);

        Assertions.assertEquals(expectedString, ALERT_STATUS.toString());
    }
}
