package com.mercury.demo.repositories;

import com.mercury.demo.entities.Membership;
import org.springframework.data.repository.CrudRepository;

import java.util.List;

public interface MembershipRepository extends CrudRepository<Membership, Integer> {
    List<Membership> getMembershipsByGroupId(Long groupId);
}
