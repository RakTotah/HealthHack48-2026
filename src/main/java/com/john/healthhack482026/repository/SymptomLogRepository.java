package com.john.healthhack482026.repository;

import com.john.healthhack482026.config.StorageVariable;
import com.john.healthhack482026.model.Symptom;
import org.springframework.stereotype.Repository;
import tools.jackson.databind.ObjectMapper;

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

    public SymptomLogRepository(StorageVariable storageVariable){
        this.objectMapper = new ObjectMapper();
        System.out.println(storageVariable.file());
//        this.storagePath = Path.of(storageVariable.file());
    }

    public void loadSymptoms(){

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
    public boolean save(Symptom symptom) {
        return false;
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
