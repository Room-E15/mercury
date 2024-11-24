package com.mercury.demo.entities;

import com.mercury.demo.entities.idclass.MemberGroup;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.IdClass;
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
@IdClass(MemberGroup.class)
public class Membership {
    @Id
    private String memberId;

    @Id
    private String groupId;

    @NotNull
    private boolean isLeader;

    public Membership(final String memberId, final String groupId, final boolean isLeader) {
        this.memberId = memberId;
        this.groupId = groupId;
        this.isLeader = isLeader;
    }
}

