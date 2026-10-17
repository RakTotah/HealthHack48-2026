package com.john.healthhack482026.model;

import java.time.Instant;

public class Symptom {
    private String name;
    private int severity;
    private String numericalValue;
    private Instant time;
    private String notes;

    public Symptom(String name, int severity, String numericalValue, String notes){
        this.name = name;
        this.severity = severity;
        this.numericalValue = numericalValue;
        this.time = Instant.now();
        this.notes = notes;
    }

    public void changeSeverity(int severity){
        this.severity = severity;
    }

    public void updateNotes(String notes) { this.notes = notes;}

    public String getName(){
        return this.name;
    }

    public int getSeverity(){
        return this.severity;
    }

    public String getNumericalValue(){
        return this.numericalValue;
    }

    public Instant getTime(){
        return this.time;
    }

    public String getNotes(){
        return this.notes;
    }
}
