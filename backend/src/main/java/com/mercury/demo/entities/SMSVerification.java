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
    private String phoneNumber;

    @NotNull
    private String countryCode;

    @NotNull
    private String verificationCodeHash;

    @NotNull
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
