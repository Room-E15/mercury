package com.mercury.demo.entities;

import jakarta.persistence.Entity;
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
public class AlertGroup {
    @Id
    @Setter
    @UuidGenerator
    private String id;

    @NotNull
    private String groupName;

    public AlertGroup(final String groupName) {
        this.groupName = groupName;
    }
}
