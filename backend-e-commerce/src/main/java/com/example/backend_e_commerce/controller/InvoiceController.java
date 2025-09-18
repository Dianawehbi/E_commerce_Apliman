package com.example.backend_e_commerce.controller;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.backend_e_commerce.dto.InvoiceRequestDTO;
import com.example.backend_e_commerce.dto.InvoiceResponseDTO;
import com.example.backend_e_commerce.service.InvoiceService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;

@RestController
@RequestMapping("/invoices")
public class InvoiceController {
    @Autowired
    private InvoiceService invoiceService;

    // create invoice
    @PostMapping
    public InvoiceResponseDTO createInvoice(@RequestBody InvoiceRequestDTO invoiceRequestDTO) {
        return invoiceService.createInvoice(invoiceRequestDTO);
    }

    // get all invoices
    @GetMapping
    public Page<InvoiceResponseDTO> getAllInvoices(Pageable pageable) {
        return invoiceService.getAllInvoices(pageable);
    }

    // get all by customer id
    @GetMapping("/customer_id/{id}")
    public Page<InvoiceResponseDTO> getInvoiceByCustomerId(@PathVariable int id) {
        return invoiceService.getInvoiceByCustomerId(id, null);
    }

    // get all invoices by customer name
    @GetMapping("/customer_name/{customer_name}")
    public Page<InvoiceResponseDTO> getInvoiceByCustomerName(@PathVariable String customer_name) {
        return invoiceService.getInvoiceByCustomerName(customer_name, null);
    }

    // get invoice by id
    @GetMapping("/{id}")
    public InvoiceResponseDTO getInvoiceById(@PathVariable int id) {
        return invoiceService.getInvoiceById(id);
    }

    // update invoice
    @PutMapping("/{id}")
    public InvoiceResponseDTO updateInvoice(@PathVariable int id, @RequestBody InvoiceRequestDTO invoiceRequestDTO) {
        return invoiceService.updateInvoice(id, invoiceRequestDTO);
    }

    // delete invoice
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteInvoice(@PathVariable int id) {
        invoiceService.deleteInvoice(id);
        return ResponseEntity.noContent().build();
    }

}
