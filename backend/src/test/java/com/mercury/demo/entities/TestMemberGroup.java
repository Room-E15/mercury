package com.mercury.demo.entities;

import com.mercury.demo.entities.idclass.MemberGroup;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;

import java.util.UUID;

public class TestMemberGroup {
    private static final String MEMBER_ID = UUID.randomUUID().toString();
    private static final String GROUP_ID = UUID.randomUUID().toString();
    private static final MemberGroup MEMBER_GROUP = new MemberGroup(MEMBER_ID, GROUP_ID);

    @Test
    public void testMemberAlertHashCode() {
        final int expectedHashCode = MEMBER_GROUP.hashCode();

        Assertions.assertEquals(expectedHashCode, MEMBER_GROUP.hashCode());
    }

    @Test
    public void testMemberAlertEqualsTrue() {
        Assertions.assertTrue(MEMBER_GROUP.equals(MEMBER_GROUP));
    }

    @Test
    public void testMemberAlertEqualsFalse() {
        Assertions.assertFalse(MEMBER_GROUP.equals(new MemberGroup(GROUP_ID, MEMBER_ID)));
    }
}
