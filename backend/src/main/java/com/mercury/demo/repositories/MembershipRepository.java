package com.mercury.demo.repositories;

import com.mercury.demo.entities.Membership;
import com.mercury.demo.entities.idclass.MemberGroup;
import org.springframework.data.repository.CrudRepository;

import java.util.List;

// This will be AUTO IMPLEMENTED by Spring into a Bean called groupRepository
// CRUD refers Create, Read, Update, Delete
public interface MembershipRepository extends CrudRepository<Membership, MemberGroup> {
    List<Membership> findByMemberId(String memberId);
    List<Membership> findByGroupId(String groupId);
    Membership findByMemberIdAndGroupId(String memberId, String groupId);
}