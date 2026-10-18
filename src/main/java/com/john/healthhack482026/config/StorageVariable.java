package com.john.healthhack482026.config;

import org.springframework.boot.context.properties.ConfigurationProperties;

@ConfigurationProperties(prefix="app.storage")
public record StorageVariable(String file) {
}
