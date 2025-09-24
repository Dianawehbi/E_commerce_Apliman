package com.example.backend_e_commerce.mapper;

import com.example.backend_e_commerce.dto.InvoiceItemsRequestDTO;
import com.example.backend_e_commerce.dto.InvoiceItemsResponseDTO;
import com.example.backend_e_commerce.entity.InvoiceItems;
import com.example.backend_e_commerce.entity.Item;
import com.example.backend_e_commerce.repository.ItemRepository;

import org.mapstruct.Context;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring")
public interface InvoiceItemMapper {

    @Mapping(target = "invoiceId", source = "invoice.id")
    InvoiceItemsResponseDTO toDto(InvoiceItems invoiceItem);

    @Mapping(target = "invoice", ignore = true)
    @Mapping(target = "item", expression = "java(mapItem(invoiceItemdto.getItemId(), itemRepository))")
    InvoiceItems toEntity(InvoiceItemsRequestDTO invoiceItemdto , @Context ItemRepository itemRepository);

    default Item mapItem(Integer itemId, @Context ItemRepository itemRepository) {
        if (itemId == null) return null;
        return itemRepository.findById(itemId)
                .orElseThrow(() -> new RuntimeException("Item not found with id: " + itemId));
    }
}
