package com.mercury.demo.controllers;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.mercury.demo.entities.Alert;
import com.mercury.demo.entities.AlertGroup;
import com.mercury.demo.entities.Member;
import com.mercury.demo.entities.MemberAlertStatus;
import com.mercury.demo.entities.MemberAlertStatus.Status;
import com.mercury.demo.entities.Membership;
import com.mercury.demo.entities.exceptions.MapperJsonProcessingException;
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

import java.time.Instant;
import java.util.List;
import java.util.UUID;

public class TestSendAlertController {
    private static final String DESCRIPTION = "5.4 magnitude Earthquake struck Milan";
    private static final String TITLE = "Earthquake in Milan";
    private static final String GROUP_ID = "123";
    private static final Alert ALERT = new Alert(GROUP_ID, TITLE, DESCRIPTION);
    private static final Member MEMBER = new Member("Giorno", "Giovanna", 39, "12345678910");
    private static final String USER_ID = UUID.randomUUID().toString();
    private static final String NO_USER_ID = "Gone";
    private static final ObjectMapper MAPPER = new ObjectMapper();

    @Mock
    private AlertRepository mockAlertRepository;

    @Mock
    private MemberAlertStatusRepository mockStatusRepository;

    @Mock
    private MembershipRepository mockMembershipRepository;

    @Mock
    private ObjectMapper mockMapper;

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
        final MemberAlertStatus alertStatusWithoutId = new MemberAlertStatus(GROUP_ID, USER_ID, MemberAlertStatus.Status.UNSEEN);
        final MemberAlertStatus alertStatusWithId = new MemberAlertStatus(GROUP_ID, USER_ID, MemberAlertStatus.Status.UNSEEN);
        final Membership membership = new Membership(USER_ID, GROUP_ID, true);
        final Alert expectedAlert = new Alert(GROUP_ID, TITLE, DESCRIPTION);
        expectedAlert.setId(GROUP_ID);

        Mockito.when(mockAlertRepository.save(ALERT)).thenReturn(expectedAlert);
        Mockito.when(mockMembershipRepository.findByGroupId(GROUP_ID)).thenReturn(List.of(membership));
        Mockito.when(mockStatusRepository.save(new MemberAlertStatus(GROUP_ID, USER_ID, MemberAlertStatus.Status.UNSEEN))).thenReturn(alertStatusWithoutId);

        Assertions.assertEquals(expectedAlert, controller.sendAlert("abcd", GROUP_ID, TITLE, DESCRIPTION));

        Mockito.verify(mockAlertRepository, Mockito.times(1)).save(ALERT);
        Mockito.verify(mockMembershipRepository, Mockito.times(1)).findByGroupId("123");
        Mockito.verify(mockStatusRepository, Mockito.times(1)).save(alertStatusWithoutId);
    }

    @Test
    public void testSendAlertToAMember() {
        final Membership membership = new Membership(USER_ID, GROUP_ID, false);

        Mockito.when(mockMembershipRepository.findByMemberIdAndGroupId(USER_ID, GROUP_ID)).thenReturn(membership);

        Assertions.assertEquals(null, controller.sendAlert(USER_ID, GROUP_ID, TITLE, DESCRIPTION));

        Mockito.verify(mockMembershipRepository, Mockito.times(1)).findByMemberIdAndGroupId(Mockito.anyString(), Mockito.anyString());
    }

    @Test
    public void testGetLatestAlerts() {
        final MemberAlertStatus alertStatusOne = new MemberAlertStatus(GROUP_ID, MEMBER.getId(), Status.UNSEEN);
        final MemberAlertStatus alertStatusTwo = new MemberAlertStatus(NO_USER_ID, MEMBER.getId(), Status.SEEN);
        final Alert alertTwo = new Alert(NO_USER_ID, TITLE, DESCRIPTION);
        final List<Alert> expectedAlerts = List.of(ALERT, alertTwo);

        Mockito.when(mockStatusRepository.findByMemberIdAndStatusOrStatusOrderByLastSeen(MEMBER.getId(), MemberAlertStatus.Status.SEEN, MemberAlertStatus.Status.UNSEEN)).thenReturn(List.of(alertStatusOne, alertStatusTwo));
        Mockito.when(mockAlertRepository.findByIds(List.of(alertStatusOne.getAlertId(), alertStatusTwo.getAlertId()))).thenReturn(expectedAlerts);

        Assertions.assertEquals(expectedAlerts, controller.getLatestAlerts(MEMBER.getId()));

        Mockito.verify(mockStatusRepository, Mockito.times(1)).findByMemberIdAndStatusOrStatusOrderByLastSeen(MEMBER.getId(), MemberAlertStatus.Status.SEEN, MemberAlertStatus.Status.UNSEEN);
        Mockito.verify(mockAlertRepository, Mockito.times(1)).findByIds(Mockito.anyList());
    }

    @Test
    public void testConfirmAlertsSeen() throws JsonProcessingException {
        final MemberAlertStatus statusOneSeen = new MemberAlertStatus(GROUP_ID, USER_ID, MemberAlertStatus.Status.SEEN);
        final MemberAlertStatus statusOneUnseen = new MemberAlertStatus("789", USER_ID, MemberAlertStatus.Status.UNSEEN);
        final MemberAlertStatus statusTwoSeen = new MemberAlertStatus("12", USER_ID, MemberAlertStatus.Status.SEEN);
        final MemberAlertStatus statusTwoUnseen = new MemberAlertStatus("34", USER_ID, MemberAlertStatus.Status.UNSEEN);
        final List<MemberAlertStatus> expectedAlerts = List.of(statusOneSeen, statusOneUnseen, statusTwoSeen, statusTwoUnseen);
        final List<MemberAlertStatus> updatedAlerts = expectedAlerts.stream().map(alert -> new MemberAlertStatus(alert.getAlertId(), alert.getMemberId(), Status.SEEN)).toList();
        controller.objectMapper = MAPPER;

        Mockito.when(mockStatusRepository.findByAlertIds(expectedAlerts.stream().map(MemberAlertStatus::getAlertId).toList())).thenReturn(expectedAlerts);
        Mockito.when(mockStatusRepository.save(updatedAlerts.get(0))).thenReturn(updatedAlerts.get(0));
        Mockito.when(mockStatusRepository.save(updatedAlerts.get(1))).thenReturn(updatedAlerts.get(1));
        Mockito.when(mockStatusRepository.save(updatedAlerts.get(2))).thenReturn(updatedAlerts.get(2));
        Mockito.when(mockStatusRepository.save(updatedAlerts.get(3))).thenReturn(updatedAlerts.get(3));

        Assertions.assertEquals(updatedAlerts, controller.confirmAlertsSeen(USER_ID, MAPPER.writeValueAsString(expectedAlerts.stream().map(MemberAlertStatus::getAlertId).toList())));

        Mockito.verify(mockStatusRepository, Mockito.times(1)).findByAlertIds(Mockito.anyList());
        Mockito.verify(mockStatusRepository, Mockito.times(4)).save(Mockito.any());
    }

    @Test
    public void testConfirmAlertsSeenWithWrongAlerts() throws JsonProcessingException {
        final MemberAlertStatus status = new MemberAlertStatus(GROUP_ID, GROUP_ID, MemberAlertStatus.Status.SEEN);
        final List<String> alertId = List.of(status.getAlertId());
        final List<MemberAlertStatus> expectedAlerts = List.of(status);
        controller.objectMapper = MAPPER;

        Mockito.when(mockStatusRepository.findByAlertIds(alertId)).thenReturn(expectedAlerts);

        Assertions.assertEquals(List.of(), controller.confirmAlertsSeen(USER_ID, MAPPER.writeValueAsString(alertId)));

        Mockito.verify(mockStatusRepository, Mockito.times(1)).findByAlertIds(Mockito.anyList());
    }

    @Test
    public void testConfirmAlertsThrowsJsonProcessingException() throws JsonProcessingException {
        final MemberAlertStatus status = new MemberAlertStatus(GROUP_ID, GROUP_ID, MemberAlertStatus.Status.SEEN);
        final List<String> expectedAlerts = List.of(status.getAlertId());
        controller.objectMapper = mockMapper;

        Mockito.when(mockMapper.readValue(Mockito.eq(MAPPER.writeValueAsString(expectedAlerts)), Mockito.any(TypeReference.class))).thenThrow(new JsonProcessingException("Mocked exception") {});

        Assertions.assertThrows(MapperJsonProcessingException.class, () -> controller.confirmAlertsSeen(USER_ID, MAPPER.writeValueAsString(expectedAlerts)));

        Mockito.verify(mockMapper, Mockito.times(1)).readValue(Mockito.anyString(), Mockito.any(TypeReference.class));

        controller.objectMapper = MAPPER;
    }

    @Test
    public void testConfirmAlertsSeenWithNoAlerts() throws JsonProcessingException {
        final MemberAlertStatus statusOneSeen = new MemberAlertStatus(GROUP_ID, NO_USER_ID, MemberAlertStatus.Status.SEEN);
        final MemberAlertStatus statusOneUnseen = new MemberAlertStatus("789", NO_USER_ID, MemberAlertStatus.Status.UNSEEN);
        final MemberAlertStatus statusTwoSeen = new MemberAlertStatus("12", NO_USER_ID, MemberAlertStatus.Status.SEEN);
        final MemberAlertStatus statusTwoUnseen = new MemberAlertStatus("34", NO_USER_ID, MemberAlertStatus.Status.UNSEEN);
        final List<String> notCorrectAlerts = List.of(statusOneSeen.getAlertId(), statusOneUnseen.getAlertId(), statusTwoSeen.getAlertId(), statusTwoUnseen.getAlertId());
        final List<MemberAlertStatus> expectedAlerts = List.of();

        Assertions.assertEquals(expectedAlerts, controller.confirmAlertsSeen(USER_ID, MAPPER.writeValueAsString(notCorrectAlerts)));
    }
}