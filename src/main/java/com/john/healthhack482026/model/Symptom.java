package com.john.healthhack482026.model;

import java.time.Instant;
import java.time.LocalTime;
import java.util.UUID;

public class Symptom {
    private String name;
    private int severity;
    private String numericalValue;
    private Instant time;
    private String notes;
    private int hourDuration;
    private int minuteDuration;
    private UUID id;
    private UUID user;


    public Symptom(String name, int severity, String numericalValue, String notes, int hourDuration, int minuteDuration, UUID user){
        this.name = name;
        this.severity = severity;
        this.numericalValue = numericalValue;
        this.time = Instant.now();
        this.notes = notes;
        this.hourDuration = hourDuration;
        this.minuteDuration = minuteDuration;
        this.id = UUID.randomUUID();
        this.user = user;
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

    public int getHourDuration(){return this.hourDuration;}

    public int getMinuteDuration(){return this.minuteDuration;}

    public UUID getId(){ return this.id;}
}
