package com.john.healthhack482026.service;

import com.john.healthhack482026.Exceptions.SymptomNotFoundException;
import com.john.healthhack482026.model.Symptom;
import com.john.healthhack482026.model.Summary;
import com.john.healthhack482026.model.User;
import com.john.healthhack482026.repository.SymptomLogRepository;
import org.springframework.stereotype.Service;
import tools.jackson.databind.ObjectMapper;

import java.time.Instant;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class SymptomService {

    // G: what were you thinking for the controllers
    // prompting methods from repo
    // add to user id as a prarmeter to all methods

    private final SymptomLogRepository repo;
    private final ObjectMapper objectMapper;
    private final ZoneId zone = ZoneId.systemDefault();

    public SymptomService(SymptomLogRepository repo, ObjectMapper objectMapper) {
        this.repo = repo;
        this.objectMapper = objectMapper;
    }

    // find by symptomId
    public Symptom findById(UUID symptomId, User user){
        Optional<Symptom> temp = repo.getAll().stream().filter(x -> x.getSymptomId() == symptomId).findFirst();
        if (temp.isEmpty()){throw new SymptomNotFoundException("No Symptom with symptomId" + symptomId + " that belongs you to.");}
        return temp.get();
    }

    // find by date range
    public List<Symptom> findByDateRange(Instant start, Instant end, User user) {
        return repo.getAll().stream().filter(x -> (x.getTime().isAfter(start) && x.getTime().isBefore(end))).toList();
    }

    // find by date
    public List<Symptom> findByDay(LocalDate day, User user) {
        return repo.getAll().stream().filter(symptom -> symptom.getTime().atZone(zone).toLocalDate().equals(day)).toList();
    }

    // find by user id
    public List<Symptom> findByUser(User user){
        return repo.getAll().stream().filter(symptom -> (symptom.getUserID() == user.getUserId())).toList();
    }

    // log symptoms to repo
    public Symptom logSymptom(String name, int severity, String notes, int hourDuration, int minuteDuration, User user) {
        validate(name, severity, hourDuration, minuteDuration, user);
        return repo.save(new Symptom(name.trim(), severity, notes, hourDuration, minuteDuration, user.getUserId()));
    }

    // edit entry
    public Symptom editEntry(UUID symptomId, int severity, String notes, User user){
        Symptom s = findById(symptomId, user);
        validate(s.getName(),severity,0,0, user);
        s.changeSeverity(severity);
        s.updateNotes(notes);
        repo.delete(symptomId);        //inital idea was to make an update method in the log class but that is too inefficient, this works well
        return repo.save(s);
    }

    // remove entry
    public boolean removeEntry(UUID symptomId, User user){
        return repo.delete(symptomId);
    }

    // get daily, weekly, monthly summary (uses buildSummary,will do it later)
    private Summary getDailySummary(LocalDate day, User user){
        return buildSummary(day,day, user);
    }
    private Summary getWeeklySummary(LocalDate weekStart, User user) {
        return buildSummary(weekStart, weekStart.plusDays(6), user);
    }
    private Summary getMonthlySummary(LocalDate monthStart, User user){
        return buildSummary(monthStart, monthStart.withDayOfMonth(monthStart.lengthOfMonth()), user);
    }

    // export to json
    public String exportToJson(User user){
        return objectMapper.writerWithDefaultPrettyPrinter().writeValueAsString(repo.getAll());
    }

    // helpers
    private void validate(String name, int severity, int hourDuration, int minuteDuration, User user){
        if (name == null || name.isBlank()){throw new IllegalArgumentException("Name is required");}
        if (severity < 1 || severity > 10){throw new IllegalArgumentException("Severity must be 1 to 10");}
        if (hourDuration < 0 || minuteDuration < 0 || minuteDuration > 59){throw new IllegalArgumentException("Invalid Duration");}
    }

    private Summary buildSummary(LocalDate from, LocalDate to, User user) {
        Instant start = from.atStartOfDay(zone).toInstant();
        Instant endExclusive = to.plusDays(1).atStartOfDay(zone).toInstant();
        List<Symptom> entries = findByDateRange(start, endExclusive, user);

        // "Headache" and "headache" count as the same symptom
        Map<String, Double> averageSeverityBySymptom = entries.stream()
                .collect(Collectors.groupingBy(
                        s -> s.getName().toLowerCase(),
                        Collectors.averagingInt(Symptom::getSeverity)));

        Map<String, Integer> counts = new HashMap<>();
        for (Symptom s : entries) {
            counts.merge(s.getName().toLowerCase(), 1, Integer::sum);
        }

        int totalTime = entries.stream()
                .mapToInt(s -> s.getHourDuration() * 60 + s.getMinuteDuration())
                .sum();

        return new Summary(from, to, entries.size(), averageSeverityBySymptom, counts, totalTime);
    }

    public List<Symptom> getHistory() {
        return repo.getAll();
    }

    /*
    private List<Symptom> getEverythingStored(){
                return Stream.concat(this.getAll().stream(), this.loadAll().stream()).collect(Collectors.toSet()).stream().toList();
    }*/
}