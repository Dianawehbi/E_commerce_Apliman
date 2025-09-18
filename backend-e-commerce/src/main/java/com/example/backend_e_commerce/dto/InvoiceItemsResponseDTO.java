package com.example.backend_e_commerce.dto;

import lombok.Data;

@Data
public class InvoiceItemsResponseDTO {
    private int id;
    public Integer itemId;
    private Integer invoiceId;
    private double unitPrice;
    private Integer quantity;
}
