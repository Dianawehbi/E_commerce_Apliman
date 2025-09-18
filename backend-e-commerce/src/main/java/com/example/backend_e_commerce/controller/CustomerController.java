package com.example.backend_e_commerce.controller;

import org.springframework.web.bind.annotation.RestController;

import com.example.backend_e_commerce.dto.CustomerRequestDTO;
import com.example.backend_e_commerce.dto.CustomerResponseDTO;
import com.example.backend_e_commerce.service.CustomerService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestParam;

@RestController
@RequestMapping("/customers")
public class CustomerController {

    @Autowired
    private CustomerService customerService;

    // create customer
    @PostMapping
    public CustomerResponseDTO createCustomer(@RequestBody CustomerRequestDTO customerRequestDTO) {
        return customerService.addCustomer(customerRequestDTO);
    }

    // fetch all customers
    @GetMapping
    public Page<CustomerResponseDTO> getAllCustomers(Pageable pageable) {
        return customerService.getAllCustomers(pageable);
    }

    @GetMapping("/{id}")
    public CustomerResponseDTO getCustomerById(@PathVariable int id) {
        return customerService.getCustomerById(id);
    }

    // fetch customers with similar name, search?name=name
    @GetMapping("/search")
    public Page<CustomerResponseDTO> findCustomersByName(@RequestParam String name, Pageable pageable) {
        return customerService.searchCustomer(name, pageable);
    }

    // update customer
    @PutMapping("/{id}")
    public CustomerResponseDTO updateCustomer(@PathVariable int id, @RequestBody CustomerRequestDTO customerRequestDTO) {
        return customerService.updateCustomer(id, customerRequestDTO);
    }

    // delete customer
    @DeleteMapping("/{id}")
    public String deleteCustomer(@PathVariable int id) {
        customerService.deleteCustomer(id);
        return "Customer Deleted succesfuly";
    }
}
