package com.mercury.demo.entities;

import org.junit.jupiter.api.Test;

import org.junit.jupiter.api.Assertions;

public class CarrierTests {

    @Test
    public void formatTextGatewayTest() {
        final String carrierGateway = "txt.testmobile.dev";
        final String carrierName = "Test Mobile";
        final String carrierId = "testmobile";
        final String phoneNumber = "1234567890";

        final Carrier carrier = new Carrier(carrierId, carrierName, carrierGateway, false);
        final String expected = "%s@%s".formatted(phoneNumber, carrierGateway);
        Assertions.assertEquals(expected, carrier.formatTextGateway(1, phoneNumber));
    }
}
