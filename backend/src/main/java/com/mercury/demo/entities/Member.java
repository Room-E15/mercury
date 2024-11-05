package com.mercury.demo.entities;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@AllArgsConstructor
@NoArgsConstructor
public class Member {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    @NotNull
    @Getter
    @Setter
    private String firstName;

    @NotNull
    @Getter
    @Setter
    private String lastName;

    @NotNull
    @Getter
    @Setter
    private String areaCode;

    @NotNull
    @Getter
    @Setter
    private String phoneNumber;

    public Member(final String firstName, final String lastName, final String areaCode, final String phoneNumber) {
        this.firstName = firstName;
        this.lastName = lastName;
        this.areaCode = areaCode;
        this.phoneNumber = phoneNumber;
    }
}
