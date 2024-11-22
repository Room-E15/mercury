package com.mercury.demo.entities;

import com.mercury.demo.entities.idclass.MemberAlert;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;

import java.util.UUID;

public class TestMemberAlert {
    private static final String ALERT_ID = UUID.randomUUID().toString();
    private static final String MEMBER_ID = UUID.randomUUID().toString();
    private static final MemberAlert MEMBER_ALERT = new MemberAlert(MEMBER_ID, ALERT_ID);

    @Test
    public void testMemberAlertConstructor() {
        final MemberAlert alert = new MemberAlert();

        Assertions.assertNotEquals(alert, MEMBER_ALERT);
    }

    @Test
    public void testMemberAlertHashCode() {
        final int expectedHashCode = MEMBER_ALERT.hashCode();

        Assertions.assertEquals(expectedHashCode, MEMBER_ALERT.hashCode());
    }

    @Test
    public void testMemberAlertEqualsTrue() {
        Assertions.assertTrue(MEMBER_ALERT.equals(MEMBER_ALERT));
    }

    @Test
    public void testMemberAlertEqualsFalse() {
        Assertions.assertFalse(MEMBER_ALERT.equals(new MemberAlert(ALERT_ID, MEMBER_ID)));
    }
}
