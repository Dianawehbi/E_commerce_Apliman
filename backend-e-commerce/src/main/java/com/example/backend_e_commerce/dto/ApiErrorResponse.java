package com.example.backend_e_commerce.dto;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class ApiErrorResponse {
    private LocalDateTime timestamp;
    private int status;
    private String error;
    private String message;

    public ApiErrorResponse(int status, String error, String message) {
        this.timestamp = LocalDateTime.now();
        this.status = status;
        this.error = error;
        this.message = message;
    }

}
