
package com.mercury.demo.entities;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.NaturalId;

@Entity
@NoArgsConstructor
public class Membership {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    @Getter
    @Setter
    private String memberId;

    @Getter
    @Setter
    private Long groupId;

    @NotNull
    @Getter
    @Setter
    private boolean isLeader;

    public Membership(final String memberId, final Long groupId, final boolean isLeader) {
        this.memberId = memberId;
        this.groupId = groupId;
        this.isLeader = isLeader;
    }
}
