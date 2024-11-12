package com.mercury.demo.controllers;

import com.mercury.demo.entities.Alert;
import com.mercury.demo.entities.MemberAlertStatus;
import com.mercury.demo.entities.MemberAlertStatus.Status;
import com.mercury.demo.repositories.AlertRepository;
import com.mercury.demo.repositories.MemberAlertStatusRepository;
import com.mercury.demo.repositories.MembershipRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.List;


@Controller
@RequestMapping(path="/alert")
public class SendAlertController {
    @Autowired
    private AlertRepository alertRepository;
    @Autowired
    private MemberAlertStatusRepository statusRepository;
    @Autowired
    private MembershipRepository membershipRepository;

    @PostMapping(path="/store")
    public @ResponseBody Alert storeAlert(@RequestParam String title,
                                         @RequestParam String description,
                                         @RequestParam String location,  // TODO figure out location representation
                                         @RequestParam Long groupId) {

        Alert alert = alertRepository.save(new Alert(groupId, title, description, location));

        // Populate MemberAlertStatus table for each member in the group
        membershipRepository.findByGroupId(alert.getGroupId()).forEach(membership -> {
            statusRepository.save(new MemberAlertStatus(
                    alert.getId(),
                    membership.getMemberId(),
                    Status.UNSEEN));
        });
        return alert;  // return inserted object to confirm success
    }

    @GetMapping(path="/get")
    public @ResponseBody List<MemberAlertStatus> getLatestAlerts(@RequestParam String memberId) {
        return statusRepository.findByMemberIdAndStatus(memberId, Status.UNSEEN);
    }

    @PutMapping(path= "/confirm")  // TODO should this be /confirm, or /get/confirm?
    public @ResponseBody List<MemberAlertStatus> confirmAlertsSeen(@RequestParam List<MemberAlertStatus> alertStatuses) {
        statusRepository.saveAll(alertStatuses.stream().map(alertStatus -> new MemberAlertStatus(
                alertStatus.getAlertId(),
                alertStatus.getAlertId(),
                alertStatus.getMemberId(),
                Status.SEEN)).toList());
        return alertStatuses;  // return resource to confirm success
    }
}
