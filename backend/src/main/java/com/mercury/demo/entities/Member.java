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
public class Member {
    @Id
    @UuidGenerator
    private String id;

    @NotNull
    @Setter
    private String firstName;

    @NotNull
    @Setter
    private String lastName;

    @NotNull
    @Setter
    private String countryCode;

    @NotNull
    @Setter
    private String phoneNumber;

    public Member(final String firstName, final String lastName, final String countryCode, final String phoneNumber) {
        this.firstName = firstName;
        this.lastName = lastName;
        this.countryCode = countryCode;
        this.phoneNumber = phoneNumber;
    }
}
