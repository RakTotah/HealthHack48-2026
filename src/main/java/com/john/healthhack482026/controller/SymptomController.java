package com.john.healthhack482026.controller;

import com.john.healthhack482026.model.Symptom;
import com.john.healthhack482026.model.Summary;
import com.john.healthhack482026.repository.SymptomLogRepository;

import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

public class SymptomController {

    // G: what were you thinking for the controllers
    // prompting methods from repo


    // log symptoms to repo
    public Symptom logSymptom(String name, int severity, String numericalValue, String notes, int hourDuration, int minuteDuration){
        throw new UnsupportedOperationException();
    }

    // edit entry
    public Symptom editEntry(UUID id, int severity, String notes){
        throw new UnsupportedOperationException();
    }

    // remove entry
    public boolean removeEntry(UUID id){
        throw new UnsupportedOperationException();
    }

    // get history
    public List<Symptom> getHistory() {
        throw new UnsupportedOperationException();
    }

    // get daily, weekly, monthly summary
    private Summary getDailySummary(LocalDate day){
        throw new UnsupportedOperationException();
    }
    private Summary getWeeklySummary(LocalDate weekStart) {
        throw new UnsupportedOperationException();
    }
    private Summary getMonthlySummary(LocalDate monthStart){
        throw new UnsupportedOperationException();
    }

    // export to json
    public String exportToJson(){
        throw new UnsupportedOperationException();
    }

}
