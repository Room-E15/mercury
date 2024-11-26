package com.mercury.demo.entities;

import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;

class TestMember {
    private static final String FIRST_NAME = "Giorno";
    private static final String LAST_NAME = "Giovanna";
    private static final int COUNTRY_CODE = 1;
    private static final String PHONE_NUMBER = "1234567890";
    private static final String CARRIER = "devcarrier";
    private static final Member MEMBER = new Member(FIRST_NAME, LAST_NAME, COUNTRY_CODE, PHONE_NUMBER, CARRIER);

    @Test
    void testMemberToString() {
        final String expectedString = String.format("Member(id=null, firstName=%s, lastName=%s, countryCode=%s, phoneNumber=%s, carrierId=%s)",
                FIRST_NAME, LAST_NAME, COUNTRY_CODE, PHONE_NUMBER, CARRIER);

        Assertions.assertEquals(expectedString, MEMBER.toString());
    }

    @Test
    void testAlertHashCode() {
        final int expectedHashCode = MEMBER.hashCode();

        Assertions.assertEquals(expectedHashCode, MEMBER.hashCode());
    }
}
