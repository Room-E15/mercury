package com.mercury.demo.repositories;

import com.mercury.demo.entities.MemberAlertStatus;
import com.mercury.demo.entities.MemberAlertStatus.Status;
import org.springframework.data.repository.CrudRepository;

import java.util.List;

public interface MemberAlertStatusRepository extends CrudRepository<MemberAlertStatus, Integer> {
    List<MemberAlertStatus> findByMemberIdAndStatus(Long memberId, Status status);
}
