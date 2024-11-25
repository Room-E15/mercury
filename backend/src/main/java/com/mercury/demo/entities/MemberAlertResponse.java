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
@ToString
@EqualsAndHashCode
@IdClass(MemberAlert.class)
public class MemberAlertResponse {
    @Id
    private String memberId;

    @Id
    private String alertId;

    @UpdateTimestamp
    private Instant creationTime;

    @NotNull
    private Boolean isSafe;

    @NotNull
    private Double latitude;


    @NotNull
    private Double longitude;


    @NotNull
    private Integer battery;

    public MemberAlertResponse(String memberId, String alertId, Boolean isSafe, Double latitude, Double longitude, Integer battery) {
        this.memberId = memberId;
        this.alertId = alertId;
        this.isSafe = isSafe;
        this.latitude = latitude;
        this.longitude = longitude;
        this.battery = battery;
    }
}
