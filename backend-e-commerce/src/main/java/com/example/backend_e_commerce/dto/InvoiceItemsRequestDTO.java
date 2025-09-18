package com.example.backend_e_commerce.dto;

import lombok.Data;

@Data
public class InvoiceItemsRequestDTO {
    public Integer itemId;
    private Integer quantity;
}
