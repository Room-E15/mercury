package com.mercury.demo.entities;

import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;

class TestCarrier {
    private static final String CARRIER_GATEWAY = "txt.testmobile.dev";
    private static final String CARRIER_NAME = "Test Mobile";
    private static final String CARRIER_ID = "testmobile";
    private static final String PHONE_NUMBER = "1234567890";
    private static final int COUNTRY_CODE = 1;
    private static final Carrier CARRIER = new Carrier(CARRIER_ID, CARRIER_NAME, CARRIER_GATEWAY, false);

    @Test
    void testFormatTextGateway() {
        final String expectedFormat = String.format("%s@%s", PHONE_NUMBER, CARRIER_GATEWAY);

        Assertions.assertEquals(expectedFormat, CARRIER.formatTextGateway(COUNTRY_CODE, PHONE_NUMBER));
    }

    @Test
    void testFormatTextGatewayWithCountryCode() {
        final Carrier carrierWithCountryCode = new Carrier(CARRIER_ID, CARRIER_NAME, CARRIER_GATEWAY, true);
        final String expectedFormat = String.format("%s%s@%s", COUNTRY_CODE, PHONE_NUMBER, CARRIER_GATEWAY);

        Assertions.assertEquals(expectedFormat, carrierWithCountryCode.formatTextGateway(COUNTRY_CODE, PHONE_NUMBER));
    }

    @Test
    void testCarrierToString() {
        final String expectedString = String.format("Carrier(id=%s, carrierName=%s, textGateway=%s, includeCountryCodeInEmail=%s)",
                CARRIER_ID, CARRIER_NAME, CARRIER_GATEWAY, false);

        Assertions.assertEquals(expectedString, CARRIER.toString());
    }

    @Test
    void testCarrierHashCode() {
        final int expectedHashCode = CARRIER.hashCode();

        Assertions.assertEquals(expectedHashCode, CARRIER.hashCode());
    }

    @Test
    void testCarrierEqualsTrue() {
        final Carrier equalCarrier = new Carrier(CARRIER_ID, CARRIER_NAME, CARRIER_GATEWAY, false);

        Assertions.assertEquals(CARRIER, equalCarrier);
    }

    @Test
    void testCarrierEqualsFalse() {
        final Carrier equalCarrier = new Carrier(CARRIER_ID, CARRIER_NAME, CARRIER_GATEWAY, true);

        Assertions.assertNotEquals(CARRIER, equalCarrier);
    }

    @Test
    void testCarrierSetter() {
        final Carrier newCarrier = new Carrier(CARRIER_ID, CARRIER_NAME, CARRIER_GATEWAY, true);
        final String expectedId = "newId";

        newCarrier.setId(expectedId);
        Assertions.assertEquals(expectedId, newCarrier.getId());
    }
}
