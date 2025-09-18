package com.example.backend_e_commerce.entity;

import java.time.Instant;
import java.util.ArrayList;
import java.util.List;

import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class Customer {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY) // Auto inc
    private Integer id;

    @Column(nullable = false, length = 150)
    private String username;

    @Column(length = 150, unique = true)
    private String email;

    @Column(length = 20)
    private String phone;

    @Column(length = 150)
    private String address;

    @UpdateTimestamp
    private Instant updatedAt;

    @CreationTimestamp
    private Instant createdInstant;

    // invoice relation 
    @OneToMany(mappedBy = "customer" , cascade = CascadeType.ALL)
    private List<Invoice> invoices = new ArrayList<>();

}
