package com.mercury.demo.entities.idclass;

import lombok.AllArgsConstructor;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

import java.io.Serializable;

@AllArgsConstructor
@NoArgsConstructor
@EqualsAndHashCode
public class MemberAlert implements Serializable {
    private String memberId;
    private String alertId;
}