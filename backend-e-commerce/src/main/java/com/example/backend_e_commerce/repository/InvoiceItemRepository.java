package com.example.backend_e_commerce.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import org.springframework.stereotype.Repository;

import com.example.backend_e_commerce.entity.InvoiceItems;

@Repository
public interface InvoiceItemRepository extends JpaRepository<InvoiceItems, Integer> {

}
