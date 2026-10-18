package com.john.healthhack482026.mapper;

import com.john.healthhack482026.model.User;
import com.john.healthhack482026.model.UserRequest;
import com.john.healthhack482026.repository.LoginInfoRepository;
import org.springframework.stereotype.Component;

@Component
public class RequestMapper {

    LoginInfoRepository loginRepo;

    public RequestMapper(LoginInfoRepository loginRepo){
        this.loginRepo = loginRepo;
    }

    public User toUser(UserRequest request){
        if (!loginRepo.checkLogin(request.username(), request.password())){
            throw new IllegalArgumentException("Incorrect username or password");
        }
        return new User(
                request.username(),
                request.password(),
                loginRepo.getID(request.username(), request.password())
                );
    }
}
