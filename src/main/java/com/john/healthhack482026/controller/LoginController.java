package com.john.healthhack482026.controller;

import com.john.healthhack482026.model.User;
import com.john.healthhack482026.model.UserRequest;
import com.john.healthhack482026.repository.LoginInfoRepository;
import com.john.healthhack482026.service.LoginService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class LoginController {
    private LoginService service;

    public LoginController(LoginService loginService){
        this.service = loginService;
    }

    @PostMapping("/register")
    public ResponseEntity<User> registerLogin(@Valid @RequestBody UserRequest request){
        User temp = service.register(request.username(), request.password());
        return ResponseEntity.status(HttpStatus.CREATED).body(temp);
    }

    @GetMapping("/login")
    public ResponseEntity<Boolean> attemptLogin(@Valid @RequestBody UserRequest request){
        boolean successful = service.checkUserDetails(request.username(), request.password());
        return ResponseEntity.status(successful?HttpStatus.ACCEPTED:HttpStatus.FORBIDDEN).body(successful);
    }
}
