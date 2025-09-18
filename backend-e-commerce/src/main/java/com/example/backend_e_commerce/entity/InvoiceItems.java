package com.example.backend_e_commerce.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Getter @Setter @AllArgsConstructor @NoArgsConstructor
public class InvoiceItems {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    // invoice relation 
    @ManyToOne()
    @JsonIgnore
    @JoinColumn(name = "invoice_id", nullable = false)
    private Invoice invoice;

    // item relation
    @ManyToOne()
    @JsonIgnore
    @JoinColumn(name = "item_id", nullable = false)
    private Item item;

    @Column(columnDefinition = "Decimal(10,2)", nullable = false)
    private double unitPrice;

    @Column(nullable = false)
    private int quantity;

}