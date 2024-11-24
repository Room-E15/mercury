package com.mercury.demo.controllers;

import com.mercury.demo.entities.AlertGroup;
import com.mercury.demo.entities.Member;
import com.mercury.demo.entities.Membership;
import com.mercury.demo.entities.SMSVerification;
import com.mercury.demo.repositories.AlertGroupRepository;
import com.mercury.demo.repositories.AlertRepository;
import com.mercury.demo.repositories.CarrierRepository;
import com.mercury.demo.repositories.MemberAlertStatusRepository;
import com.mercury.demo.repositories.MemberRepository;
import com.mercury.demo.repositories.MembershipRepository;
import com.mercury.demo.repositories.SMSVerificationRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping(path = "/dev")
public class DevController {
    private static final String STATUS = "status";
    private static final String SUCCESS = "success";
    private static final String DESCRIPTION = "description";

    private final  AlertGroupRepository alertGroupRepository;

    private final  AlertRepository alertRepository;

    private final  CarrierRepository carrierRepository;

    private final  MemberAlertStatusRepository memberAlertStatusRepository;

    private final  MemberRepository memberRepository;

    private final  MembershipRepository membershipRepository;

    private final  SMSVerificationRepository smsVerificationRepository;

    long previousTime;

    @Autowired
    public DevController(final AlertGroupRepository alertGroupRepository,
                         final AlertRepository alertRepository,
                         final CarrierRepository carrierRepository,
                         final MemberAlertStatusRepository memberAlertStatusRepository,
                         final MemberRepository memberRepository,
                         final MembershipRepository membershipRepository,
                         final SMSVerificationRepository smsVerificationRepository) {
        this.alertGroupRepository = alertGroupRepository;
        this.alertRepository = alertRepository;
        this.carrierRepository = carrierRepository;
        this.memberAlertStatusRepository = memberAlertStatusRepository;
        this.memberRepository = memberRepository;
        this.membershipRepository = membershipRepository;
        this.smsVerificationRepository = smsVerificationRepository;
    }

    @DeleteMapping("/wipe/table/{tableName}")
    public Map<String, Object> wipeTable(@PathVariable String tableName) {
        final Map<String, Object> response = new HashMap<>();
        response.put(STATUS, SUCCESS);

        switch (tableName) {
            case "alert_group" -> alertGroupRepository.deleteAll();
            case "alert" -> alertRepository.deleteAll();
            case "carrier" -> carrierRepository.deleteAll();
            case "member_alert_status" -> memberAlertStatusRepository.deleteAll();
            case "member" -> memberRepository.deleteAll();
            case "membership" -> membershipRepository.deleteAll();
            case "sms_verification" -> smsVerificationRepository.deleteAll();
            default -> {
                response.put(STATUS, SUCCESS);
                return response;
            }
        }
        response.put("table", tableName);
        return response;
    }

    @DeleteMapping("/wipe/db")
    public Map<String, Object> wipeDatabase() {
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

            response.put(STATUS, SUCCESS);
            response.put(DESCRIPTION, "Database wiped.");
            return response;
        }
        previousTime = currentTime;
        response.put(STATUS, "pending wipe");
        response.put(DESCRIPTION, "Are you sure you want to wipe the entire database? " +
                "If so, resend this request within 10 seconds.");
        return response;
    }

    @PutMapping("/populate")
    public Map<String, Object> populate() {
        final HashMap<String, Object> response = new HashMap<>();

        final Member[] members = new Member[4];
        members[0] = getMemberOrSaveIfNotExist(
                new Member("Aidan", "Sacco", 1, "6503958675"));
        members[1] = getMemberOrSaveIfNotExist(
                new Member("Cameron", "Wolff", 1, "9499220667"));
        members[2] = getMemberOrSaveIfNotExist(
                new Member("Caden", "Upson", 1, "9494320420"));
        members[3] = getMemberOrSaveIfNotExist(
                new Member("Rishi", "Gupta", 1, "4088390474"));

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

        response.put(STATUS, SUCCESS);
        return response;
    }

    @PostMapping("/member/create")
    public  Map<String, Object> createMember(@RequestParam String firstName,
                                                              @RequestParam String lastName,
                                                              @RequestParam int countryCode,
                                                              @RequestParam String phoneNumber
    ) {
        final HashMap<String, Object> response = new HashMap<>();

        memberRepository.findByPhoneNumberAndCountryCode(phoneNumber, countryCode).ifPresentOrElse(
                member -> {
                    response.put(STATUS, "error");
                    response.put(DESCRIPTION, "Member with phone number " + phoneNumber + " already exists.");
                }, () -> {
                    final Member m = memberRepository.save(new Member(firstName, lastName, countryCode, phoneNumber));
                    response.put(STATUS, SUCCESS);
                    response.put("id", m.getId());
                }
        );

        return response;
    }

    @PostMapping("/group/create")
    public  Map<String, Object> createGroup(@RequestParam String name) {
        final Map<String, Object> response = new HashMap<>();

        alertGroupRepository.findByGroupName(name).ifPresentOrElse(
                group -> {
                    response.put(STATUS, "error");
                    response.put(DESCRIPTION, "Group with name '" + name + "' already exists.");
                }, () -> {
                    final AlertGroup ag = alertGroupRepository.save(new AlertGroup(name));
                    response.put(STATUS, SUCCESS);
                    response.put("id", ag.getId());
                }
        );

        return response;
    }

    @PutMapping("/sms/forceverify")
    public  Map<String, Object> forceVerify(@RequestParam String phoneNumber,
                                                             @RequestParam int countryCode) {
        final Map<String, Object> response = new HashMap<>();

        smsVerificationRepository.findByPhoneNumberAndCountryCode(phoneNumber, countryCode).ifPresentOrElse(
                verification -> {
                    if (verification.isVerified()) {
                        response.put(STATUS, "no-change");
                        response.put(DESCRIPTION, "Number already verified.");
                    } else {
                        verification.setVerified(true);
                        smsVerificationRepository.save(verification);
                        response.put(STATUS, SUCCESS);
                        response.put(DESCRIPTION, "Number verified.");
                    }
                }, () -> {
                    final SMSVerification v = smsVerificationRepository.save(
                            new SMSVerification(countryCode, phoneNumber, 0L, ""));
                    v.setVerified(true);
                    smsVerificationRepository.save(v);
                    response.put(STATUS, SUCCESS);
                    response.put(DESCRIPTION, "Number created and verified.");
                }
        );

        return response;
    }



    private Member getMemberOrSaveIfNotExist(final Member member) {
        return memberRepository.findByPhoneNumberAndCountryCode(
                        member.getPhoneNumber(),
                        member.getCountryCode())
                .orElse(memberRepository.save(member));
    }

    private AlertGroup getGroupOrSaveIfNotExist(final AlertGroup group) {
        return alertGroupRepository.findByGroupName(
                        group.getGroupName())
                .orElse(alertGroupRepository.save(group));
    }
}
