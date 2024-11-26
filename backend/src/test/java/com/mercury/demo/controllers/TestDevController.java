package com.mercury.demo.controllers;

import com.mercury.demo.entities.AlertGroup;
import com.mercury.demo.entities.Member;
import com.mercury.demo.entities.Membership;
import com.mercury.demo.entities.SMSVerification;
import com.mercury.demo.repositories.AlertGroupRepository;
import com.mercury.demo.repositories.AlertRepository;
import com.mercury.demo.repositories.CarrierRepository;
import com.mercury.demo.repositories.MemberAlertStatusRepository;
import com.mercury.demo.repositories.MemberRepository;
import com.mercury.demo.repositories.MembershipRepository;
import com.mercury.demo.repositories.SMSVerificationRepository;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.ValueSource;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.MockitoAnnotations;

import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;

class TestDevController {
    private static final List<Member> MEMBERS = List.of(
            new Member("Aidan", "Sacco", 1, "6503958675", "att"),
                new Member("Cameron", "Wolff", 1, "9499220667", "verizon"),
            new Member("Caden", "Upson", 1, "9494320420", "verizon"),
                new Member("Rishi", "Gupta", 1, "4088390474", "att"));
    private static final List<AlertGroup> GROUPS = List.of(new AlertGroup("Aidan's Group"),
            new AlertGroup("Cameron's Group"),
            new AlertGroup("Caden's Group"),
            new AlertGroup("Rishi's Group"));
    private static final int COUNTRY_CODE = 1;
    private static final String PHONE_NUMBER = "1234567890";
    private static final String CARRIER = "devcarrier";
    private static final SMSVerification VERIFICATION = new SMSVerification(COUNTRY_CODE, PHONE_NUMBER, CARRIER, 0L, "");

    @Mock
    private AlertGroupRepository mockAlertGroupRepository;

    @Mock
    private AlertRepository mockAlertRepository;

    @Mock
    private CarrierRepository mockCarrierRepository;

    @Mock
    private MemberAlertStatusRepository mockMemberAlertStatusRepository;

    @Mock
    private MemberRepository mockMemberRepository;

    @Mock
    private MembershipRepository mockMembershipRepository;

    @Mock
    private SMSVerificationRepository mockSMSVerificationRepository;

    @InjectMocks
    private DevController controller;

    @BeforeEach
    public void setup() {
        MockitoAnnotations.openMocks(this);
    }

    @ParameterizedTest
    @ValueSource(strings = {"alert_group", "alert", "carrier", "member_alert_status", "member", "membership", "sms_verification", "non-existant"})
    void testWipeTable(final String tableName) {
        final Map<String, String> expectedResponse = !tableName.equals("non-existant") ? Map.of("status", "success", "table", tableName)
                : Map.of("status", "success");

        Assertions.assertEquals(expectedResponse, controller.wipeTable(tableName));
    }

    @Test
    void testWipeDatabaseWithoutPreviousTime() {
        final Map<String, String> expectedResponse = Map.of("status", "pending wipe", "description", "Are you sure you want to wipe the entire database? If so, resend this request within 10 seconds.");

        Assertions.assertEquals(expectedResponse, controller.wipeDatabase());
    }

    @Test
    void testWipeDatabaseWithPreviousTime() {
        controller.previousTime = (System.currentTimeMillis() / 1000) + 15;
        final Map<String, String> expectedResponse = Map.of("status", "success", "description", "Database wiped.");

        Assertions.assertEquals(expectedResponse, controller.wipeDatabase());
    }

    @Test
    void testPopulateWithFullTable() {
        final Map<String, String> expectedResponse = Map.of("status", "success");
        for (final Member member : MEMBERS) {
            Mockito.when(mockMemberRepository.findByPhoneNumberAndCountryCode(
                    member.getPhoneNumber(),
                    member.getCountryCode())).thenReturn(Optional.of(member));
        }
        for (final AlertGroup group : GROUPS) {
            Mockito.when(mockAlertGroupRepository.findByGroupName(group.getGroupName())).thenReturn(Optional.of(group));
            for (final Member member : MEMBERS) {
                final Membership membership = new Membership(member.getId(), group.getId(), group.getGroupName().contains(member.getFirstName()));
                Mockito.when(mockMembershipRepository.save(membership)).thenReturn(membership);
            }
        }

        Assertions.assertEquals(expectedResponse, controller.populate());

        Mockito.verify(mockMemberRepository, Mockito.times(4)).findByPhoneNumberAndCountryCode(Mockito.anyString(), Mockito.anyInt());
        Mockito.verify(mockMembershipRepository, Mockito.times(16)).save(Mockito.any(Membership.class));
        Mockito.verify(mockAlertGroupRepository, Mockito.times(4)).findByGroupName(Mockito.anyString());
    }

    @Test
    void testCreateMember() {
        final String userId = UUID.randomUUID().toString();
        final Member member = MEMBERS.get(0);
        final Member memberWithId = new Member(member.getFirstName(), member.getLastName(), member.getCountryCode(), member.getPhoneNumber(), member.getCarrierId());
        final Map<String, String> expectedResponse = Map.of("status", "success", "id", userId);
        memberWithId.setId(userId);

        Mockito.when(mockMemberRepository.findByPhoneNumberAndCountryCode(member.getPhoneNumber(), member.getCountryCode())).thenReturn(Optional.empty());
        Mockito.when(mockMemberRepository.save(member)).thenReturn(memberWithId);

        Assertions.assertEquals(expectedResponse, controller.createMember(member.getFirstName(), member.getLastName(), member.getCountryCode(), member.getPhoneNumber(), member.getCarrierId()));

        Mockito.verify(mockMemberRepository, Mockito.times(1)).findByPhoneNumberAndCountryCode(Mockito.anyString(), Mockito.anyInt());
        Mockito.verify(mockMemberRepository, Mockito.times(1)).save(Mockito.any());
    }

    @Test
    void testCreateMemberWithMemberExists() {
        final Member member = MEMBERS.get(0);
        final Map<String, String> expectedResponse = Map.of("status", "error", "description", "Member with phone number " + member.getPhoneNumber() + " already exists.");

        Mockito.when(mockMemberRepository.findByPhoneNumberAndCountryCode(member.getPhoneNumber(), member.getCountryCode())).thenReturn(Optional.of(member));

        Assertions.assertEquals(expectedResponse, controller.createMember(member.getFirstName(), member.getLastName(), member.getCountryCode(), member.getPhoneNumber(), member.getCarrierId()));

        Mockito.verify(mockMemberRepository, Mockito.times(1)).findByPhoneNumberAndCountryCode(Mockito.anyString(), Mockito.anyInt());
    }

    @Test
    void testCreateGroup() {
        final String groupId = UUID.randomUUID().toString();
        final AlertGroup group = GROUPS.get(0);
        final AlertGroup groupWithId = new AlertGroup(group.getGroupName());
        final Map<String, String> expectedResponse = Map.of("status", "success", "id", groupId);
        groupWithId.setId(groupId);

        Mockito.when(mockAlertGroupRepository.findByGroupName(group.getGroupName())).thenReturn(Optional.empty());
        Mockito.when(mockAlertGroupRepository.save(group)).thenReturn(groupWithId);

        Assertions.assertEquals(expectedResponse, controller.createGroup(group.getGroupName()));

        Mockito.verify(mockAlertGroupRepository, Mockito.times(1)).findByGroupName(Mockito.anyString());
        Mockito.verify(mockAlertGroupRepository, Mockito.times(1)).save(Mockito.any());
    }

    @Test
    void testCreateGroupWithGroupExists() {
        final AlertGroup group = GROUPS.get(0);
        final Map<String, String> expectedResponse = Map.of("status", "error", "description", "Group with name '" + group.getGroupName() + "' already exists.");

        Mockito.when(mockAlertGroupRepository.findByGroupName(group.getGroupName())).thenReturn(Optional.of(group));

        Assertions.assertEquals(expectedResponse, controller.createGroup(group.getGroupName()));

        Mockito.verify(mockAlertGroupRepository, Mockito.times(1)).findByGroupName(Mockito.anyString());
    }

    @Test
    void testForceVerify() {
        final Map<String, String> expectedResponse = Map.of("status", "success", "description", "Number created and verified.");

        Mockito.when(mockSMSVerificationRepository.findByPhoneNumberAndCountryCode(PHONE_NUMBER, COUNTRY_CODE)).thenReturn(Optional.empty());
        Mockito.when(mockSMSVerificationRepository.save(VERIFICATION)).thenReturn(VERIFICATION);

        Assertions.assertEquals(expectedResponse, controller.forceVerify(PHONE_NUMBER, COUNTRY_CODE, CARRIER));

        Mockito.verify(mockSMSVerificationRepository, Mockito.times(1)).findByPhoneNumberAndCountryCode(Mockito.anyString(), Mockito.anyInt());
        Mockito.verify(mockSMSVerificationRepository, Mockito.times(2)).save(Mockito.any());
    }

    @Test
    void testForceVerifyIsVerified() {
        VERIFICATION.setVerified(true);
        final Map<String, String> expectedResponse = Map.of("status", "no-change", "description", "Number already verified.");

        Mockito.when(mockSMSVerificationRepository.findByPhoneNumberAndCountryCode(PHONE_NUMBER, COUNTRY_CODE)).thenReturn(Optional.of(VERIFICATION));

        Assertions.assertEquals(expectedResponse, controller.forceVerify(PHONE_NUMBER, COUNTRY_CODE, CARRIER));

        Mockito.verify(mockSMSVerificationRepository, Mockito.times(1)).findByPhoneNumberAndCountryCode(Mockito.anyString(), Mockito.anyInt());
    }

    @Test
    void testForceVerifyIsNotVerified() {
        VERIFICATION.setVerified(false);
        final Map<String, String> expectedResponse = Map.of("status", "success", "description", "Number verified.");

        Mockito.when(mockSMSVerificationRepository.findByPhoneNumberAndCountryCode(PHONE_NUMBER, COUNTRY_CODE)).thenReturn(Optional.of(VERIFICATION));
        Mockito.when(mockSMSVerificationRepository.save(VERIFICATION)).thenReturn(VERIFICATION);

        Assertions.assertEquals(expectedResponse, controller.forceVerify(PHONE_NUMBER, COUNTRY_CODE, CARRIER));

        Mockito.verify(mockSMSVerificationRepository, Mockito.times(1)).findByPhoneNumberAndCountryCode(Mockito.anyString(), Mockito.anyInt());
        Mockito.verify(mockSMSVerificationRepository, Mockito.times(1)).save(Mockito.any());
    }
}
