package com.mercury.demo.controllers;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.mercury.demo.entities.exceptions.DatabaseStateException;
import com.mercury.demo.entities.Alert;
import com.mercury.demo.entities.MemberAlertStatus;
import com.mercury.demo.entities.MemberAlertStatus.Status;
import com.mercury.demo.entities.Membership;
import com.mercury.demo.repositories.AlertRepository;
import com.mercury.demo.repositories.MemberAlertStatusRepository;
import com.mercury.demo.repositories.MembershipRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.xml.crypto.Data;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;

// TODO consider splitting into multiple controllers, covers 2 use cases (send alert and respond to alert)
@RestController
@RequestMapping(path="/sendAlert")
public class SendAlertController {
    private final AlertRepository alertRepository;

    private final MemberAlertStatusRepository statusRepository;

    private final MembershipRepository membershipRepository;

    ObjectMapper objectMapper = new ObjectMapper();

    @Autowired
    public SendAlertController(final AlertRepository alertRepository,
                               final MemberAlertStatusRepository memberAlertStatusRepository,
                               final MembershipRepository membershipRepository) {
        this.alertRepository = alertRepository;
        this.statusRepository = memberAlertStatusRepository;
        this.membershipRepository = membershipRepository;
    }

    @PostMapping(path="/send")
    public Alert sendAlert(@RequestParam final String memberId,
                           @RequestParam final String groupId,
                           @RequestParam final String title,
                           @RequestParam final String description) throws DatabaseStateException {
        // If the member is not a leader of this group, they should not be able to send an alert
        Membership userMembership = membershipRepository.findByMemberIdAndGroupId(memberId, groupId);
        if (userMembership != null && !userMembership.isLeader()) {
            throw new DatabaseStateException("Member tried to send alert in group without leadership permissions");
        }

        final Alert alert = alertRepository.save(new Alert(groupId, title, description));

        // Populate MemberAlertStatus table for each member in the group
        membershipRepository.findByGroupId(alert.getGroupId()).forEach(membership ->
            // TODO make it so a leader does not get their own alerts, once full alert pipeline works (useful for testing)
            statusRepository.save(new MemberAlertStatus(
                    alert.getId(),
                    membership.getMemberId(),
                    Status.UNSEEN)));

        // TODO send push notification, email notification, SMS notification based on client preferences after
        //  alert is logged

        return alert;  // return inserted object to confirm success
    }

    @GetMapping(path="/get")
    public List<Alert> getLatestAlerts(@RequestHeader final String memberId,
                                       @RequestHeader final String ignoreAlertIds) {
        try {
            Set<String> alertIds = objectMapper.readValue(ignoreAlertIds, new TypeReference<>() {});
            List<MemberAlertStatus> alertStatuses = statusRepository.findByMemberIdAndStatusOrStatusOrderByLastSeen(memberId, Status.SEEN, Status.UNSEEN);
            return alertRepository.findByIds(alertStatuses
                    .stream()
                    .map(MemberAlertStatus::getAlertId)
                    .filter(alertId -> !alertIds.contains(alertId))
                    .toList()
            );
        } catch (JsonProcessingException e) {
            throw new DatabaseStateException("ERROR: Could not convert id list: " + ignoreAlertIds);
        }
    }

    @PutMapping(path="/confirm")
    public List<MemberAlertStatus> confirmAlertsSeen(@RequestParam final String memberId,
                                                     @RequestParam final String jsonAlertIds) throws DatabaseStateException {
        try {
            List<String> alertIds = objectMapper.readValue(jsonAlertIds, new TypeReference<>() {});
            List<MemberAlertStatus> alertStatuses = new ArrayList<>();

            statusRepository.findByAlertIds(alertIds).forEach(alertStatus -> {
                if (alertStatus.getMemberId().equals(memberId)) {
                    alertStatuses.add(statusRepository.save(new MemberAlertStatus(
                            alertStatus.getAlertId(),
                            alertStatus.getMemberId(),
                            Status.SEEN)));
                }
            });

            return alertStatuses;  // return resource to confirm success
        } catch (final JsonProcessingException e) {
            throw new DatabaseStateException("ERROR: Could not convert id list: " + jsonAlertIds);
        }
    }
}
