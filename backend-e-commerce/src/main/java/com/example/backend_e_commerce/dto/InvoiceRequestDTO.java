package com.example.backend_e_commerce.dto;

import java.util.List;

import lombok.Data;

@Data
public class InvoiceRequestDTO {
    private Integer customerId; 
    private List<InvoiceItemsRequestDTO> invoiceitems;
}
// maybe we can create many invoice , one for reponse , request
// one for update