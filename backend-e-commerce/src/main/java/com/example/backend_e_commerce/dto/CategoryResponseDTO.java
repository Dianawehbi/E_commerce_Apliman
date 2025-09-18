package com.example.backend_e_commerce.dto;

import java.util.List;

import lombok.Data;

@Data
public class CategoryResponseDTO {
    private int id;
    private String name;
    private String icon;
    private List<ItemResponseDTO> items;
}
