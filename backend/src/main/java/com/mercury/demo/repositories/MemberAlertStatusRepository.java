package com.mercury.demo.repositories;

import com.mercury.demo.entities.Alert;
import com.mercury.demo.entities.MemberAlertStatus;
import com.mercury.demo.entities.MemberAlertStatus.Status;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;

import java.util.List;
import java.util.stream.Stream;

public interface MemberAlertStatusRepository extends CrudRepository<MemberAlertStatus, Integer> {
    List<MemberAlertStatus> findByMemberIdAndStatusOrStatus(String memberId, Status statusSeen, Status statusUnseen);

    @Query(value = "SELECT s FROM MemberAlertStatus s WHERE s.alertId in ?1")
    List<MemberAlertStatus> findByAlertIds(List<String> alertIds);
}
