package com.mercury.demo.controllers;

import com.mercury.demo.entities.Member;
import com.mercury.demo.entities.SMSVerification;
import com.mercury.demo.entities.responses.MemberAddResponse;
import com.mercury.demo.repositories.MemberRepository;
import com.mercury.demo.repositories.SMSVerificationRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.Optional;

@RestController // This means that this class is a Controller
@RequestMapping(path="/member") // This means URL's start with /demo (after Application path)
public class MemberController {
    private final MemberRepository memberRepository;

    private final SMSVerificationRepository smsVerificationRepository;

    @Autowired
    public MemberController(final MemberRepository memberRepository,
                            final SMSVerificationRepository smsVerificationRepository) {
        this.memberRepository = memberRepository;
        this.smsVerificationRepository = smsVerificationRepository;
    }

    @PostMapping(path="/addMember") // Map ONLY POST Requests
    public MemberAddResponse addNewMember(@RequestParam String firstName,
                                                        @RequestParam String lastName,
                                                        @RequestParam int countryCode,
                                                        @RequestParam String phoneNumber
    ) {
        final Optional<SMSVerification> smsVerification = smsVerificationRepository
                .getFirstByPhoneNumberAndCountryCodeAndVerified(phoneNumber, countryCode, true);
        if (smsVerification.isPresent()) {
            Member member = new Member(firstName, lastName, countryCode, phoneNumber);
            member = memberRepository.save(member);
            smsVerificationRepository.deleteAll(
                    smsVerificationRepository.findAllByPhoneNumberAndCountryCode(phoneNumber, countryCode));
            return new MemberAddResponse(member);
        } else {
            return new MemberAddResponse("The phone number has not yet been verified.");
        }
    }
}