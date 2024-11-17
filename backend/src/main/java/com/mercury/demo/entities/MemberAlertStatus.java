package com.mercury.demo.entities;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;


@Entity
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@EqualsAndHashCode
@ToString
public class MemberAlertStatus {
   public enum Status {
        UNSEEN,
        SEEN,
        SAFE,
        UNSAFE
    }

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    @NotNull
    private String alertId;

    @NotNull
    private String memberId;

    @NotNull
    private Status status;

    public MemberAlertStatus(final String alertId, final String memberId,
                             final Status status) {
        this.alertId = alertId;
        this.memberId = memberId;
        this.status = status;
    }
}