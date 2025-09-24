package com.example.backend_e_commerce.dto;

import com.example.backend_e_commerce.entity.Item;

import lombok.Data;

@Data
public class InvoiceItemsResponseDTO {
    private int id;
    // public Integer itemId;
    private Integer invoiceId;
    private double unitPrice;
    private Integer quantity;
    private ItemResponseDTO item;
}
