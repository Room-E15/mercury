package com.mercury.demo.entities;

import com.mercury.demo.entities.idclass.MemberAlert;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;
import org.hibernate.annotations.UuidGenerator;

import java.time.Instant;


@Entity
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@ToString
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
    private Integer batteryPercent;

    public MemberAlertResponse(String memberId, String alertId, Boolean isSafe, Double latitude, Double longitude, Integer batteryPercent) {
        this.memberId = memberId;
        this.alertId = alertId;
        this.isSafe = isSafe;
        this.latitude = latitude;
        this.longitude = longitude;
        this.batteryPercent = batteryPercent;
    }
}
