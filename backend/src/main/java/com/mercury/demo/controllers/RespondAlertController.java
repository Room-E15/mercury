package com.mercury.demo.controllers;

import com.mercury.demo.entities.MemberAlertResponse;
import com.mercury.demo.entities.MemberAlertStatus;
import com.mercury.demo.repositories.MemberAlertResponseRepository;
import com.mercury.demo.repositories.MemberAlertStatusRepository;
import com.mercury.demo.repositories.MembershipRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping(path="/respondAlert")
public class RespondAlertController {
    @Autowired
    private MembershipRepository membershipRepository;

    @Autowired
    private MemberAlertResponseRepository responseRepository;

    @Autowired
    private MemberAlertStatusRepository statusRepository;

    @PostMapping(path="/save")
    public MemberAlertResponse saveAlertResponse(@RequestParam final String memberId,
                                                 @RequestParam final String alertId,
                                                 @RequestParam final Boolean isSafe,
                                                 @RequestParam final Double latitude,
                                                 @RequestParam final Double longitude,
                                                 @RequestParam final Double batteryPercent) {
        if (membershipRepository.findByMemberId(memberId) != null) {
            // update the status
            MemberAlertStatus status = statusRepository.findByMemberIdAndAlertId(memberId, alertId);
            status.setStatus(MemberAlertStatus.Status.RESPONDED);
            statusRepository.save(status);
            // then save the response
            return responseRepository.save(new MemberAlertResponse(memberId, alertId, isSafe, latitude, longitude, batteryPercent));
        }
        return null;
    }
}