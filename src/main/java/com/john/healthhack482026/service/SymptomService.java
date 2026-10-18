package com.john.healthhack482026.service;

import com.john.healthhack482026.model.Symptom;
import com.john.healthhack482026.repository.SymptomLogRepository;
import org.apache.coyote.Response;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RestController;

import java.util.UUID;

@RestController
public class SymptomService {

    SymptomLogRepository repo;
    Symptom

    public ResponseEntity<Symptom> getByID(UUID id){
        return
    }
}
