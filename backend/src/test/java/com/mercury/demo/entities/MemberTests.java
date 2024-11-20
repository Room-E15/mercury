package com.mercury.demo.entities;

import org.junit.jupiter.api.Test;

import org.junit.jupiter.api.Assertions;

public class MemberTests {

    @Test
    public void test() {
        final String firstName = "First";
        String lastName = "Last";
        int countryCode = 1;
        String phone = "6501234565";

        final Member member = new Member(firstName, lastName, countryCode, phone);

        Assertions.assertEquals(firstName, member.getFirstName());
        Assertions.assertEquals(lastName, member.getLastName());
        Assertions.assertEquals(countryCode, member.getCountryCode());
        Assertions.assertEquals(phone, member.getPhoneNumber());
    }
}
