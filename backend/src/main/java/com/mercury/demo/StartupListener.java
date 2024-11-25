package com.mercury.demo;

import com.mercury.demo.entities.Carrier;
import com.mercury.demo.repositories.CarrierRepository;
import jakarta.annotation.Nullable;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationListener;
import org.springframework.context.event.ContextRefreshedEvent;
import org.springframework.stereotype.Component;

@Component
public class StartupListener implements ApplicationListener<ContextRefreshedEvent> {
    CarrierRepository carrierRepository;

    @Autowired
    public StartupListener(final CarrierRepository carrierRepository) {
        this.carrierRepository = carrierRepository;
    }

    @Override
    public void onApplicationEvent(@Nullable ContextRefreshedEvent event) {
        carrierRepository.save(
                new Carrier(Carrier.CommType.SMS, "att", "AT&T", "%s@txt.att.net", false));
        carrierRepository.save(
                new Carrier(Carrier.CommType.SMS, "verizon", "Verizon", "%s@vtext.com", false));
        carrierRepository.save(
                new Carrier(Carrier.CommType.SMS, "tmobile", "T-Mobile", "%s@tmomail.net", false));
        carrierRepository.save(
                new Carrier(Carrier.CommType.EMAIL, "email", "E-Mail", "%s", false));
    }
}
