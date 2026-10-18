package com.john.healthhack482026.model;

import java.time.Instant;
import java.util.UUID;

public class Symptom {
    private String name;
    private int severity;
    private Instant time;
    private String notes;
    private int hourDuration;
    private int minuteDuration;
    private UUID symptomId;
    private UUID userID;


    public Symptom(String name, int severity, String notes, int hourDuration, int minuteDuration, UUID user){
        this.name = name;
        this.severity = severity;
        this.time = Instant.now();
        this.notes = notes;
        this.hourDuration = hourDuration;
        this.minuteDuration = minuteDuration;
        this.symptomId = UUID.randomUUID();
        this.userID = user;
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

    public Instant getTime(){
        return this.time;
    }

    public String getNotes(){
        return this.notes;
    }

    public int getHourDuration(){return this.hourDuration;}

    public int getMinuteDuration(){return this.minuteDuration;}

    public UUID getSymptomId(){ return this.symptomId;}
    public UUID getUserID(){ return this.userID; }
}
