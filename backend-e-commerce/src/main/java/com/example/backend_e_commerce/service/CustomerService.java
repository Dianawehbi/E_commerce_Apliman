package com.example.backend_e_commerce.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import com.example.backend_e_commerce.dto.CustomerRequestDTO;
import com.example.backend_e_commerce.dto.CustomerResponseDTO;
import com.example.backend_e_commerce.entity.Customer;
import com.example.backend_e_commerce.exceptions.BusinessRuleException;
import com.example.backend_e_commerce.exceptions.ResourceNotFoundException;
import com.example.backend_e_commerce.mapper.CustomerMapper;
import com.example.backend_e_commerce.repository.CustomerRepository;

import jakarta.transaction.Transactional;

@Service
public class CustomerService {

    @Autowired
    private CustomerRepository repo;

    @Autowired
    private CustomerMapper mapper;

    // Get all customers
    public Page<CustomerResponseDTO> getAllCustomers(Pageable pageable) {
        // add sorting +paging
        Page<Customer> customers = repo.findAll(pageable);
        return customers.map(mapper::toDto);
    }

    // get customer by id
    public CustomerResponseDTO getCustomerById(int id) {
        Customer customer = repo.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Cannot Find Customer With Id: " + id));
        return mapper.toDto(customer);
    }

    // search for customer by username
    public Page<CustomerResponseDTO> searchCustomer(String username, Pageable pageable) {
        // add paging and sorting
        Page<Customer> customers = repo.findByUsernameContainingIgnoreCase(username, pageable);
        return customers.map(mapper::toDto);
    }

    // Create customer
    @Transactional
    public CustomerResponseDTO addCustomer(CustomerRequestDTO customerDTO) {
        Customer customer = mapper.toEntity(customerDTO);
        if (customer.getUsername() == null || customer.getUsername().isBlank()) {
            throw new BusinessRuleException("Customer username is required");
        }

        if (customer.getEmail() == null || customer.getEmail().isBlank()) {
            throw new BusinessRuleException("Customer email is required");
        }

        if (repo.findByEmail(customer.getEmail()).isPresent()) {
            throw new BusinessRuleException("Email already exists: " + customer.getEmail());
        }

        return mapper.toDto(repo.save(customer));
    }

    // delete customer by id
    public void deleteCustomer(int id) {

        Customer cust = repo.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Customer with id " + id + " was not found"));

        repo.delete(cust);
    }

    @Transactional
    public CustomerResponseDTO updateCustomer(int id, CustomerRequestDTO customerDTO) {
        Customer customer = mapper.toEntity(customerDTO);
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
        return mapper.toDto(repo.save(existingCustomer));
    }

}
