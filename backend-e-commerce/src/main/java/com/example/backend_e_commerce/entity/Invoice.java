package com.example.backend_e_commerce.entity;

import java.time.Instant;
import java.util.ArrayList;
import java.util.List;

import org.hibernate.annotations.CreationTimestamp;

import com.fasterxml.jackson.annotation.JsonIgnore;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Getter @Setter @NoArgsConstructor @AllArgsConstructor
public class Invoice {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    // Customer relation
    @ManyToOne()
    @JoinColumn(name = "customer_id", nullable = false)
    @JsonIgnore
    private Customer customer;

    @Column(columnDefinition = "Decimal(10,2) default 0.00")
    private double total_amount;

    @Column(columnDefinition = "integer default 0")
    private int stock_quantity;

    @CreationTimestamp
    private Instant invoice_date;

    // invoice_items relation
    @OneToMany(mappedBy = "invoice_item", cascade = CascadeType.ALL)
    private List<InvoiceItems> invoiceItems = new ArrayList<>();
}
