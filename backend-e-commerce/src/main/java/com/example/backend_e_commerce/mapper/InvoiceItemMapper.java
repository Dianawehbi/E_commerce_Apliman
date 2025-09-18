package com.example.backend_e_commerce.mapper;

import com.example.backend_e_commerce.dto.InvoiceItemsRequestDTO;
import com.example.backend_e_commerce.dto.InvoiceItemsResponseDTO;
import com.example.backend_e_commerce.entity.InvoiceItems;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring")
public interface InvoiceItemMapper {

    @Mapping(target = "itemId", source = "item.id")
    @Mapping(target = "invoiceId", source = "invoice.id")
    InvoiceItemsResponseDTO toDto(InvoiceItems invoiceItem);

    @Mapping(target = "invoice", ignore = true)
    @Mapping(target = "item", ignore = true)
    InvoiceItems toEntity(InvoiceItemsRequestDTO invoiceItemdto);
}
