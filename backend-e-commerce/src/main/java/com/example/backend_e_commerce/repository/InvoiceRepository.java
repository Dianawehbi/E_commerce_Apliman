package com.example.backend_e_commerce.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.backend_e_commerce.entity.Invoice;

@Repository
public interface InvoiceRepository extends JpaRepository<Invoice, Integer> {

    Page<Invoice> findByCustomerId(int customerId, Pageable pageable);

    Page<Invoice> findByCustomerUsername(String customer_name, Pageable pageable);

}
