package com.john.healthhack482026.model;

import java.time.LocalDate;
import java.util.Map;

public record Summary(
        LocalDate from,
        LocalDate to,
        int totalEntries,
        Map<String, Double> averageSeverityBySymptom, //per symptom (a map)
        Map<String, Integer> countBySymptom,    // symptom name -> times logged
        int totalMinutes
) {
}
