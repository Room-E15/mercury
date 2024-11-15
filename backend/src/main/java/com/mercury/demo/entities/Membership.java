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
@ToString
@EqualsAndHashCode
public class Membership {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    private String memberId;

    @Getter
    @Setter
    private String groupId;

    @NotNull
    private boolean isLeader;

    public Membership(final String memberId, final String groupId, final boolean isLeader) {
        this.memberId = memberId;
        this.groupId = groupId;
        this.isLeader = isLeader;
    }
}

