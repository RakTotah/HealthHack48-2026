package com.john.healthhack482026.repository;

import com.john.healthhack482026.model.Symptom;
import org.springframework.stereotype.Repository;
import tools.jackson.core.type.TypeReference;
import tools.jackson.databind.ObjectMapper;

import java.nio.file.Files;
import java.nio.file.Path;
import java.time.Instant;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;
import java.util.stream.Stream;

@Repository
public class SymptomLogRepository implements RepositoryInterface {
    private ObjectMapper objectMapper;
    private List<Symptom> allSymptoms;
    private Path storagePath;

    public SymptomLogRepository(UUID userID){
        this.objectMapper = new ObjectMapper();
        this.storagePath = Path.of("./data/symptoms.json");
        this.load(userID);
    }

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
    }


    // since we have find by id we can use this method to update the current instance as
    /*
    public Symptom update(Symptom symptom) {
        for (int i = 0; i < allSymptoms.size(); i++) {
            if (allSymptoms.get(i).getId().equals(symptom.getId())) {
                allSymptoms.set(i, symptom);
                persistToDisk();
                return symptom;
            }
        }
        return symptom;
    }
    */
}
