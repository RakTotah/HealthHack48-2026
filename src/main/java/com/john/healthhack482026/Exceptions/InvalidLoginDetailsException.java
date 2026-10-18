package com.john.healthhack482026.Exceptions;

public class InvalidLoginDetailsException extends RuntimeException {
    public InvalidLoginDetailsException(String message) {
        super(message);
    }
}
