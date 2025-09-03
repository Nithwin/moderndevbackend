package com.moderndev.moderndevbackend.models;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Data;

import java.sql.Timestamp;

@Entity
@Table(name = "members")
@Data
public class Member {
    @Id
    private long id;
    private String name;
    private Timestamp created_at;
    private String img;
    private String role;
    private String description;
    private String github;
    private String linkedin;
    private String mail;
    private String portfolio;
    private String specialization;
}
