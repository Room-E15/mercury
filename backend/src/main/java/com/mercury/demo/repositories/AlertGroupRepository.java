package com.mercury.demo.repositories;

import com.mercury.demo.entities.AlertGroup;
import org.springframework.data.repository.CrudRepository;

// This will be AUTO IMPLEMENTED by Spring into a Bean called groupRepository
// CRUD refers Create, Read, Update, Delete
public interface AlertGroupRepository extends CrudRepository<AlertGroup, Long> {

}