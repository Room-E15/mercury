package com.mercury.demo.repositories;

import com.mercury.demo.entities.Member;
import org.springframework.data.repository.CrudRepository;

import java.util.Optional;

// This will be AUTO IMPLEMENTED by Spring into a Bean called userRepository
// CRUD refers Create, Read, Update, Delete
public interface MemberRepository extends CrudRepository<Member, String> {
    Optional<Member> findByPhoneNumberAndCountryCode(String phoneNumber, String countryCode);
}