package com.mercury.demo.repositories;

import com.mercury.demo.entities.MemberAlertStatus;
import com.mercury.demo.entities.MemberAlertStatus.Status;
import com.mercury.demo.entities.idclass.MemberAlert;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;

import java.util.List;

public interface MemberAlertStatusRepository extends CrudRepository<MemberAlertStatus, MemberAlert> {
    List<MemberAlertStatus> findByMemberIdAndStatusOrStatusOrderByLastSeen(String memberId, Status statusSeen, Status statusUnseen);
    MemberAlertStatus findByMemberIdAndAlertId(String memberId, String alertId);

    @Query(value = "SELECT s FROM MemberAlertStatus s WHERE s.alertId in ?1 ORDER BY s.lastSeen")
    List<MemberAlertStatus> findByAlertIds(List<String> alertIds);
}