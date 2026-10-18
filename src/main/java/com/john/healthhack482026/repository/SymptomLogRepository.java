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
public class SymptomLogRepository {
    private ObjectMapper objectMapper;
    private List<Symptom> allSymptoms;
    private Path storagePath;

    public SymptomLogRepository(UUID userID){
        this.objectMapper = new ObjectMapper();
        this.storagePath = Path.of("./data/symptoms.json");
        this.allSymptoms = loadAll();
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
        objectMapper.writeValue(this.storagePath.toFile(), getAll());
    }

    public List<Symptom> getAll() {
        return this.allSymptoms;
    }

    private boolean isPresent(UUID orderID){
        return !getAll().stream().filter(x -> x.getId() == orderID).toList().isEmpty();
    }

    public boolean delete(UUID id) {
        Optional<Symptom> toRemove = getAll().stream().filter(x -> x.getId()==id).findFirst();
        if (toRemove.isEmpty()){
            return false;
        }

        this.allSymptoms.remove(toRemove.get());
        persistToDisk();
        return true;
    }

    public Symptom save(Symptom symptom) {
        if (isPresent(symptom.getId())){
            throw new IllegalArgumentException();
        }
        this.allSymptoms.add(symptom);
        persistToDisk();
        return symptom;
    }


    // since we have find by id we can use this method to update the current instance as

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

}
