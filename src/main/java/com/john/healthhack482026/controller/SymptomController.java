package com.john.healthhack482026.controller;

import com.john.healthhack482026.model.Symptom;
import com.john.healthhack482026.repository.SymptomLogRepository;
import com.john.healthhack482026.service.SymptomService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.UUID;

@RestController
public class SymptomController {

   SymptomService service;

    public SymptomController(SymptomService service){
        this.service = service;
    }

    @GetMapping("/symptoms/{id}")
    public Symptom getByID(@PathVariable String id){
        return service.findById(UUID.fromString(id));
    }

    @GetMapping("/symptoms")
    public List<Symptom> getAllSymptoms(){
        return service.getHistory();
    }
}
