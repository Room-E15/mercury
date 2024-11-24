package com.mercury.demo.controllers;

import com.mercury.demo.entities.MemberAlertResponse;
import com.mercury.demo.entities.MemberAlertStatus;
import com.mercury.demo.entities.MemberAlertStatus.Status;
import com.mercury.demo.entities.Membership;
import com.mercury.demo.entities.exceptions.DatabaseStateException;
import com.mercury.demo.repositories.MemberAlertResponseRepository;
import com.mercury.demo.repositories.MemberAlertStatusRepository;
import com.mercury.demo.repositories.MembershipRepository;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.MockitoAnnotations;

import java.util.List;
import java.util.UUID;

class TestRespondAlertController {
    private static final String MEMBER_ID = UUID.randomUUID().toString();
    private static final String ALERT_ID = UUID.randomUUID().toString();
    private static final String GROUP_ID = UUID.randomUUID().toString();
    private static final boolean IS_SAFE = true;
    private static final double LATITUDE = 10.0;
    private static final double LONGITUDE = 50.0;
    private static final int BATTERY = 70;

    @Mock
    private MembershipRepository mockMembershipRepository;

    @Mock
    private MemberAlertResponseRepository mockMemberAlertResponseRepository;

    @Mock
    private MemberAlertStatusRepository mockMemberAlertStatusRepository;

    @InjectMocks
    private RespondAlertController controller;

    @BeforeEach
    public void setup() {
        MockitoAnnotations.openMocks(this);
    }

    @Test
    void testSaveAlertResponse() {
        final Membership membership = new Membership(MEMBER_ID, GROUP_ID, false);
        final MemberAlertStatus alertStatus = new MemberAlertStatus(ALERT_ID, MEMBER_ID, Status.UNSEEN);
        final MemberAlertResponse expectedResponse = new MemberAlertResponse(MEMBER_ID, ALERT_ID, IS_SAFE, LATITUDE, LONGITUDE, BATTERY);

        Mockito.when(mockMemberAlertStatusRepository.findByMemberIdAndAlertId(MEMBER_ID, ALERT_ID)).thenReturn(alertStatus);
        Mockito.when(mockMemberAlertResponseRepository.save(expectedResponse)).thenReturn(expectedResponse);

        Assertions.assertEquals(expectedResponse, controller.saveAlertResponse(MEMBER_ID, ALERT_ID, IS_SAFE, LATITUDE, LONGITUDE, BATTERY));

        Mockito.verify(mockMemberAlertStatusRepository, Mockito.times(1)).findByMemberIdAndAlertId(Mockito.anyString(), Mockito.anyString());
        Mockito.verify(mockMemberAlertResponseRepository, Mockito.times(1)).save(Mockito.any());
    }

    @Test
    void testSaveAlertResponseWithNoMember() {
        Mockito.when(mockMemberAlertStatusRepository.findByMemberIdAndAlertId(MEMBER_ID, ALERT_ID)).thenReturn(null);

        Assertions.assertThrows(DatabaseStateException.class, () -> controller.saveAlertResponse(MEMBER_ID, ALERT_ID, IS_SAFE, LATITUDE, LONGITUDE, BATTERY));

        Mockito.verify(mockMemberAlertStatusRepository, Mockito.times(1)).findByMemberIdAndAlertId(Mockito.anyString(), Mockito.anyString());
    }
}
