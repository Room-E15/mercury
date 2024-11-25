package com.mercury.demo.entities;

import org.junit.jupiter.api.Test;

import org.junit.jupiter.api.Assertions;

class CarrierTests {

    @Test
    void formatTextGatewayTest() {
        final String carrierGateway = "%s@txt.testmobile.dev";
        final String carrierName = "Test Mobile";
        final String carrierId = "testmobile";
        final String phoneNumber = "1234567890";

        final Carrier carrier = new Carrier(Carrier.CommType.SMS, carrierId, carrierName, carrierGateway, false);
        final String expected = carrierGateway.formatted(phoneNumber);
        Assertions.assertEquals(expected, carrier.formatTextGateway(1, phoneNumber));
    }
}
