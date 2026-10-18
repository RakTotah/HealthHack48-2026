package com.john.healthhack482026.repoository;

import com.john.healthhack482026.config.StorageVariable;
import com.john.healthhack482026.model.Symptom;
import org.springframework.stereotype.Repository;
import tools.jackson.databind.ObjectMapper;

import java.nio.file.Path;
import java.util.List;

@Repository
public class SymptomLogRepository {
    private ObjectMapper objectMapper;
    private List<Symptom> allSymptoms;
    private Path storagePath;

    public SymptomLogRepository(StorageVariable storageVariable){
        this.objectMapper = new ObjectMapper();
        this.storagePath = Path.of(storageVariable.file);
    }

    public void loadSymptoms(){

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
