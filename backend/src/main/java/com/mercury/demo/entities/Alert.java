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
import org.hibernate.annotations.UuidGenerator;

@Entity
@NoArgsConstructor
@Getter
@Setter
@EqualsAndHashCode
@ToString
public class Alert {
    @Id
    @UuidGenerator
    private String id;

    @NotNull
    private String groupId;

    @NotNull
    private String title;

    @NotNull
    private String description;

    public Alert(String groupId, String title, String description) {
        this.groupId = groupId;
        this.title = title;
        this.description = description;
    }
}
