package com.john.healthhack482026.model;

import java.util.UUID;

public class User {
    private String username;
    private String password;
    private UUID userId;

    public User(String username, String password, UUID userId){
        this.username = username;
        this.password = password;
        this.userId = userId;
    }

    public UUID getUserId(){
        return this.userId;
    }

    public String getPassword() { return password; }

    public String getUsername(){ return this.username; }
}
