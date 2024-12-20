package com.mercury.demo.repositories;

import com.mercury.demo.entities.MemberAlertResponse;
import com.mercury.demo.entities.idclass.MemberAlert;
import org.springframework.data.repository.CrudRepository;

import java.util.Optional;

public interface MemberAlertResponseRepository extends CrudRepository<MemberAlertResponse, MemberAlert> {
    Optional<MemberAlertResponse> findFirstByMemberIdAndAlertIdOrderByCreationTimeDesc(String memberId, String alertId);
}
