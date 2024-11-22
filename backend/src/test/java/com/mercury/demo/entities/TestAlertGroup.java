package com.mercury.demo.entities;

import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;

public class TestAlertGroup {
    private static final String GROUP_NAME = "AIA";
    private static final AlertGroup GROUP = new AlertGroup(GROUP_NAME);

    @Test
    public void testAlertGroupToString() {
        final String expectedString = String.format("AlertGroup(id=null, groupName=%s)",
                GROUP_NAME);

        Assertions.assertEquals(expectedString, GROUP.toString());
    }

    @Test
    public void testAlertGroupHashCode() {
        final int expectedHashCode = GROUP.hashCode();

        Assertions.assertEquals(expectedHashCode, GROUP.hashCode());
    }

    @Test
    public void testAlertGroupSetter() {
        final AlertGroup group = new AlertGroup(GROUP_NAME);
        final String expectedId = "newId";
        final String expectedGroup = "newGroup";

        group.setId(expectedId);
        group.setGroupName(expectedGroup);

        Assertions.assertEquals(expectedId, group.getId());
        Assertions.assertEquals(expectedGroup, group.getGroupName());
    }

    @Test
    public void testAlertGroupEqualsTrue() {
        Assertions.assertTrue(GROUP.equals(GROUP));
    }

    @Test
    public void testAlertGroupEqualsFalse() {
        Assertions.assertFalse(GROUP.equals(new AlertGroup("AI")));
    }
}
