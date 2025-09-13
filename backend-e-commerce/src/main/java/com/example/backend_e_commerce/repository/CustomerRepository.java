package com.example.backend_e_commerce.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.example.backend_e_commerce.entity.Customer;

@Repository
public interface CustomerRepository extends JpaRepository<Customer, Integer> {

    // exactly the same name
    List<Customer> findByUsername(String username);

    // use customize query (Like) 
    @Query("select c from Customer c where c.username like %?1%")
    List<Customer> SearchUsername(String username);

    List<Customer> findByUsernameContainingIgnoreCase(String username); 
}
