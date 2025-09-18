package com.example.backend_e_commerce.dto;

import lombok.Data;

@Data
public class ItemResponseDTO {
    private int id;
    private String itemName;
    private String description;
    private String image_path;
    private double price;
    private int stockQuantity;
    private Integer categoryId;
}
