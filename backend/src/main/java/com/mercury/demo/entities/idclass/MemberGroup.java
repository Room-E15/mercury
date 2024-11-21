package com.mercury.demo.entities.idclass;

import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.util.Objects;

@NoArgsConstructor
@AllArgsConstructor
public class MemberGroup implements Serializable {
    private String memberId;
    private String groupId;

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        MemberGroup memberAlert = (MemberGroup) o;
        return memberId.equals(memberAlert.memberId) &&
                groupId.equals(memberAlert.groupId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(memberId, groupId);
    }
}