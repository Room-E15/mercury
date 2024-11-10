package com.mercury.demo.controllers;

import com.mercury.demo.entities.Alert;
import com.mercury.demo.repositories.AlertRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping(path="/alert")
public class SendAlertController {
    @Autowired

    private AlertRepository alertRepository;

    @PostMapping(path="/log")
    public @ResponseBody String logAlert(@RequestParam String title,
                                         @RequestParam String description,
                                         @RequestParam String location,  // TODO figure out location representation
                                         @RequestParam Long groupId) {
       Alert a = new Alert(groupId, title, description, location);
       alertRepository.save(a);
       return "Saved";  // dummy string success message
    }

    @PostMapping(path="/get")
    // TODO implement, should query database to find all notifications for a given user
    // SELECT * FROM MemberAlertStatus WHERE memberId=memberId AND groupId=getFromTable AND alertStatus=Unseen
    public @ResponseBody String getLatestAlerts(@RequestParam Long memberId) {
       return "None found sucks ig";
    }
}
