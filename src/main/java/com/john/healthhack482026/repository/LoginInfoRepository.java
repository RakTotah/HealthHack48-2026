package com.john.healthhack482026.repository;

import com.john.healthhack482026.model.User;
import org.springframework.stereotype.Repository;
import tools.jackson.core.type.TypeReference;
import tools.jackson.databind.ObjectMapper;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;
import java.util.Objects;
import java.util.Optional;
import java.util.UUID;

@Repository
public class LoginInfoRepository {
    List<User> storedLogins;
    ObjectMapper objectMapper;
    Path storagePath;

    public LoginInfoRepository(){
        this.objectMapper = new ObjectMapper();
        this.storagePath = Path.of("./data/logins.json");
        try{load();} catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    private void load() throws IOException {
        Path parent = storagePath.getParent();
        if (!Files.isDirectory(parent)){
            Files.createDirectories(parent);
        }

        if (Files.notExists(storagePath)){
            Files.writeString(storagePath, "[]");
        }

        this.storedLogins = objectMapper.readValue(
                storagePath.toFile(),
                new TypeReference<List<User>>(){}
                );
    }

    public boolean isRegistered(String username){
        return !this.storedLogins.stream()
                .filter(x -> Objects.equals(x.getUsername(), username))
                .toList().isEmpty();
    }

    private User getUser(String username){
        if (!isRegistered(username)){
            throw new IllegalArgumentException("No user with this username is registered.");
        }
        return storedLogins.stream()
                .filter(x -> Objects.equals(x.getUsername(), username))
                .findFirst().get();
    }

    public boolean checkLogin(String username, String password){
        if (!isRegistered(username)){
            throw new IllegalArgumentException("You are not registered");
        }
        User test = getUser(username);
        return Objects.equals(test.getPassword(), password);
    }

    public UUID getID(String username, String password){
        Optional<User> found = storedLogins.stream()
                .filter(x -> Objects.equals(x.getUsername(), username)
                        && Objects.equals(x.getPassword(), password))
                .findFirst();
        if (found.isEmpty()){
            throw new IllegalArgumentException("Incorrect username or password.");
        }
        return found.get().getUserId();
    }

    public boolean registerUser(User user){
        if (isRegistered(user.getUsername())){
            throw new IllegalArgumentException("This username is taken.");
        }
        storedLogins.add(user);
        persistToDisk();
        return true;
    }

    public boolean deleteUser(User user){
        if (!isRegistered(user.getUsername())){
            throw new IllegalArgumentException("No user with this username is registered");
        }
        storedLogins.remove(user);
        persistToDisk();
        return true;
    }

    private void persistToDisk(){
        objectMapper.writeValue(storagePath.toFile(), storedLogins);
    }
}
