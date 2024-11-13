package com.mercury.demo;

import com.mercury.demo.entities.Carrier;
import com.mercury.demo.entities.Member;
import com.mercury.demo.repositories.CarrierRepository;
import com.mercury.demo.repositories.MemberRepository;
import jakarta.annotation.Nullable;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationListener;
import org.springframework.context.event.ContextRefreshedEvent;
import org.springframework.stereotype.Component;

@Component
public class StartupListener implements ApplicationListener<ContextRefreshedEvent> {

    @Autowired
    CarrierRepository carrierRepository;

    @Autowired
    MemberRepository memberRepository;

    @Override
    public void onApplicationEvent(@Nullable ContextRefreshedEvent event) {
        carrierRepository.save(
                new Carrier("at&t", "AT&T", "txt.att.net", false));
        carrierRepository.save(
                new Carrier("verizon", "Verizon", "vtext.com", false));

        memberRepository.save(
                new Member("Aidan", "Sacco", "1", "6503958675"));
    }
}
