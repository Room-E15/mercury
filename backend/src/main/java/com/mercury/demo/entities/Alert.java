package com.mercury.demo.entities;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@NoArgsConstructor
public class Alert {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    @NotNull
    @Getter
    @Setter
    private Long groupId;

    @NotNull
    @Getter
    @Setter
    private String title;

    @NotNull
    @Getter
    @Setter
    private String description;

    // TODO figure out proper data representation for location. Possibilities:
    // - Latitude, Longitude, Radius
    // - Address, Radius
    // - Selectable region
    // - Should we allow for multiple??

    @NotNull
    @Getter
    @Setter
    private String location;

    public Alert(Long groupId, String title, String description, String location) {
        this.groupId = groupId;
        this.title = title;
        this.description = description;
        this.location = location;
    }
}
