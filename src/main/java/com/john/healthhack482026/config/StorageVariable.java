package com.john.healthhack482026.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.stereotype.Component;

@Component
public record StorageVariable() {
    @Value("$(app.storage)")
    public static String file;
}
