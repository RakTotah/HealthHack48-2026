package com.john.healthhack482026.repository;

import com.john.healthhack482026.model.Symptom;

import java.time.Instant;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface RepositoryInterface {
    public Optional<Symptom> findByID(UUID id);
    public List<Symptom> getAll(UUID userID);
    public List<Symptom> findByDateRange(Instant start, Instant end);
    public boolean delete(UUID id);
    public Symptom save(Symptom symptom);
}
