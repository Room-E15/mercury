package com.mercury.demo.controllers;

import com.mercury.demo.entities.AlertResponse;
import com.mercury.demo.repositories.AlertResponseRepository;
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
    private AlertResponseRepository responseRepository;

    @PostMapping(path="/save")
    public AlertResponse saveAlertResponse(@RequestParam final String memberId,
                                           @RequestParam final Boolean isSafe,
                                           @RequestParam final Double latitude,
                                           @RequestParam final Double longitude,
                                           @RequestParam final Double batteryPercent) {
        if (membershipRepository.findByMemberId(memberId) != null) {
            return responseRepository.save(new AlertResponse(memberId, isSafe, latitude, longitude, batteryPercent));
        }
        return null;
    }
}
