package com.example.backend_e_commerce.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import com.example.backend_e_commerce.entity.Customer;
import com.example.backend_e_commerce.entity.Invoice;
import com.example.backend_e_commerce.exceptions.ResourceNotFoundException;
import com.example.backend_e_commerce.repository.InvoiceRepository;

import jakarta.transaction.Transactional;

@Service
public class InvoiceService {

    @Autowired
    private InvoiceRepository repo;

    // get all invoices
    public Page<Invoice> getAllInvoices(Pageable pageable) {
        return repo.findAll(pageable);
    }

    // get invoice by customer id
    public List<Customer> searchCustomer(String username, Pageable pageable) {
        return null;
    }

    // get invoice by customer name

    // create new invoice
    @Transactional
    public Invoice createInvoice(Invoice invoice) {
        // using dto
        return repo.save(invoice);
    }

    // delete invoice by id
    public void deleteInvoice(int id) {

        Invoice invoice = repo.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Invoice with id " + id + " was not found"));

        repo.delete(invoice);
    }

    // update invoice
    @Transactional
    public Invoice updateInvoice(int id, Invoice invoice) {
        // verify that a customer with the given ID exists
        Invoice existingInvoice = repo.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Invoice with id " + id + " was not found"));

        //
        // DTO
        //

        // then save
        return repo.save(existingInvoice);
    }

}
