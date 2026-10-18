package com.john.healthhack482026.service;

import com.john.healthhack482026.model.User;
import com.john.healthhack482026.repository.LoginInfoRepository;
import org.springframework.stereotype.Service;

import java.util.UUID;

@Service
public class LoginService {

    LoginInfoRepository loginRepo;

    public LoginService(LoginInfoRepository loginRepo){
        this.loginRepo = loginRepo;
    }

    public User register(String username, String password){
       try{
           User temp = new User(
                   username,
                   password,
                   UUID.randomUUID()
           );
           loginRepo.registerUser(temp);
           return temp;
       } catch (Exception e) {
           throw new RuntimeException();
       }
    }

    public boolean checkUserDetails(String username, String password){
        return loginRepo.checkLogin(username, password);
    }
}
