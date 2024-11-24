package com.mercury.demo.repositories;

import com.mercury.demo.entities.Alert;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;

import java.util.List;
import java.util.Optional;

public interface AlertRepository extends CrudRepository<Alert, String> {
    @Query(value = "SELECT a FROM Alert a WHERE a.id IN ?1 ORDER BY a.creationTime")
    List<Alert> findByIds(List<String> ids);

    Optional<Alert> findFirstByGroupIdOrderByCreationTime(String groupId);
}
