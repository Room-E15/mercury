package com.mercury.demo.entities;

import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;

public class TestAlert {
    private static final String GROUP_ID = "groupId";
    private static final String TITLE = "Title";
    private static final String DESCRIPTION = "Description";
    private static final Alert ALERT = new Alert(GROUP_ID, TITLE, DESCRIPTION);

    @Test
    public void testAlertToString() {
        final String expectedString = String.format("Alert(id=null, creationTime=null, groupId=%s, title=%s, description=%s)",
                GROUP_ID, TITLE, DESCRIPTION);

        Assertions.assertEquals(expectedString, ALERT.toString());
    }

    @Test
    public void testAlertHashCode() {
        final int expectedHashCode = ALERT.hashCode();

        Assertions.assertEquals(expectedHashCode, ALERT.hashCode());
    }
}
