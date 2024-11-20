package com.mercury.demo.controllers;

import com.mercury.demo.entities.AlertGroup;
import com.mercury.demo.entities.Member;
import com.mercury.demo.entities.Membership;
import com.mercury.demo.entities.SMSVerification;
import com.mercury.demo.repositories.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;

@Controller
@RequestMapping(path = "/dev")
public class DevController {
    @Autowired
    private AlertGroupRepository alertGroupRepository;
    @Autowired
    private AlertRepository alertRepository;
    @Autowired
    private CarrierRepository carrierRepository;
    @Autowired
    private MemberAlertStatusRepository memberAlertStatusRepository;
    @Autowired
    private MemberRepository memberRepository;
    @Autowired
    private MembershipRepository membershipRepository;
    @Autowired
    private SMSVerificationRepository smsVerificationRepository;

    @DeleteMapping("/wipe/table/{tableName}")
    public @ResponseBody HashMap<String, Object> wipeTable(@PathVariable String tableName) {
        final HashMap<String, Object> response = new HashMap<>();
        response.put("status", "success");

        switch (tableName) {
            case "alert_group" -> alertGroupRepository.deleteAll();
            case "alert" -> alertRepository.deleteAll();
            case "carrier" -> carrierRepository.deleteAll();
            case "member_alert_status" -> memberAlertStatusRepository.deleteAll();
            case "member" -> memberRepository.deleteAll();
            case "membership" -> membershipRepository.deleteAll();
            case "sms_verification" -> smsVerificationRepository.deleteAll();
            default -> {
                response.put("status", "success");
                return response;
            }
        }
        response.put("table", tableName);
        return response;
    }

    private long previousTime;

    @DeleteMapping("/wipe/db")
    public @ResponseBody HashMap<String, Object> wipeDatabase() {
        final HashMap<String, Object> response = new HashMap<>();
        final long currentTime = System.currentTimeMillis() / 1000;
        if (currentTime - previousTime < 10) {
            previousTime = 0;

            alertGroupRepository.deleteAll();
            alertRepository.deleteAll();
            carrierRepository.deleteAll();
            memberAlertStatusRepository.deleteAll();
            memberRepository.deleteAll();
            membershipRepository.deleteAll();
            smsVerificationRepository.deleteAll();

            response.put("status", "success");
            response.put("description", "Database wiped.");
            return response;
        }
        previousTime = currentTime;
        response.put("status", "pending wipe");
        response.put("description", "Are you sure you want to wipe the entire database? " +
                "If so, resend this request within 10 seconds.");
        return response;
    }

    @PutMapping("/populate")
    public @ResponseBody HashMap<String, Object> populate() {
        final HashMap<String, Object> response = new HashMap<>();

        final Member[] members = new Member[4];
        members[0] = getMemberOrSaveIfNotExist(
                new Member("Aidan", "Sacco", "1", "6503958675"));
        members[1] = getMemberOrSaveIfNotExist(
                new Member("Cameron", "Wolff", "1", "9499220667"));
        members[2] = getMemberOrSaveIfNotExist(
                new Member("Caden", "Upson", "1", "9494320420"));
        members[3] = getMemberOrSaveIfNotExist(
                new Member("Rishi", "Gupta", "1", "4088390474"));

        final AlertGroup[] groups = new AlertGroup[4];
        groups[0] = getGroupOrSaveIfNotExist(new AlertGroup("Aidan's Group"));
        groups[1] = getGroupOrSaveIfNotExist(new AlertGroup("Cameron's Group"));
        groups[2] = getGroupOrSaveIfNotExist(new AlertGroup("Caden's Group"));
        groups[3] = getGroupOrSaveIfNotExist(new AlertGroup("Rishi's Group"));

        AlertGroup group;
        Member member;
        boolean isLeader;
        for (int i = 0; i < groups.length; i++) {
            group = groups[i];
            for (int j = 0; j < members.length; j++) {
                member = members[j];
                isLeader = (i == j);
                membershipRepository.save(new Membership(member.getId(), group.getId(), isLeader));
            }
        }

        response.put("status", "success");
        return response;
    }

    private Member getMemberOrSaveIfNotExist(Member member) {
        return memberRepository.findByPhoneNumberAndCountryCode(
                        member.getPhoneNumber(),
                        member.getCountryCode())
                .orElse(memberRepository.save(member));
    }

    private AlertGroup getGroupOrSaveIfNotExist(AlertGroup group) {
        return alertGroupRepository.findByGroupName(
                        group.getGroupName())
                .orElse(alertGroupRepository.save(group));
    }

    @PostMapping("/member/create")
    public @ResponseBody HashMap<String, Object> createMember(@RequestParam String firstName,
                                                              @RequestParam String lastName,
                                                              @RequestParam String countryCode,
                                                              @RequestParam String phoneNumber
    ) {
        final HashMap<String, Object> response = new HashMap<>();

        memberRepository.findByPhoneNumberAndCountryCode(phoneNumber, countryCode).ifPresentOrElse(
                (member) -> {
                    response.put("status", "error");
                    response.put("description", "Member with phone number " + phoneNumber + " already exists.");
                }, () -> {
                    final Member m = memberRepository.save(new Member(firstName, lastName, countryCode, phoneNumber));
                    response.put("status", "success");
                    response.put("id", m.getId());
                }
        );

        return response;
    }

    @PostMapping("/group/create")
    public @ResponseBody HashMap<String, Object> createGroup(@RequestParam String name) {
        final HashMap<String, Object> response = new HashMap<>();

        alertGroupRepository.findByGroupName(name).ifPresentOrElse(
                (group) -> {
                    response.put("status", "error");
                    response.put("description", "Group with name '" + name + "' already exists.");
                }, () -> {
                    final AlertGroup ag = alertGroupRepository.save(new AlertGroup(name));
                    response.put("status", "success");
                    response.put("id", ag.getId());
                }
        );

        return response;
    }

    @PutMapping("/sms/forceverify")
    public @ResponseBody HashMap<String, Object> forceVerify(@RequestParam String phoneNumber,
                                                             @RequestParam String countryCode) {
        final HashMap<String, Object> response = new HashMap<>();

        smsVerificationRepository.findByPhoneNumberAndCountryCode(phoneNumber, countryCode).ifPresentOrElse(
                (verification) -> {
                    if (verification.isVerified()) {
                        response.put("status", "no-change");
                        response.put("description", "Number already verified.");
                    } else {
                        response.put("status", "success");
                        response.put("description", "Number verified.");
                    }
                }, () -> {
                    final SMSVerification v = smsVerificationRepository.save(
                            new SMSVerification(countryCode, phoneNumber, 0L, ""));
                    v.setVerified(true);
                    smsVerificationRepository.save(v);
                    response.put("status", "success");
                    response.put("description", "Number created and verified.");
                }
        );

        return response;
    }
}
