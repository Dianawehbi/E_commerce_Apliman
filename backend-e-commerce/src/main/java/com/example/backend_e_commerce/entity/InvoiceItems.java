package com.example.backend_e_commerce.entity;

import java.time.Instant;

import org.hibernate.annotations.CreationTimestamp;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.ManyToOne;

@Entity
public class InvoiceItems {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column()
    @ManyToOne()
    private int invoice_id;

    @Column()
    @ManyToOne()
    private int item_id;

    @Column(columnDefinition = "Decimal(10,2)" , nullable = false)
    private double unit_price;

    @Column(nullable = false)
    private int quantity;

}
