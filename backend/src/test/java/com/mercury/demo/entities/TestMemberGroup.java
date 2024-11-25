package com.mercury.demo.entities;

import com.mercury.demo.entities.idclass.MemberGroup;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;

import java.util.UUID;

class TestMemberGroup {
    private static final String MEMBER_ID = UUID.randomUUID().toString();
    private static final String GROUP_ID = UUID.randomUUID().toString();
    private static final MemberGroup MEMBER_GROUP = new MemberGroup(MEMBER_ID, GROUP_ID);

    @Test
    void testMemberGroupConstructor() {
        final MemberGroup memberGroup = new MemberGroup();

        Assertions.assertNotEquals(MEMBER_GROUP, memberGroup);
    }

    @Test
    void testMemberAlertHashCode() {
        final int expectedHashCode = MEMBER_GROUP.hashCode();

        Assertions.assertEquals(expectedHashCode, MEMBER_GROUP.hashCode());
    }

    @Test
    void testMemberAlertEqualsTrue() {
        Assertions.assertEquals(MEMBER_GROUP, MEMBER_GROUP);
    }

    @Test
    void testMemberAlertEqualsFalse() {
        Assertions.assertNotEquals(MEMBER_GROUP, new MemberGroup(GROUP_ID, MEMBER_ID));
    }
}
