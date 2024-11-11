package com.mercury.demo.entities;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

enum Status {
    UNSEEN,
    SEEN,
    SAFE,
    UNSAFE
}

@Entity
@NoArgsConstructor
public class MemberAlertStatus {
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
    private Long memberId;

    @NotNull
    @Getter
    @Setter
    private Status status;

    public MemberAlertStatus(final Long groupId, final long memberId,
                             final Status status) {
        this.groupId = groupId;
        this.memberId = memberId;
        this.status = status;
    }
}
