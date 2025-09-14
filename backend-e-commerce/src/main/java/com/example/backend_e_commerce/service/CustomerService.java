package com.example.backend_e_commerce.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import com.example.backend_e_commerce.entity.Customer;
import com.example.backend_e_commerce.exceptions.BusinessRuleException;
import com.example.backend_e_commerce.exceptions.ResourceNotFoundException;
import com.example.backend_e_commerce.repository.CustomerRepository;

import jakarta.transaction.Transactional;

import java.util.List;

@Service
public class CustomerService {

    @Autowired
    private CustomerRepository repo;

    // Get all customers
    public Page<Customer> getAllCustomers(Pageable pageable) {
        // add sorting +paging
        return repo.findAll(pageable);
    }

    // search for customer by username
    public List<Customer> searchCustomer(String username , Pageable pageable) {
        // add paging and sorting
        return repo.findByUsernameContainingIgnoreCase(username , pageable);
    }

    // Create customer
    @Transactional
    public Customer addCustomer(Customer customer) {
        if (customer.getUsername() == null || customer.getUsername().isBlank()) {
            throw new BusinessRuleException("Customer username is required");
        }

        if (customer.getEmail() == null || customer.getEmail().isBlank()) {
            throw new BusinessRuleException("Customer email is required");
        }

        if (repo.findByEmail(customer.getEmail()).isPresent()) {
            throw new BusinessRuleException("Email already exists: " + customer.getEmail());
        }

        return repo.save(customer);
    }

    // delete customer by id
    public void deleteCustomer(int id) {

        Customer cust = repo.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Customer with id " + id + " was not found"));

        repo.delete(cust);
    }

    @Transactional
    public Customer updateCustomer(int id, Customer customer) {
        // verify that a customer with the given ID exists
        Customer existingCustomer = repo.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Customer with id " + id + " was not found"));

        // validate username and email
        if (customer.getUsername() == null || customer.getUsername().isBlank()) {
            throw new BusinessRuleException("Customer username is required");
        }

        if (customer.getEmail() == null || customer.getEmail().isBlank()) {
            throw new BusinessRuleException("Customer email is required");
        }

        // verify that the email is not already used by another customer
        repo.findByEmail(customer.getEmail())
                .filter(c -> c.getId() != id)
                .ifPresent(c -> {
                    throw new BusinessRuleException("Email already exists: " + customer.getEmail());
                });

        // update all fields
        existingCustomer.setEmail(customer.getEmail());
        existingCustomer.setAddress(customer.getAddress());
        existingCustomer.setPhone(customer.getPhone());
        existingCustomer.setUsername(customer.getUsername());

        // then save
        return repo.save(existingCustomer);
    }

}
