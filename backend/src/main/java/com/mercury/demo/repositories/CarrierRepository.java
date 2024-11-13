package com.mercury.demo.repositories;

import org.springframework.data.repository.CrudRepository;

import com.mercury.demo.entities.Carrier;

// This will be AUTO IMPLEMENTED by Spring into a Bean called userRepository
// CRUD refers Create, Read, Update, Delete
public interface CarrierRepository extends CrudRepository<Carrier, String> {

}
