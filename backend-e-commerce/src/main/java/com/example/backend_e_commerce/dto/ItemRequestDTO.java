package com.example.backend_e_commerce.dto;

import lombok.Data;

@Data
public class ItemRequestDTO {
    private String itemName;
    private String description;
    private String image_path;
    private double price;
    private Integer stockQuantity;
    private Integer categoryId;
}
