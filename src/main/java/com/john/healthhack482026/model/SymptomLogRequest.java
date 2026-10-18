package com.john.healthhack482026.model;

public record SymptomLogRequest(
        String username,
        String password,
        String name,
        int severity,
        String notes,
        int hourDuration,
        int minuteDuration
) {}
