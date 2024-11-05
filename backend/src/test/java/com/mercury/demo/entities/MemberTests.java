package com.mercury.demo.entities;

import org.junit.jupiter.api.Test;

public class MemberTests {

    @Test
    public void test() {
        String firstName = "First";
        String lastName = "Last";
        String countryCode = "1";
        String phone = "6501234565";

        Member member = new Member(firstName, lastName, countryCode, phone);

        assert(member.getFirstName().equals(firstName));
        assert(member.getLastName().equals(lastName));
        assert(member.getCountryCode().equals(countryCode));
        assert(member.getPhoneNumber().equals(phone));
    }
}
