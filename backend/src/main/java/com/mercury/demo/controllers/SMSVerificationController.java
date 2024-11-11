package com.mercury.demo.controllers;

import com.mercury.demo.entities.Member;
import com.mercury.demo.entities.SMSVerification;
import com.mercury.demo.entities.Carrier;

import com.mercury.demo.entities.responses.SMSDispatchResponse;
import com.mercury.demo.entities.responses.SMSVerifyResponse;
import com.mercury.demo.repositories.MemberRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.DigestUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.mercury.demo.mail.SMSEmailService;
import com.mercury.demo.repositories.CarrierRepository;
import com.mercury.demo.repositories.SMSVerificationRepository;

import java.util.Optional;

@Controller // This means that this class is a Controller
@RequestMapping(path="/sms") // This means URL's start with /demo (after Application path)
public class SMSVerificationController {
    @Autowired
    private SMSVerificationRepository smsVerificationRepository;

    @Autowired
    private CarrierRepository carrierRepository;

    @Autowired
    private SMSEmailService mailService;

    @Autowired
    private MemberRepository memberRepository;

    @PostMapping(path="/dispatch") // Map ONLY POST Requests
    public @ResponseBody SMSDispatchResponse requestSMSDispatch (@RequestParam String countryCode,
                                                                 @RequestParam String phoneNumber,
                                                                 @RequestParam String carrier
            ) {
        // TODO: Add these to database on server init. Currently necessary here since db is recreated on server start
        carrierRepository.save(new Carrier("at&t", "AT&T", "txt.att.net", false));
        carrierRepository.save(new Carrier("verizon", "Verizon", "vtext.com", false));

        // Calculate expiration time (15 minutes from current moment)
        long expiration = (System.currentTimeMillis() / 1000) + 60 * 15; // 15 minutes

        // Generate random 6 digit code
        StringBuilder code = new StringBuilder();
        for (int i = 0; i < 6; i++) {
            code.append((int) (Math.random() * 10));
        }
        String hash = DigestUtils.md5DigestAsHex(code.toString().getBytes());

        // Check if carrier os supported
        Optional<Carrier> optionalCarrier = carrierRepository.findById(carrier);
        if (optionalCarrier.isEmpty()) {
            return new SMSDispatchResponse(false, null);
        }
        Carrier c = optionalCarrier.get();

        // Send the text
        mailService.dispatchSMS(code.toString(), countryCode, phoneNumber, c);

        // Register SMSVerification session
        SMSVerification smsVerification = new SMSVerification(countryCode, phoneNumber, expiration, hash);
        smsVerificationRepository.save(smsVerification);

        // Return token to be used for /verify session lookup
        return new SMSDispatchResponse(true, smsVerification.getId());
    }

    @PostMapping(path="/verify") // Map ONLY POST Requests
    public @ResponseBody SMSVerifyResponse verifySMSCode (@RequestParam String token,
                                                          @RequestParam String code
            ) {
        memberRepository.save(new Member("Aidan", "Sacco", "1", "6503958675"));

        // Search for SMSVerification session using given token
        Optional<SMSVerification> optionalSMSVerificationSession = smsVerificationRepository.findById(token);
        if (optionalSMSVerificationSession.isEmpty()) {
            return new SMSVerifyResponse(false, null);
        }
        SMSVerification smsVerification = optionalSMSVerificationSession.get();

        // Hash the given code and compare to what we have stored in the db
        String codeHash = DigestUtils.md5DigestAsHex(code.getBytes());
        if (!smsVerification.getVerificationCodeHash().equals(codeHash)) {
            return new SMSVerifyResponse(false, null);
        }

        // At this point, we know the verification code was correct. Prepare the response info
        Member userInfo = null;

        // Check to see if a user exists with this phone number
        Optional<Member> member = memberRepository.findByPhoneNumberAndCountryCode(
                smsVerification.getPhoneNumber(),
                smsVerification.getCountryCode());
        if (member.isPresent()) {
            userInfo = member.get();
        }

        // We are done with the verification session, so delete it
        smsVerificationRepository.deleteById(token);

        // Respond with userInfo (if user exists) and note that the code was valid
        return new SMSVerifyResponse(true, userInfo);
    }

    // TODO: Remove this method, it's only for debugging
    @GetMapping(path="/all")
    public @ResponseBody Iterable<SMSVerification> getAllPendingVerifications() {
        // This returns a JSON or XML with the users
        return smsVerificationRepository.findAll();
    }
}
