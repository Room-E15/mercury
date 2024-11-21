package com.mercury.demo.entities.idclass;

import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.util.Objects;

@NoArgsConstructor
@AllArgsConstructor
public class MemberAlert implements Serializable {
    private String memberId;
    private String alertId;

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        MemberAlert memberAlert = (MemberAlert) o;
        return memberId.equals(memberAlert.memberId) &&
                alertId.equals(memberAlert.alertId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(memberId, alertId);
    }
}