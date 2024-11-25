package com.mercury.demo.entities;

import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;

class TestAlertGroup {
    private static final String GROUP_NAME = "AIA";
    private static final AlertGroup GROUP = new AlertGroup(GROUP_NAME);

    @Test
    void testAlertGroupToString() {
        final String expectedString = String.format("AlertGroup(id=null, groupName=%s)",
                GROUP_NAME);

        Assertions.assertEquals(expectedString, GROUP.toString());
    }

    @Test
    void testAlertGroupHashCode() {
        final int expectedHashCode = GROUP.hashCode();

        Assertions.assertEquals(expectedHashCode, GROUP.hashCode());
    }

    @Test
    void testAlertGroupSetter() {
        final AlertGroup group = new AlertGroup(GROUP_NAME);
        final String expectedId = "newId";
        final String expectedGroup = "newGroup";

        group.setId(expectedId);
        group.setGroupName(expectedGroup);

        Assertions.assertEquals(expectedId, group.getId());
        Assertions.assertEquals(expectedGroup, group.getGroupName());
    }

    @Test
    void testAlertGroupEqualsTrue() {
        Assertions.assertEquals(GROUP, GROUP);
    }

    @Test
    void testAlertGroupEqualsFalse() {
        Assertions.assertNotEquals(GROUP, new AlertGroup("AI"));
    }
}
