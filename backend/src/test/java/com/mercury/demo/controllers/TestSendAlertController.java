package com.mercury.demo.controllers;

import com.mercury.demo.entities.Alert;
import com.mercury.demo.entities.AlertGroup;
import com.mercury.demo.entities.Member;
import com.mercury.demo.entities.MemberAlertStatus;
import com.mercury.demo.entities.Membership;
import com.mercury.demo.repositories.AlertRepository;
import com.mercury.demo.repositories.MemberAlertStatusRepository;
import com.mercury.demo.repositories.MembershipRepository;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.MockitoAnnotations;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.List;
import java.util.UUID;

public class TestSendAlertController {
    private static final Alert ALERT = new Alert("Earthquake in Milan", "5.4 magnitude Earthquake struck Milan", "Milan Central");
    private static final Member MEMBER = new Member("Giorno", "Giovanna", "39", "12345678910");
    private static final String USER_ID = UUID.randomUUID().toString();

    @Mock
    private AlertRepository mockAlertRepository;
    @Mock
    private MemberAlertStatusRepository mockStatusRepository;
    @Mock
    private MembershipRepository mockMembershipRepository;

    @InjectMocks
    private SendAlertController controller;

    @BeforeEach
    public void setup() {
        MockitoAnnotations.openMocks(this);
        MEMBER.setId(USER_ID);
    }

    @Test
    public void testSendAlert() {
        final AlertGroup group = new AlertGroup("AIA");
        final MemberAlertStatus alertStatusWithoutId = new MemberAlertStatus("456", USER_ID, MemberAlertStatus.Status.UNSEEN);
        final MemberAlertStatus alertStatusWithId = new MemberAlertStatus("456", USER_ID, MemberAlertStatus.Status.UNSEEN);
        alertStatusWithId.setId(678L);
        group.setId("123");
        final Membership membership = new Membership(USER_ID, "123", true);
        final Alert expectedAlert = new Alert("123", "Earthquake in Milan", "5.4 magnitude Earthquake struck Milan");
        expectedAlert.setId("456");

        Mockito.when(mockAlertRepository.save(ALERT)).thenReturn(expectedAlert);
        Mockito.when(mockMembershipRepository.findByGroupId("123")).thenReturn(List.of(membership));
        Mockito.when(mockStatusRepository.save(new MemberAlertStatus("456", USER_ID, MemberAlertStatus.Status.UNSEEN))).thenReturn(alertStatusWithoutId);

        Assertions.assertEquals(expectedAlert, controller.sendAlert("abcd", "Earthquake in Milan", "5.4 magnitude Earthquake struck Milan", "Milan Central"));

        Mockito.verify(mockAlertRepository, Mockito.times(1)).save(ALERT);
        Mockito.verify(mockMembershipRepository, Mockito.times(1)).findByGroupId("123");
        Mockito.verify(mockStatusRepository, Mockito.times(1)).save(alertStatusWithoutId);
    }

    @Test
    public void testGetLatestAlerts() {
        final MemberAlertStatus statusOne = new MemberAlertStatus("456", USER_ID, MemberAlertStatus.Status.UNSEEN);
        final MemberAlertStatus statusTwo = new MemberAlertStatus("456", USER_ID, MemberAlertStatus.Status.UNSEEN);
        final List<MemberAlertStatus> expectedAlerts = List.of(statusOne, statusTwo);

        Mockito.when(mockStatusRepository.findByMemberIdAndStatus(MEMBER.getId(), MemberAlertStatus.Status.UNSEEN)).thenReturn(List.of(statusOne, statusTwo));

        Assertions.assertEquals(expectedAlerts, controller.getLatestAlerts(MEMBER.getId()));
        Mockito.verify(mockStatusRepository, Mockito.times(1)).findByMemberIdAndStatus(MEMBER.getId(), MemberAlertStatus.Status.UNSEEN);
    }

    @Test
    public void testConfirmAlertsSeen() {
        final MemberAlertStatus statusOneSeen = new MemberAlertStatus("456", USER_ID, MemberAlertStatus.Status.SEEN);
        final MemberAlertStatus statusOneUnseen = new MemberAlertStatus("789", USER_ID, MemberAlertStatus.Status.UNSEEN);
        final MemberAlertStatus statusTwoSeen = new MemberAlertStatus("12", USER_ID, MemberAlertStatus.Status.SEEN);
        final MemberAlertStatus statusTwoUnseen = new MemberAlertStatus("34", USER_ID, MemberAlertStatus.Status.UNSEEN);
        final List<MemberAlertStatus> expectedAlerts = List.of(statusOneSeen, statusOneUnseen, statusTwoSeen, statusTwoUnseen);
        final List<MemberAlertStatus> updatedAlerts = expectedAlerts.stream().map(alert -> new MemberAlertStatus(alert.getId(), alert.getAlertId(), alert.getMemberId(), MemberAlertStatus.Status.SEEN)).toList();

        Mockito.when(mockStatusRepository.saveAll(updatedAlerts)).thenReturn(expectedAlerts);

        Assertions.assertEquals(expectedAlerts, controller.confirmAlertsSeen(USER_ID, expectedAlerts));

        Mockito.verify(mockStatusRepository, Mockito.times(1)).saveAll(updatedAlerts);
    }

    @Test
    public void testConfirmAlertsSeenWithNoAlerts() {
        final MemberAlertStatus statusOneSeen = new MemberAlertStatus("456", "Gone", MemberAlertStatus.Status.SEEN);
        final MemberAlertStatus statusOneUnseen = new MemberAlertStatus("789", "Gone", MemberAlertStatus.Status.UNSEEN);
        final MemberAlertStatus statusTwoSeen = new MemberAlertStatus("12", "Gone", MemberAlertStatus.Status.SEEN);
        final MemberAlertStatus statusTwoUnseen = new MemberAlertStatus("34", "Gone", MemberAlertStatus.Status.UNSEEN);
        final List<MemberAlertStatus> notCorrectAlerts = List.of(statusOneSeen, statusOneUnseen, statusTwoSeen, statusTwoUnseen);
        final List<MemberAlertStatus> expectedAlerts = List.of();

        Assertions.assertEquals(expectedAlerts, controller.confirmAlertsSeen(USER_ID, notCorrectAlerts));
    }
}