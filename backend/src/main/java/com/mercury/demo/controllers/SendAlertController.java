package com.mercury.demo.controllers;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.mercury.demo.entities.Alert;
import com.mercury.demo.entities.MemberAlertStatus;
import com.mercury.demo.entities.MemberAlertStatus.Status;
import com.mercury.demo.repositories.AlertRepository;
import com.mercury.demo.repositories.MemberAlertStatusRepository;
import com.mercury.demo.repositories.MembershipRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;

// TODO consider splitting into multiple controllers, covers 2 use cases (send alert and respond to alert)
@RestController
@RequestMapping(path="/sendAlert")
public class SendAlertController {
    @Autowired
    private AlertRepository alertRepository;
    @Autowired
    private MemberAlertStatusRepository statusRepository;
    @Autowired
    private MembershipRepository membershipRepository;

    ObjectMapper objectMapper = new ObjectMapper();

    @PostMapping(path="/send")
    public Alert sendAlert(@RequestParam final String memberId,
                           @RequestParam final String groupId,
                           @RequestParam final String title,
                           @RequestParam final String description) {
        // TODO add permission check here for userId permissions, check if they're a leader of this group
        final Alert alert = alertRepository.save(new Alert(groupId, title, description));

        // Populate MemberAlertStatus table for each member in the group
        membershipRepository.findByGroupId(alert.getGroupId()).forEach(membership -> {
            // TODO make it so a leader does not get their own alerts, once full alert pipeline works (useful for testing)
            final var status = new MemberAlertStatus(
                    alert.getId(),
                    membership.getMemberId(),
                    Status.UNSEEN);
            statusRepository.save(status);
        });

        // TODO send push notification, email notification, SMS notification based on client preferences after
        //  alert is logged

        return alert;  // return inserted object to confirm success
    }

    @GetMapping(path="/get")
    public List<Alert> getLatestAlerts(@RequestHeader final String memberId) {
        List<MemberAlertStatus> alertStatuses = statusRepository.findByMemberIdAndStatusOrStatusOrderByLastSeen(memberId, Status.SEEN, Status.UNSEEN);
        return alertRepository.findByIds(alertStatuses.stream().map(MemberAlertStatus::getAlertId).toList());
    }

    @PutMapping(path= "/confirm")
    public List<MemberAlertStatus> confirmAlertsSeen(@RequestParam final String memberId,
                                                     @RequestParam final String jsonAlertIds) {


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
        } catch (JsonProcessingException e) {
            System.out.println("ERROR: Could not convert id list: " + jsonAlertIds);
            return null;
        }
    }
}
