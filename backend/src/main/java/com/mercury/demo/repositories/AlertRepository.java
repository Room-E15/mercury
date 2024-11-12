package com.mercury.demo.repositories;

import com.mercury.demo.entities.Alert;
import org.springframework.data.repository.CrudRepository;

public interface AlertRepository extends CrudRepository<Alert, Integer> {

}
