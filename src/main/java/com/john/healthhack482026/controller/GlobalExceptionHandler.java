package com.john.healthhack482026.controller;

import com.john.healthhack482026.Exceptions.InvalidLoginDetailsException;
import com.john.healthhack482026.Exceptions.StorageException;
import com.john.healthhack482026.Exceptions.SymptomNotFoundException;
import com.john.healthhack482026.dto.ErrorResponse;
import org.apache.coyote.Response;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(InvalidLoginDetailsException.class)
    public ResponseEntity<ErrorResponse> handleInvalidLogin(Exception ex){

        return ResponseEntity.status(HttpStatus.FORBIDDEN).body(new ErrorResponse("INVALID_LOGIN_DETAILS", ex.getMessage()));
    }

    @ExceptionHandler(SymptomNotFoundException.class)
    public ResponseEntity<ErrorResponse> handleSymptomNotFoundException(Exception ex){
        return ResponseEntity.status(HttpStatus.FORBIDDEN).body(new ErrorResponse("SYMPTOM_NOT_FOUND", ex.getMessage()));
    }

    @ExceptionHandler(StorageException.class)
    public ResponseEntity<ErrorResponse> handleStorageException(Exception ex){

        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(new ErrorResponse("UNEXPECTED_STORAGE_ERROR", ex.getMessage()));
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<ErrorResponse> handleGenericException(Exception ex){/**/
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(new ErrorResponse("UNEXPECTED_ERROR", ex.getMessage()));
    }
}

