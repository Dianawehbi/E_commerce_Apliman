package com.example.backend_e_commerce.exceptions;

public class BusinessRuleException extends RuntimeException {
    public BusinessRuleException(String message) { super(message); }
}