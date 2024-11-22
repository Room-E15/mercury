package com.mercury.demo.mail;

import com.mercury.demo.entities.Carrier;
import jakarta.mail.MessagingException;
import jakarta.mail.Session;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.MockitoAnnotations;
import org.springframework.mail.javamail.JavaMailSender;

import java.util.Properties;

public class TestSMSEmailService {
    private final String CARRIER_GATEWAY = "txt.testmobile.dev";
    private final String CARRIER_NAME = "Test Mobile";
    private final String CARRIER_ID = "testmobile";
    private final String PHONE_NUMBER = "1234567890";
    private final int COUNTRY_CODE = 1;
    private final String CODE = "CODE";
    private final Carrier CARRIER = new Carrier(CARRIER_ID, CARRIER_NAME, CARRIER_GATEWAY, false);

    @Mock
    private JavaMailSender mockMailSender;

    @InjectMocks
    private SMSEmailService mailService;

    @BeforeEach
    public void setup() {
        MockitoAnnotations.openMocks(this);
    }

    @Test
    public void testDispatchSMS() throws MessagingException {
        final MimeMessage mimeMessage = Mockito.mock(MimeMessage.class);
        Mockito.when(mockMailSender.createMimeMessage()).thenReturn(
                mimeMessage);

        mailService.dispatchSMS(CODE, COUNTRY_CODE, PHONE_NUMBER, CARRIER);

        Mockito.verify(mockMailSender, Mockito.times(1)).createMimeMessage();
    }

    @Test
    public void testDispatchSMSWithMessagingExceptions() throws MessagingException {
        final MimeMessage mimeMessage = Mockito.mock(MimeMessage.class);
        Mockito.when(mockMailSender.createMimeMessage()).thenReturn(
                mimeMessage);
        Mockito.doThrow(new MessagingException()).when(mimeMessage).setFrom(new InternetAddress("mercury@asacco.dev"));

        mailService.dispatchSMS(CODE, COUNTRY_CODE, PHONE_NUMBER, CARRIER);

        Mockito.verify(mockMailSender, Mockito.times(1)).createMimeMessage();
    }
}
