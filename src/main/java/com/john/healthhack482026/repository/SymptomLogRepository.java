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
        // Creating parent directory if needed
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
            List<Symptom> symptomLst = objectMapper.readValue(storagePath.toFile(),
                    new TypeReference<List<Symptom>>(){}).stream().filter(x -> x.);
        }
        catch (Exception ignored){
        }
    }

    @Override
    public Optional<Symptom> findByID(UUID id) {
        return Optional.empty();
    }

    @Override
    public List<Symptom> getAll() {
        return List.of();
    }

    @Override
    public List<Symptom> findByDateRange(Instant start, Instant end) {
        return List.of();
    }

    @Override
    public boolean delete(UUID id) {
        return false;
    }

    @Override
    public Symptom save(Symptom symptom) {
        return symptom;
    }
    // methods:
    // find by date range
    // find by symptom
    // find by severity
    // delete
    // add
    // get all
    // count
    // clear
}
