package com.example.backend_e_commerce.controller;

import java.util.List;

// import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.backend_e_commerce.entity.Invoice;
// import com.example.backend_e_commerce.service.InvoiceService;
import com.example.backend_e_commerce.service.InvoiceService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;

@RestController
@RequestMapping("/invoices")
public class InvoiceController {
    @Autowired
    private InvoiceService invoiceService;

    // create invoice
    @PostMapping
    public Invoice createInvoice(@RequestBody Invoice invoice) {
        return invoiceService.createInvoice(invoice);
    }

    // get all invoices
    @GetMapping
    public Page<Invoice> getAllInvoices(Pageable pageable) {
        return invoiceService.getAllInvoices(pageable);
    }

    // get all by customer id
    @GetMapping("/customer_id")
    public List<Invoice> getInvoiceByCustomerId(@RequestParam int customer_id) {
        return null;
    }

    // get all invoices by customer name
    @GetMapping("/customer_name")
    public List<Invoice> getInvoiceByCustomerName(@RequestParam String customer_name) {
        return null;
    }

    // update invoice
    @PutMapping("/{id}")
    public Invoice updateInvoice(@PathVariable int id, @RequestBody Invoice invoice) {
        return invoiceService.updateInvoice(id, invoice);
    }

    // delete invoice
    @DeleteMapping("/{id}")
    public void deleteInvoice(@PathVariable int id) {
        invoiceService.deleteInvoice(id);
        ;
    }

}
