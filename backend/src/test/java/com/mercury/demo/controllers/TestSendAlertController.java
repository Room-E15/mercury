package com.mercury.demo.controllers;

import com.mercury.demo.entities.Alert;
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

import java.util.List;
import java.util.UUID;

public class TestSendAlertController {
    private static final Alert ALERT = new Alert("Earthquake in Milan", "5.4 magnitude Earthquake struck Milan", "Milan Central");
    private static final Member MEMBER = new Member("Giorno", "Giovanna", 39, "12345678910");
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
        final MemberAlertStatus alertStatusWithoutId = new MemberAlertStatus("456", USER_ID, MemberAlertStatus.Status.UNSEEN);
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

        // TODO caden please help...
//        Mockito.when(mockStatusRepository.findByMemberIdAndStatus(MEMBER.getId(), MemberAlertStatus.Status.UNSEEN)).thenReturn(List.of(statusOne, statusTwo));

        Assertions.assertEquals(expectedAlerts, controller.getLatestAlerts(MEMBER.getId()));
//        Mockito.verify(mockStatusRepository, Mockito.times(1)).findByMemberIdAndStatus(MEMBER.getId(), MemberAlertStatus.Status.UNSEEN);
    }

    @Test
    public void testConfirmAlertsSeen() {
        final List<MemberAlertStatus> expectedAlerts = getMemberAlertStatuses(USER_ID);
        final List<MemberAlertStatus> updatedAlerts = expectedAlerts.stream().map(alert -> new MemberAlertStatus(alert.getAlertId(), alert.getMemberId(), MemberAlertStatus.Status.SEEN)).toList();

        Mockito.when(mockStatusRepository.saveAll(updatedAlerts)).thenReturn(expectedAlerts);

        // TODO make sure we're passing the right string CADEN PLEASE HELP (I appreciate you)
        Assertions.assertEquals(expectedAlerts, controller.confirmAlertsSeen(USER_ID, expectedAlerts.stream().map(MemberAlertStatus::getAlertId).toString()));

        Mockito.verify(mockStatusRepository, Mockito.times(1)).saveAll(updatedAlerts);
    }

    private static List<MemberAlertStatus> getMemberAlertStatuses(String userId) {
        final MemberAlertStatus statusOneSeen = new MemberAlertStatus("456", userId, MemberAlertStatus.Status.SEEN);
        final MemberAlertStatus statusOneUnseen = new MemberAlertStatus("789", userId, MemberAlertStatus.Status.UNSEEN);
        final MemberAlertStatus statusTwoSeen = new MemberAlertStatus("12", userId, MemberAlertStatus.Status.SEEN);
        final MemberAlertStatus statusTwoUnseen = new MemberAlertStatus("34", userId, MemberAlertStatus.Status.UNSEEN);
        final List<MemberAlertStatus> expectedAlerts = List.of(statusOneSeen, statusOneUnseen, statusTwoSeen, statusTwoUnseen);
        return expectedAlerts;
    }

    @Test
    public void testConfirmAlertsSeenWithNoAlerts() {
        final List<MemberAlertStatus> notCorrectAlerts = getMemberAlertStatuses("Gone");
        final List<MemberAlertStatus> expectedAlerts = List.of();
        // TODO caden I'm sorry...
//        Assertions.assertEquals(expectedAlerts, controller.confirmAlertsSeen(USER_ID, notCorrectAlerts));
    }
}