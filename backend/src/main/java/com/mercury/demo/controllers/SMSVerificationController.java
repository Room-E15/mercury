package com.mercury.demo.controllers;

import com.fasterxml.jackson.annotation.JsonView;
import com.mercury.demo.entities.Member;
import com.mercury.demo.entities.SMSVerification;
import com.mercury.demo.entities.Carrier;

import com.mercury.demo.entities.responses.MemberAddResponse;
import com.mercury.demo.entities.responses.SMSDispatchResponse;
import com.mercury.demo.entities.responses.SMSVerifyResponse;
import com.mercury.demo.repositories.MemberRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.DigestUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.mercury.demo.mail.SMSEmailService;
import com.mercury.demo.repositories.CarrierRepository;
import com.mercury.demo.repositories.SMSVerificationRepository;
import org.springframework.web.bind.annotation.RestController;

import java.security.SecureRandom;
import java.util.Optional;
import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;

@RestController // This means that this class is a Controller
@RequestMapping(path = "/v") // This means URL's start with /demo (after Application path)
public class SMSVerificationController {
    private final SMSVerificationRepository smsVerificationRepository;

    private final CarrierRepository carrierRepository;

    private final SMSEmailService mailService;

    private final MemberRepository memberRepository;

    @Autowired
    public SMSVerificationController(final SMSVerificationRepository smsVerificationRepository,
                                     final CarrierRepository carrierRepository,
                                     final SMSEmailService mailService,
                                     final MemberRepository memberRepository) {
        this.smsVerificationRepository = smsVerificationRepository;
        this.carrierRepository = carrierRepository;
        this.mailService = mailService;
        this.memberRepository = memberRepository;
    }

    @PostMapping(path = "/dispatch") // Map ONLY POST Requests
    public SMSDispatchResponse requestSMSDispatch(@RequestParam final int countryCode,
                                                  @RequestParam final String phoneNumber,
                                                  @RequestParam final String carrier) {
        // Calculate expiration time (15 minutes from current moment)
        final long expiration = (System.currentTimeMillis() / 1000) + 60 * 15; // 15 minutes

        // Generate random 6 digit code
        final StringBuilder code = new StringBuilder();
        final SecureRandom secureRandom = new SecureRandom();
        for (int i = 0; i < 6; i++) {
            code.append(secureRandom.nextInt(10));
        }
        final String hash = DigestUtils.md5DigestAsHex(code.toString().getBytes());

        // Check if carrier is supported
        final Optional<Carrier> optionalCarrier = carrierRepository.findById(carrier);
        if (optionalCarrier.isEmpty()) {
            return new SMSDispatchResponse(false, null);
        }
        final Carrier c = optionalCarrier.get();

        // Send the text
        mailService.dispatchSMS(code.toString(), countryCode, phoneNumber, c);

        // Register SMSVerification session
        SMSVerification smsVerification = new SMSVerification(countryCode, phoneNumber, expiration, hash);
        smsVerificationRepository.deleteAll(
                smsVerificationRepository.findAllByPhoneNumberAndCountryCode(phoneNumber, countryCode));
        smsVerification = smsVerificationRepository.save(smsVerification);

        // Return token to be used for /verify session lookup
        return new SMSDispatchResponse(true, smsVerification.getId());
    }

    @PostMapping(path = "/verify") // Map ONLY POST Requests
    public SMSVerifyResponse verifySMSCode(@RequestParam final String token,
                                           @RequestParam final String code
    ) {
        // Search for SMSVerification session using given token
        final Optional<SMSVerification> optionalSMSVerificationSession = smsVerificationRepository.findById(token);
        if (optionalSMSVerificationSession.isEmpty()) {
            return new SMSVerifyResponse(false, null);
        }
        final SMSVerification smsVerification = optionalSMSVerificationSession.get();

        if (!smsVerification.isVerified()) {
            // Hash the given code and compare to what we have stored in the db
            final String codeHash = DigestUtils.md5DigestAsHex(code.getBytes());
            if (!smsVerification.getVerificationCodeHash().equals(codeHash)) {
                return new SMSVerifyResponse(false, null);
            }

            smsVerification.setVerified(true);
            smsVerificationRepository.save(smsVerification);
        }

        // At this point, we know the verification code was correct. Prepare the response info
        // Check to see if a user exists with this phone number
        final Member userInfo = memberRepository.findByPhoneNumberAndCountryCode(
                smsVerification.getPhoneNumber(),
                smsVerification.getCountryCode()).orElse(null);

        // Respond with userInfo (if user exists) and note that the code was valid
        return new SMSVerifyResponse(true, userInfo);
    }

    @GetMapping(path = "/carriers")
    @JsonView(Carrier.PublicView.class)
    public List<Object> getAllCarriers() {
        final List<Carrier.CommType> enumList = List.of(Carrier.CommType.values());
        final List<Object> response = new ArrayList<>();
        enumList.forEach((Carrier.CommType key) -> {
            final List<Carrier> value = carrierRepository.findAllByType(key);
            final Map<String, Object> responseMap = new HashMap<>();
            if (!value.isEmpty()) {
                responseMap.put("carriers", value);
                responseMap.put("type", key.commName);
                responseMap.put("displayName", key.displayName);
                response.add(responseMap);
            }
        });

        return response;
    }

    @PostMapping(path = "/register") // Map ONLY POST Requests
    public MemberAddResponse registerMember(@RequestParam final String firstName,
                                            @RequestParam final String lastName,
                                            @RequestParam final String token
    ) {
        final Optional<SMSVerification> smsVerification = smsVerificationRepository
                .findFirstByIdAndVerified(token, true);
        if (smsVerification.isPresent()) {
            final int countryCode = smsVerification.get().getCountryCode();
            final String phoneNumber = smsVerification.get().getPhoneNumber();

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
