package com.mercury.demo.repositories;

import com.mercury.demo.entities.MemberAlertResponse;
import com.mercury.demo.entities.idclass.MemberAlert;
import org.springframework.data.repository.CrudRepository;

public interface MemberAlertResponseRepository extends CrudRepository<MemberAlertResponse, MemberAlert> {
    // TODO make sure when you get responses, you order by timestamp
}