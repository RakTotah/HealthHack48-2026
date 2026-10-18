package com.john.healthhack482026.model;

import java.time.LocalDate;
import java.util.Map;

public record Summary(
        LocalDate from,
        LocalDate to,
        int totalEntries,
        double averageSeverity, //per symptom (a list)
        Map<String, Integer> countBySymptom,    // symptom name -> times logged
        int totalMinutes
) {
}
