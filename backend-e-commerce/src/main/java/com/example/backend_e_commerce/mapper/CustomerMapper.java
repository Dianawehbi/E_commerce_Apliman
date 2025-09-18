package com.example.backend_e_commerce.mapper;

import com.example.backend_e_commerce.dto.CustomerRequestDTO;
import com.example.backend_e_commerce.dto.CustomerResponseDTO;
import com.example.backend_e_commerce.entity.Customer;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring")
public interface CustomerMapper {

    @Mapping(target = "invoiceIds", expression = "java(customer.getInvoices().stream().map(inv -> inv.getId()).toList())")
    CustomerResponseDTO toDto(Customer customer);

    // from DTO → Entity
    @Mapping(target = "invoices", ignore = true) // handled elsewhere
    Customer toEntity(CustomerRequestDTO customerdto);
}
