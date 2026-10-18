package com.john.healthhack482026.Exceptions;

public class UnregisteredUserException extends RuntimeException {
    public UnregisteredUserException(String message) {
        super(message);
    }
}
