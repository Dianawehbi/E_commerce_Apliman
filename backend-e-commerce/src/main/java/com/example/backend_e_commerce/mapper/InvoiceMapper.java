package com.example.backend_e_commerce.mapper;

import com.example.backend_e_commerce.dto.InvoiceRequestDTO;
import com.example.backend_e_commerce.dto.InvoiceResponseDTO;
import com.example.backend_e_commerce.entity.Invoice;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring", uses = {InvoiceItemMapper.class})
public interface InvoiceMapper {

    @Mapping(target = "customerId", source = "customer.id")
    @Mapping(target = "invoiceitems", source = "invoiceItems")
    InvoiceResponseDTO toDto(Invoice invoice);

    @Mapping(target = "customer", ignore = true)   // will be set manually in service
    @Mapping(target = "invoiceItems", ignore = true) // handled separately
    Invoice toEntity(InvoiceRequestDTO invoicedto);
}
