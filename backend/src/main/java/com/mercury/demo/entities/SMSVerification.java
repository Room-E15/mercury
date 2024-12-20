package com.mercury.demo.entities;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;
import org.hibernate.annotations.UuidGenerator;

@Entity
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@EqualsAndHashCode
@ToString
public class SMSVerification {
    @Id
    @UuidGenerator
    private String id;

    @NotNull
    private int countryCode;

    @NotNull
    private String phoneNumber;

    @NotNull
    private String carrierId;

    @NotNull
    private String verificationCodeHash;

    @NotNull
    private boolean verified = false;

    @NotNull
    private long expiration;

    public SMSVerification(final int countryCode,
                           final String phoneNumber,
                           final String carrierId,
                           final long expiration,
                           final String verificationCodeHash) {
        this.countryCode = countryCode;
        this.phoneNumber = phoneNumber;
        this.carrierId = carrierId;
        this.expiration = expiration;
        this.verificationCodeHash = verificationCodeHash;
    }
}
