package com.example.backend_e_commerce.entity;

import java.time.Instant;

import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.ManyToOne;

@Entity
public class Invoices {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column()
    // customer can have many invoice , invoice is only for one )
    @ManyToOne()
    private int customer_id;

    @Column(columnDefinition = "Decimal(10,2) default 0.00")
    private double total_amount;

    @Column(columnDefinition = "integer default 0")
    private int stock_quantity;

    @CreationTimestamp
    private Instant invoice_date;
}
