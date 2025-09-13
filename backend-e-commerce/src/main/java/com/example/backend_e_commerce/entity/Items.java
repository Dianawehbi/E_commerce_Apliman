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
public class Items {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(length = 150, nullable = false)
    private String item_name;

    @Column(columnDefinition = "TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci")
    private String description;

    @Column(length = 200)
    private String image_path;

    @Column(columnDefinition="Decimal(10,2)" , nullable = false)
    private double price;

    @Column(columnDefinition="integer default 0")
    private int stock_quantity;

    // we have relation to category tables
    @Column()
    @ManyToOne
    private int category_id;

    @UpdateTimestamp
    private Instant updated_at;

    @CreationTimestamp
    private Instant created_at;
}
