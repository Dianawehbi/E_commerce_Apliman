package com.example.backend_e_commerce.dto;

import java.util.List;

import lombok.Data;

@Data
public class CustomerResponseDTO {
    private int id;
    private String username;
    private String email;
    private String phone;
    private String address;
    private List<Integer> invoiceIds;
}
