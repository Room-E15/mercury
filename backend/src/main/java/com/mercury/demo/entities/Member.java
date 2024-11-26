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
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@EqualsAndHashCode
@ToString
public class Member {
    @Id
    @UuidGenerator
    private String id;

    @NotNull
    private String firstName;

    @NotNull
    private String lastName;

    @NotNull
    private int countryCode;

    @NotNull
    private String phoneNumber;

    @NotNull
    private String carrierId;

    public Member(final String firstName, final String lastName, final int countryCode, final String phoneNumber, final String carrierId) {
        this.firstName = firstName;
        this.lastName = lastName;
        this.countryCode = countryCode;
        this.phoneNumber = phoneNumber;
        this.carrierId = carrierId;
    }

    public Member(final Member member) {
        this(member.id, member.firstName, member.lastName, member.countryCode, member.phoneNumber, member.carrierId);
    }
}