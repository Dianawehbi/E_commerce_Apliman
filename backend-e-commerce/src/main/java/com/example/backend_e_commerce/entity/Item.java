package com.example.backend_e_commerce.entity;

import java.time.Instant;
import java.util.ArrayList;
import java.util.List;

import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

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
import lombok.ToString;

@Entity
@Getter @Setter @NoArgsConstructor @AllArgsConstructor
@ToString(exclude = "invoiceItems") // avoid infinite recursion
public class Item {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(length = 150, nullable = false)
    private String itemName;

    @Column(columnDefinition = "TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci")
    private String description;

    @Column(length = 200)
    private String image_path;

    @Column(columnDefinition = "Decimal(10,2)", nullable = false)
    private double price;

    @Column(columnDefinition = "integer default 0")
    private int stock_quantity;

    @UpdateTimestamp
    private Instant updated_at;

    @CreationTimestamp
    private Instant created_at;

    // category relationship
    @ManyToOne
    @JoinColumn(name = "category_id")
    @JsonIgnore // to stop infinite recursion
    private Category category;

    // invoice_items relation
    @OneToMany(mappedBy = "item" , cascade = CascadeType.ALL)
    private List<InvoiceItems> invoiceItems = new ArrayList<>();
}
