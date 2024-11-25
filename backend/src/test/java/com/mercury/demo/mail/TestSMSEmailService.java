package com.mercury.demo.mail;

import com.mercury.demo.entities.Carrier;
import com.mercury.demo.entities.exceptions.DatabaseStateException;
import jakarta.mail.MessagingException;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.MockitoAnnotations;
import org.springframework.mail.javamail.JavaMailSender;

class TestSMSEmailService {
    private static final String CARRIER_GATEWAY = "txt.testmobile.dev";
    private static final String CARRIER_NAME = "Test Mobile";
    private static final String CARRIER_ID = "testmobile";
    private static final Carrier.CommType CARRIER_TYPE = Carrier.CommType.SMS;
    private static final String PHONE_NUMBER = "1234567890";
    private static final int COUNTRY_CODE = 1;
    private static final String CODE = "CODE";
    private static final Carrier CARRIER = new Carrier(CARRIER_TYPE, CARRIER_ID, CARRIER_NAME, CARRIER_GATEWAY, false);

    @Mock
    private JavaMailSender mockMailSender;

    @InjectMocks
    private SMSEmailService mailService;

    @BeforeEach
    public void setup() {
        MockitoAnnotations.openMocks(this);
    }

    @Test
    void testDispatchSMS() {
        final MimeMessage mimeMessage = Mockito.mock(MimeMessage.class);
        Mockito.when(mockMailSender.createMimeMessage()).thenReturn(
                mimeMessage);

        mailService.dispatchSMS(CODE, COUNTRY_CODE, PHONE_NUMBER, CARRIER);

        Mockito.verify(mockMailSender, Mockito.times(1)).createMimeMessage();
    }

    @Test
    void testDispatchSMSWithMessagingExceptions() throws MessagingException {
        final MimeMessage mimeMessage = Mockito.mock(MimeMessage.class);
        Mockito.when(mockMailSender.createMimeMessage()).thenReturn(
                mimeMessage);
        Mockito.doThrow(new MessagingException()).when(mimeMessage).setFrom(new InternetAddress("mercury@asacco.dev"));

        Assertions.assertThrows(DatabaseStateException.class, () -> mailService.dispatchSMS(CODE, COUNTRY_CODE, PHONE_NUMBER, CARRIER));

        Mockito.verify(mockMailSender, Mockito.times(1)).createMimeMessage();
    }
}
