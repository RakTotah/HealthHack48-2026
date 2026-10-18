package com.john.healthhack482026.service;

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

    private final SymptomLogRepository repo;
    private final ObjectMapper objectMapper;
    private final ZoneId zone = ZoneId.systemDefault();
    private User user;

    public SymptomService(SymptomLogRepository repo, ObjectMapper objectMapper, User user) {
        this.repo = repo;
        this.objectMapper = objectMapper;
        this.user = user;
    }

    // find by id
    public Symptom findById(UUID id){
        Optional<Symptom> temp = repo.findByID(id);
        if (temp.isEmpty()){throw new NoSuchElementException("No Symptom with id" + id + " that belongs you to.");}
        return temp.get();
    }

    // log symptoms to repo
    public Symptom logSymptom(String name, int severity, String numericalValue, String notes, int hourDuration, int minuteDuration) {
        validate(name, severity, hourDuration, minuteDuration);
        return repo.save(new Symptom(name.trim(), severity, numericalValue, notes, hourDuration, minuteDuration, user.getUserId()));
    }

    // edit entry
    public Symptom editEntry(UUID id, int severity, String notes){
        Symptom s = findById(id);
        validate(s.getName(),severity,0,0);
        s.changeSeverity(severity);
        s.updateNotes(notes);
        repo.delete(id);        //inital idea was to make an update method in the log class but that is too inefficient, this works well
        return repo.save(s);
    }

    // remove entry
    public boolean removeEntry(UUID id){
        return repo.delete(id);
    }

    // get daily, weekly, monthly summary (uses buildSummary,will do it later)
    private Summary getDailySummary(LocalDate day){
        return buildSummary(day,day);
    }
    private Summary getWeeklySummary(LocalDate weekStart) {
        return buildSummary(weekStart, weekStart.plusDays(6));
    }
    private Summary getMonthlySummary(LocalDate monthStart){
        return buildSummary(monthStart, monthStart.withDayOfMonth(monthStart.lengthOfMonth()));
    }

    // export to json
    public String exportToJson(){
        return objectMapper.writerWithDefaultPrettyPrinter().writeValueAsString(repo.getAll());
    }

    // helpers
    private void validate(String name, int severity, int hourDuration, int minuteDuration){
        if (name == null || name.isBlank()){throw new IllegalArgumentException("Name is required");}
        if (severity < 1 || severity > 10){throw new IllegalArgumentException("Severity must be 1 to 10");}
        if (hourDuration < 0 || minuteDuration < 0 || minuteDuration > 59){throw new IllegalArgumentException("Invalid Duration");}
    }

    private Summary buildSummary(LocalDate from, LocalDate to) {
        Instant start = from.atStartOfDay(zone).toInstant();
        Instant endExclusive = to.plusDays(1).atStartOfDay(zone).toInstant();
        List<Symptom> entries = repo.findByDateRange(start, endExclusive);

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
   private void load(UUID userID){
        this.allSymptoms = loadAll().stream().filter(x -> x.getUserID() == userID).toList();
    }

    private List<Symptom> loadAll(){
        if (!Files.isDirectory(storagePath.getParent())){
            try {
                Files.createDirectories(storagePath.getParent());
            }
            catch (Exception ignored){
            }
        }

        if (!Files.exists(storagePath)){
            try {
                Files.writeString(storagePath, "[]");
            }
            catch (Exception ignored){
            }
        }

        try {
            return objectMapper.readValue(storagePath.toFile(),
                            new TypeReference<List<Symptom>>(){});
        }
        catch (Exception ignored){
        }

        return List.of();
    }

    private void persistToDisk(){
        objectMapper.writeValue(this.storagePath.toFile(), getEverythingStored());
    }

    @Override
    public Optional<Symptom> findByID(UUID symptomID) {
        return getAll().stream().filter(x -> x.getId() == symptomID).findFirst();
    }

    @Override
    public List<Symptom> getAll() {
        return this.allSymptoms;
    }

    private List<Symptom> getEverythingStored(){
                return Stream.concat(this.getAll().stream(), this.loadAll().stream()).collect(Collectors.toSet()).stream().toList();
    }

    @Override
    public List<Symptom> findByDateRange(Instant start, Instant end) {
        return this.getAll().stream().filter(x -> (
                x.getTime().isAfter(start) && x.getTime().isBefore(end)
                )).toList();
    }

    private boolean isPresent(UUID orderID){
        return !getEverythingStored().stream().filter(x -> x.getId() == orderID).toList().isEmpty();
    }
    @Override
    public boolean delete(UUID id) {
        Optional<Symptom> toRemove = this.findByID(id);
        if (toRemove.isEmpty()){
            return false;
        }

        this.allSymptoms.remove(toRemove.get());
        persistToDisk();
        return true;
    }

    @Override
    public Symptom save(Symptom symptom) {
        if (isPresent(symptom.getId())){
            throw new IllegalArgumentException();
        }
        this.allSymptoms.add(symptom);
        persistToDisk();
        return symptom;
    }*/
}
