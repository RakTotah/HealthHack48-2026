package com.john.healthhack482026;

import com.john.healthhack482026.config.StorageVariable;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.properties.ConfigurationPropertiesScan;
import org.springframework.boot.context.properties.EnableConfigurationProperties;

@SpringBootApplication
@EnableConfigurationProperties(StorageVariable.class)
public class HealthHack482026Application {

    public static void main(String[] args) {
        SpringApplication.run(HealthHack482026Application.class, args);
    }

}
