package com.mercury.demo.repositories;

import com.mercury.demo.entities.MemberAlertResponse;
import com.mercury.demo.entities.idclass.MemberAlert;
import org.springframework.data.repository.CrudRepository;

import java.util.List;

public interface MemberAlertResponseRepository extends CrudRepository<MemberAlertResponse, MemberAlert> {
    MemberAlertResponse findFirstByMemberIdOrderByCreationTimeDesc(String memberId);
}
