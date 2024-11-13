package com.mercury.demo.entities;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.UuidGenerator;

@Getter
@Entity
@AllArgsConstructor
@NoArgsConstructor
public class SMSVerification {
    @Id
    @UuidGenerator
    private String id;

    @NotNull
    @Setter
    private String phoneNumber;

    @NotNull
    @Setter
    private String countryCode;

    @NotNull
    @Setter
    private String verificationCodeHash;

    @NotNull
    @Setter
    private long expiration;

    public SMSVerification(final String countryCode,
                           final String phoneNumber,
                           final long expiration,
                           final String verificationCodeHash) {
        this.countryCode = countryCode;
        this.phoneNumber = phoneNumber;
        this.expiration = expiration;
        this.verificationCodeHash = verificationCodeHash;
    }
}
