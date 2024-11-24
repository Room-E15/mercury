package com.mercury.demo.entities;

import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;

public class TestSMSVerification {
    private static final String VERIFICATION_HASH = "HASH";
    private static final int COUNTRY_CODE = 1;
    private static final String PHONE = "6501234565";
    private static final Long EXPIRATION = 1200L;
    private static final boolean VERIFIED = false;
    private static final SMSVerification VERIFICATION = new SMSVerification(COUNTRY_CODE, PHONE, EXPIRATION, VERIFICATION_HASH);
    private static final SMSVerification VERIFICATION_WITH_ID = new SMSVerification("id", PHONE, COUNTRY_CODE,VERIFICATION_HASH, VERIFIED, EXPIRATION);

    @Test
    public void testSMSVerificationConstructor() {
        Assertions.assertEquals(COUNTRY_CODE, VERIFICATION.getCountryCode());
        Assertions.assertEquals(EXPIRATION, VERIFICATION.getExpiration());
        Assertions.assertEquals(PHONE, VERIFICATION.getPhoneNumber());
        Assertions.assertEquals(VERIFICATION_HASH, VERIFICATION.getVerificationCodeHash());
    }

    @Test
    public void testMemberToString() {
        final String expectedString = String.format("SMSVerification(id=null, phoneNumber=%s, countryCode=%s, verificationCodeHash=%s, verified=%s, expiration=%s)",
                PHONE, COUNTRY_CODE, VERIFICATION_HASH, VERIFIED, EXPIRATION);

        Assertions.assertEquals(expectedString, VERIFICATION.toString());
    }

    @Test
    public void testSMSVerificationHashCode() {
        final int expectedHashCode = VERIFICATION.hashCode();

        Assertions.assertEquals(expectedHashCode, VERIFICATION.hashCode());
    }

    @Test
    public void testSMSVerificationEqualsTrue() {
        Assertions.assertTrue(VERIFICATION.equals(VERIFICATION));
    }

    @Test
    public void testSMSVerificationEqualsFalse() {
        Assertions.assertFalse(VERIFICATION.equals(new SMSVerification(2, PHONE, EXPIRATION, VERIFICATION_HASH)));
    }

    @Test
    public void testSMSVerificationAllArgsConstructor() {
        final SMSVerification expectedConstructor = VERIFICATION_WITH_ID;

        Assertions.assertEquals(expectedConstructor, VERIFICATION_WITH_ID);
    }
}
