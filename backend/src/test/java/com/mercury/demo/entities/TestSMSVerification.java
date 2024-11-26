package com.mercury.demo.entities;

import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;

class TestSMSVerification {
    private static final String VERIFICATION_HASH = "HASH";
    private static final int COUNTRY_CODE = 1;
    private static final String PHONE = "6501234565";
    private static final Long EXPIRATION = 1200L;
    private static final boolean VERIFIED = false;
    private static final String CARRIER = "devcarrier";
    private static final SMSVerification VERIFICATION = new SMSVerification(COUNTRY_CODE, PHONE, CARRIER, EXPIRATION, VERIFICATION_HASH);
    private static final SMSVerification VERIFICATION_WITH_ID = new SMSVerification("id", COUNTRY_CODE, PHONE, CARRIER, VERIFICATION_HASH, VERIFIED, EXPIRATION);

    @Test
    void testSMSVerificationConstructor() {
        Assertions.assertEquals(COUNTRY_CODE, VERIFICATION.getCountryCode());
        Assertions.assertEquals(EXPIRATION, VERIFICATION.getExpiration());
        Assertions.assertEquals(PHONE, VERIFICATION.getPhoneNumber());
        Assertions.assertEquals(VERIFICATION_HASH, VERIFICATION.getVerificationCodeHash());
    }

    @Test
    void testMemberToString() {
        final String expectedString = String.format("SMSVerification(id=null, countryCode=%s, phoneNumber=%s, carrierId=%s, verificationCodeHash=%s, verified=%s, expiration=%s)",
                COUNTRY_CODE, PHONE, CARRIER, VERIFICATION_HASH, VERIFIED, EXPIRATION);

        Assertions.assertEquals(expectedString, VERIFICATION.toString());
    }

    @Test
    void testSMSVerificationHashCode() {
        final int expectedHashCode = VERIFICATION.hashCode();

        Assertions.assertEquals(expectedHashCode, VERIFICATION.hashCode());
    }

    @Test
    void testSMSVerificationEqualsTrue() {
        Assertions.assertEquals(VERIFICATION, VERIFICATION);
    }

    @Test
    void testSMSVerificationEqualsFalse() {
        Assertions.assertNotEquals(VERIFICATION, new SMSVerification(2, PHONE, CARRIER, EXPIRATION, VERIFICATION_HASH));
    }

    @Test
    void testSMSVerificationAllArgsConstructor() {
        final SMSVerification expectedConstructor = VERIFICATION_WITH_ID;

        Assertions.assertEquals(VERIFICATION_WITH_ID, expectedConstructor);
    }
}
