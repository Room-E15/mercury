package com.mercury.demo.repositories;

import com.mercury.demo.entities.Membership;
import org.springframework.data.repository.CrudRepository;

import java.util.List;
import java.util.Optional;

// This will be AUTO IMPLEMENTED by Spring into a Bean called groupRepository
// CRUD refers Create, Read, Update, Delete
public interface MembershipRepository extends CrudRepository<Membership, Long> {
    // Find membership by memberId
    List<Membership> findByMemberId(String memberId);
    // Find membership by memberId
    List<Membership> findByGroupId(String groupId);
}