package com.example.backend_e_commerce.entity;

import java.sql.Date;
import java.time.Instant;

import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

// 
// MODEL 
//  
@Entity
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class Customer {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY) // Auto inc
    private int id;

    @Column(nullable = false, length = 150)
    private String username;

    @Column(length = 150, unique = true)
    private String email;

    @Column(length = 20)
    private String phone;

    @Column(length = 150)
    private String address;

    @UpdateTimestamp
    private Instant updated_at;

    @CreationTimestamp
    private Instant created_at;

}
