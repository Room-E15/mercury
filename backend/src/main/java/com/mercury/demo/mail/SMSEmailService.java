package com.mercury.demo.mail;

import jakarta.mail.Message;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Component;

import com.mercury.demo.entities.Carrier;

import jakarta.mail.MessagingException;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

@Component
public class SMSEmailService implements SMSManager {
    @Autowired
    private JavaMailSender mailSender;

    @Override
    public void dispatchSMS(final String code,
                            final int countryCode,
                            final String phoneNumber,
                            final Carrier carrier) {
        try {
            final String toAddress = carrier.formatTextGateway(countryCode, phoneNumber);
            final MimeMessage message = mailSender.createMimeMessage();
            message.setFrom(new InternetAddress("mercury@asacco.dev"));
            message.setRecipient(Message.RecipientType.TO, new InternetAddress(toAddress));
            final String htmlContent = " Welcome to Mercury! Your verification code is: " + code;
            message.setText(htmlContent);

            mailSender.send(message);
        } catch (final MessagingException ignored) {}
    }
}
