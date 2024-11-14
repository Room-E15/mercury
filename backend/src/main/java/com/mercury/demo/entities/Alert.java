package com.mercury.demo.entities;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.validation.constraints.NotNull;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Entity
@NoArgsConstructor
@Getter
@Setter
@EqualsAndHashCode()
@ToString
public class Alert {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    @NotNull
    private Long groupId;

    @NotNull
    private String title;

    @NotNull
    private String description;

    // TODO figure out proper data representation for location. Possibilities:
    // - Latitude, Longitude, Radius
    // - Address, Radius
    // - Selectable region
    // - Should we allow for multiple??

    @NotNull
    private String location;

    public Alert(Long groupId, String title, String description, String location) {
        this.groupId = groupId;
        this.title = title;
        this.description = description;
        this.location = location;
    }
}
