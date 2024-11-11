package com.mercury.demo.entities;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Setter
@Getter
@Entity
@NoArgsConstructor
public class Carrier {
    @Id
    @NotNull
    private String id;

    @NotNull
    private String carrierName;

    @NotNull
    private String textGateway;

    @NotNull
    private boolean includeCountryCodeInEmail;

    public Carrier(String id, String carrierName, String textGateway, boolean includeCountryCodeInEmail) {
        this.id = id;
        this.carrierName = carrierName;
        this.textGateway = textGateway;
        this.includeCountryCodeInEmail = includeCountryCodeInEmail;
    }

    public String formatTextGateway(final String countryCode, final String phoneNumber) {
        return (includeCountryCodeInEmail ? countryCode : "") + phoneNumber + "@" + textGateway;
    }
}
