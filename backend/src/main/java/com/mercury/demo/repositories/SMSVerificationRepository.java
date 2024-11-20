package com.mercury.demo.repositories;

import org.springframework.data.repository.CrudRepository;

import com.mercury.demo.entities.SMSVerification;

import java.util.Optional;

// This will be AUTO IMPLEMENTED by Spring into a Bean called userRepository
// CRUD refers Create, Read, Update, Delete
public interface SMSVerificationRepository extends CrudRepository<SMSVerification, String> {
    Optional<SMSVerification> findByPhoneNumberAndCountryCode(String phoneNumber,
                                                              String countryCode);

    Optional<SMSVerification> findByPhoneNumberAndCountryCodeAndVerified(String phoneNumber,
                                                                         String countryCode,
                                                                         boolean verified);
}
