package com.john.healthhack482026.controller;

import com.john.healthhack482026.mapper.RequestMapper;
import com.john.healthhack482026.model.Symptom;
import com.john.healthhack482026.model.SymptomLogRequest;
import com.john.healthhack482026.model.User;
import com.john.healthhack482026.model.UserRequest;
import com.john.healthhack482026.repository.LoginInfoRepository;
import com.john.healthhack482026.repository.SymptomLogRepository;
import com.john.healthhack482026.service.SymptomService;
import jakarta.validation.Valid;
import org.apache.coyote.Request;
import org.springframework.http.HttpStatus;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.RequestEntity;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.Instant;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

@RestController
public class SymptomController {

   SymptomService service;
   RequestMapper requestMapper;
   LoginInfoRepository loginRepo;

    public SymptomController(SymptomService service, RequestMapper requestMapper, LoginInfoRepository loginRepo){
        this.service = service;
        this.requestMapper = requestMapper;
        this.loginRepo = loginRepo;
    }

    @GetMapping("/symptoms")
    public List<Symptom> getUserSymptoms(@Valid @RequestBody UserRequest request){
        return service.findByUser(requestMapper.toUser(request));
    }

    @GetMapping("/symptoms/{id}")
    public Symptom getSymptomByID(@Valid @RequestBody UserRequest request, @PathVariable String symptomID) {
        return service.findById(UUID.fromString(symptomID), requestMapper.toUser(request));
    }

    @GetMapping("/symptoms/date/{date}")
    public List<Symptom> getSymptomsByDate(@Valid @RequestBody UserRequest request, @PathVariable String date){
        try{
            return service.findByDateRange(Instant.parse(date), Instant.parse(date), requestMapper.toUser(request));
        } catch (Exception e) {
            throw new RuntimeException("Date cannot be parsed, attempt DD-MM-YY. Example: 20-09-05 is the 20th of September 2005");
        }
    }

    @PostMapping("/symptoms")
    public ResponseEntity<Symptom> logSymptom(@Valid @RequestBody SymptomLogRequest request){
        return ResponseEntity.status(HttpStatus.CREATED).body(service.logSymptom(
                request.name(),
                request.severity(),
                request.notes(),
                request.hourDuration(),
                request.minuteDuration(),
                requestMapper.toUser(new UserRequest(request.username(), request.password()))
        ));
    }
}
