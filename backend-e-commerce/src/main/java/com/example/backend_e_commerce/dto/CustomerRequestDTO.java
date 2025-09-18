package com.example.backend_e_commerce.dto;

import lombok.Data;

@Data
public class CustomerRequestDTO {
    private String username;
    private String email;
    private String phone;
    private String address;
}
