package com.mercury.demo.entities;

import com.mercury.demo.entities.idclass.MemberAlert;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.IdClass;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.Instant;


@Entity
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@EqualsAndHashCode
@ToString
@IdClass(MemberAlert.class)
public class MemberAlertStatus {
   public enum Status {
        UNSEEN,
        SEEN,
        RESPONDED,
    }

    @Id
    private String alertId;

    @Id
    private String memberId;

    @UpdateTimestamp
    private Instant lastSeen;

    @NotNull
    private Status status;

    public MemberAlertStatus(final String alertId, final String memberId,
                             final Status status) {
        this.alertId = alertId;
        this.memberId = memberId;
        this.status = status;
    }
}