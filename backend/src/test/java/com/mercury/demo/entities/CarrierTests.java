package com.mercury.demo.entities;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

public class CarrierTests {

    @Test
    public void formatTextGatewayTest() {
        final String carrierGateway = "txt.testmobile.dev";
        final String carrierName = "Test Mobile";
        final String carrierId = "testmobile";
        final String phoneNumber = "1234567890";

        Carrier carrier = new Carrier(carrierId, carrierName, carrierGateway, false);
        final String formatted = carrier.formatTextGateway("1", phoneNumber);
        assertEquals(formatted, "%s@%s".formatted(phoneNumber, carrierGateway));
    }
}
