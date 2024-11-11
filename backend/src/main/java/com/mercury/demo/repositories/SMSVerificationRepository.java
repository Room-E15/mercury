package com.mercury.demo.repositories;

import org.springframework.data.repository.CrudRepository;

import com.mercury.demo.entities.SMSVerification;

// This will be AUTO IMPLEMENTED by Spring into a Bean called userRepository
// CRUD refers Create, Read, Update, Delete
public interface SMSVerificationRepository extends CrudRepository<SMSVerification, String> {
}
