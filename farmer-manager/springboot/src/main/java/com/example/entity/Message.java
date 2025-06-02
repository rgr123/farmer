package com.example.entity;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

@Setter
@Getter

public class Message {
    private Integer id;
    private String user;
    private String avatar;
    private String content;
    private String time;

    // Getters and Setters
}