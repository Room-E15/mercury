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
import org.springframework.stereotype.Controller;
import org.springframework.util.DigestUtils;
import org.springframework.web.bind.annotation.*;

import com.mercury.demo.mail.SMSEmailService;
import com.mercury.demo.repositories.CarrierRepository;
import com.mercury.demo.repositories.SMSVerificationRepository;

import java.security.SecureRandom;
import java.util.*;

@RestController // This means that this class is a Controller
@RequestMapping(path = "/v") // This means URL's start with /demo (after Application path)
public class SMSVerificationController {
    @Autowired
    private SMSVerificationRepository smsVerificationRepository;
    @Autowired
    private CarrierRepository carrierRepository;
    @Autowired
    private SMSEmailService mailService;
    @Autowired
    private MemberRepository memberRepository;

    @PostMapping(path = "/dispatch") // Map ONLY POST Requests
    public  SMSDispatchResponse requestSMSDispatch(@RequestParam final int countryCode,
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
    public  SMSVerifyResponse verifySMSCode(@RequestParam final String token,
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
            String codeHash = DigestUtils.md5DigestAsHex(code.getBytes());
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
    public  List<Object> getAllCarriers() {
        Map<Carrier.CommType, List<Carrier>> response1 = new EnumMap<>(Carrier.CommType.class);

        List<Carrier.CommType> commTypes = new ArrayList<>(List.of(Carrier.CommType.values()));
        commTypes.sort((o1, o2) -> {
            if (o1.priority == o2.priority) return 0;
            return o2.priority < o1.priority ? 1 : -1;
        });
        for (Carrier.CommType commType : commTypes) {
            List<Carrier> responseMap = new ArrayList<>();
            response1.put(commType, responseMap);
        }

        Iterable<Carrier> carriers = carrierRepository.findAll();

        carriers.forEach((Carrier carrier) -> {
            List<Carrier> cl = response1.get(carrier.getType());
            cl.add(carrier);
            response1.put(carrier.getType(), cl);
        });

        List<Object> response = new ArrayList<>();
        response1.forEach((Carrier.CommType key, Object value) -> {
            Map<String, Object> responseMap = new HashMap<>();
            responseMap.put("carriers", value);
            responseMap.put("type", key.commName);
            responseMap.put("displayName", key.displayName);
            response.add(responseMap);
        });

        return response;
    }

    @PostMapping(path = "/register") // Map ONLY POST Requests
    public  MemberAddResponse registerMember(@RequestParam String firstName,
                                                          @RequestParam String lastName,
                                                          @RequestParam String token
    ) {
        Optional<SMSVerification> sv = smsVerificationRepository
                .findFirstByIdAndVerified(token, true);
        if (sv.isPresent()) {
            int countryCode = sv.get().getCountryCode();
            String phoneNumber = sv.get().getPhoneNumber();

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
