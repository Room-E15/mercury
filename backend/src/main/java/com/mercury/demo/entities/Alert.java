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
    @Getter
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    @NotNull
    @Getter
    @Setter
    private String groupId;

    @NotNull
    @Getter
    @Setter
    private String title;

    @NotNull
    @Getter
    @Setter
    private String description;

    public Alert(String groupId, String title, String description) {
        this.groupId = groupId;
        this.title = title;
        this.description = description;
    }
}
