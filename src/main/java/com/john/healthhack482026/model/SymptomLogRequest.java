package com.john.healthhack482026.model;

public record SymptomLogRequest(
        String name,
        int severity,
        String notes,
        int hourDuration,
        int minuteDuration
) {}
