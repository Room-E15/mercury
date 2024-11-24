package com.mercury.demo.entities;

import com.fasterxml.jackson.annotation.JsonView;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.validation.constraints.NotNull;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;
import org.hibernate.annotations.UuidGenerator;

@Entity
@NoArgsConstructor
@Getter
@Setter
@EqualsAndHashCode
@ToString
@JsonView(Member.WithoutIdView.class)
public class Member {
    public interface WithoutIdView {}
    public interface WithIdView extends WithoutIdView {}

    @Id
    @UuidGenerator
    @JsonView(WithIdView.class)
    private String id;

    @NotNull
    private String firstName;

    @NotNull
    private String lastName;

    @NotNull
    private int countryCode;

    @NotNull
    private String phoneNumber;

    public Member(final String firstName, final String lastName, final int countryCode, final String phoneNumber) {
        this.firstName = firstName;
        this.lastName = lastName;
        this.countryCode = countryCode;
        this.phoneNumber = phoneNumber;
    }
}
