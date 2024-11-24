package com.mercury.demo.entities;

import com.mercury.demo.entities.idclass.MemberAlert;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;

import java.util.UUID;

class TestMemberAlert {
    private static final String ALERT_ID = UUID.randomUUID().toString();
    private static final String MEMBER_ID = UUID.randomUUID().toString();
    private static final MemberAlert MEMBER_ALERT = new MemberAlert(MEMBER_ID, ALERT_ID);

    @Test
    void testMemberAlertConstructor() {
        final MemberAlert alert = new MemberAlert();

        Assertions.assertNotEquals(MEMBER_ALERT, alert);
    }

    @Test
    void testMemberAlertHashCode() {
        final int expectedHashCode = MEMBER_ALERT.hashCode();

        Assertions.assertEquals(expectedHashCode, MEMBER_ALERT.hashCode());
    }

    @Test
    void testMemberAlertEqualsTrue() {
        Assertions.assertEquals(MEMBER_ALERT, MEMBER_ALERT);
    }

    @Test
    void testMemberAlertEqualsFalse() {
        Assertions.assertNotEquals(MEMBER_ALERT, new MemberAlert(ALERT_ID, MEMBER_ID));
    }
}
