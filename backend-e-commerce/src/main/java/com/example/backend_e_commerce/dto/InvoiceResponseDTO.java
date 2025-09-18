package com.example.backend_e_commerce.dto;

import java.time.Instant;
import java.util.List;

import lombok.Data;

@Data
public class InvoiceResponseDTO {
    private int id;
    private Integer customerId; 
    private double totalAmount;
    private Instant invoiceDate;
    private List<InvoiceItemsResponseDTO> invoiceitems;
}
// maybe we can create many invoice , one for reponse , request
// one for update