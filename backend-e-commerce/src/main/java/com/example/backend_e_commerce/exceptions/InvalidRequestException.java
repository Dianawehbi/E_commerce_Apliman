package com.example.backend_e_commerce.exceptions;

public class InvalidRequestException extends RuntimeException {
    public InvalidRequestException(String message) { super(message); }
}