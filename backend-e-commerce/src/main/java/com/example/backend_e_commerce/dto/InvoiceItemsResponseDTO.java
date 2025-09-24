package com.example.backend_e_commerce.dto;

import lombok.Data;

@Data
public class InvoiceItemsResponseDTO {
    private int id;
    private Integer invoiceId;
    private double unitPrice;
    private Integer quantity;
    private ItemResponseDTO item;
}
