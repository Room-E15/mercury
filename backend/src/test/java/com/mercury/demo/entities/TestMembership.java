package com.mercury.demo.entities;

import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;

import java.util.UUID;

class TestMembership {
    private static final String MEMBER_ID = UUID.randomUUID().toString();
    private static final String GROUP_ID = UUID.randomUUID().toString();
    private static final Membership MEMBERSHIP = new Membership(MEMBER_ID, GROUP_ID, true);

    @Test
    void testMembershipConstructor() {
        final Membership noConstructor = new Membership();

        Assertions.assertNotEquals(MEMBERSHIP, noConstructor);
    }

    @Test
    void testMembershipSetter() {
        final Membership response = new Membership();
        response.setMemberId(MEMBER_ID);
        response.setGroupId(GROUP_ID);
        response.setLeader(true);

        Assertions.assertEquals(MEMBERSHIP, response);
    }

    @Test
    void testMembershipToString() {
        final String expectedString = String.format("Membership(memberId=%s, groupId=%s, isLeader=true)",
                MEMBER_ID, GROUP_ID);

        Assertions.assertEquals(expectedString, MEMBERSHIP.toString());
    }
}
