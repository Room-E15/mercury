package com.mercury.demo.entities;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.validation.constraints.NotNull;
import lombok.*;


@Entity
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@ToString
public class AlertResponse {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    @NotNull
    private String userId;

    @NotNull
    private Boolean isSafe;

    @NotNull
    private Double latitude;

    @NotNull
    private Double longitude;

    @NotNull
    private Double batteryPercent;

    public AlertResponse(String userId, Boolean isSafe, Double latitude, Double longitude, Double batteryPercent) {
        this.userId = userId;
        this.isSafe = isSafe;
        this.latitude = latitude;
        this.longitude = longitude;
        this.batteryPercent = batteryPercent;
    }
}
