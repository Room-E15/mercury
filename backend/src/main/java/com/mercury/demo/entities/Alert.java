package com.mercury.demo.entities;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.UuidGenerator;

@Getter
@Entity
@NoArgsConstructor
public class Alert {
    @Id
    @UuidGenerator
    private String id;

    @NotNull
    @Setter
    private String groupId;

    @NotNull
    @Setter
    private String title;

    @NotNull
    @Setter
    private String description;

    public Alert(String groupId, String title, String description) {
        this.groupId = groupId;
        this.title = title;
        this.description = description;
    }
}
