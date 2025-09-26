package com.example.backend_e_commerce.service;

import java.time.Instant;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import com.example.backend_e_commerce.dto.InvoiceItemsRequestDTO;
import com.example.backend_e_commerce.dto.InvoiceRequestDTO;
import com.example.backend_e_commerce.dto.InvoiceResponseDTO;
import com.example.backend_e_commerce.entity.Customer;
import com.example.backend_e_commerce.entity.Invoice;
import com.example.backend_e_commerce.entity.InvoiceItems;
import com.example.backend_e_commerce.entity.Item;
import com.example.backend_e_commerce.exceptions.BusinessRuleException;
import com.example.backend_e_commerce.exceptions.InvalidRequestException;
import com.example.backend_e_commerce.exceptions.ResourceNotFoundException;
import com.example.backend_e_commerce.mapper.InvoiceItemMapper;
import com.example.backend_e_commerce.mapper.InvoiceMapper;
import com.example.backend_e_commerce.repository.CustomerRepository;
import com.example.backend_e_commerce.repository.InvoiceItemRepository;
import com.example.backend_e_commerce.repository.InvoiceRepository;
import com.example.backend_e_commerce.repository.ItemRepository;

import jakarta.transaction.Transactional;

@Service
public class InvoiceService {

    private final InvoiceItemRepository invoiceItemRepository;

    @Autowired
    private InvoiceRepository repo;

    @Autowired
    private InvoiceMapper mapper;

    @Autowired
    private InvoiceItemMapper invoiceItemMapper;

    @Autowired
    private CustomerRepository customerRepository;

    @Autowired
    private ItemRepository itemRepository;

    InvoiceService(InvoiceItemRepository invoiceItemRepository) {
        this.invoiceItemRepository = invoiceItemRepository;
    }

    // get all invoices
    public Page<InvoiceResponseDTO> getAllInvoices(Pageable pageable) {
        Page<Invoice> invoices = repo.findAll(pageable);
        return invoices.map(mapper::toDto);
    }

    // get invoice by id
    public InvoiceResponseDTO getInvoiceById(int id) {
        Invoice invoice = repo.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("There is not a Invoice with Id :" + id));
        return mapper.toDto(invoice);
    }

    // get invoice by customer id
    public Page<InvoiceResponseDTO> getInvoiceByCustomerId(int id, Pageable pageable) {
        Page<Invoice> invoices = repo.findByCustomerId(id, pageable);
        return invoices.map(mapper::toDto);
    }

    // get invoice by customer name
    public Page<InvoiceResponseDTO> getInvoiceByCustomerName(String username, Pageable pageable) {
        Page<Invoice> invoices = repo.findByCustomerUsername(username, pageable);
        return invoices.map(mapper::toDto);
    }

    // delete invoice by id
    public void deleteInvoice(int id) {

        Invoice invoice = repo.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Invoice with id " + id + " was not found"));

        repo.delete(invoice);
    }

    // create new invoice
    @Transactional
    public InvoiceResponseDTO createInvoice(InvoiceRequestDTO invoiceRequestDTO) {
        Customer customer = fetchCustomer(invoiceRequestDTO.getCustomerId());
        List<InvoiceItems> invoiceItems = new ArrayList<>();
        double totalAmount = 0.0;

        for (InvoiceItemsRequestDTO itemDTO : invoiceRequestDTO.getInvoiceitems()) {
            Item item = fetchItem(itemDTO.getItemId());
            validateQuantity(itemDTO.getQuantity());

            // reduce stock and map invoice item
            adjustStock(item, itemDTO.getQuantity());
            InvoiceItems invoiceItem = mapInvoiceItem(itemDTO, item, null);
            invoiceItems.add(invoiceItem);

            totalAmount += item.getPrice() * itemDTO.getQuantity();
        }

        Invoice invoice = new Invoice();
        invoice.setCustomer(customer);
        invoice.setInvoiceDate(Instant.now());
        invoice.setTotalAmount(totalAmount);
        invoice.setInvoiceItems(invoiceItems);

        // link back
        invoiceItems.forEach(ii -> ii.setInvoice(invoice));

        Invoice savedInvoice = repo.save(invoice);
        return mapper.toDto(savedInvoice);
    }

    @Transactional
    public InvoiceResponseDTO updateInvoice(int id, InvoiceRequestDTO invoiceRequestDTO) {
        Invoice existingInvoice = fetchInvoice(id);

        System.out.println(invoiceRequestDTO);
        Customer customer = fetchCustomer(invoiceRequestDTO.getCustomerId());
        List<InvoiceItems> updatedInvoiceItems = new ArrayList<>();
        double totalAmount = 0.0;

        for (InvoiceItemsRequestDTO itemDTO : invoiceRequestDTO.getInvoiceitems()) {
            Item item = fetchItem(itemDTO.getItemId());
            validateQuantity(itemDTO.getQuantity());

            // check if item already exists in the invoice
            Optional<InvoiceItems> existingItemOpt = existingInvoice.getInvoiceItems().stream()
                    .filter(ii -> ii.getItem().getId() == itemDTO.getItemId())
                    .findFirst();

            if (existingItemOpt.isPresent()) {
                InvoiceItems invoiceItem = existingItemOpt.get();
                updateExistingInvoiceItem(invoiceItem, item, itemDTO.getQuantity());
                updatedInvoiceItems.add(invoiceItem);
            } else {
                InvoiceItems invoiceItem = addNewInvoiceItem(existingInvoice, item, itemDTO);
                updatedInvoiceItems.add(invoiceItem);
            }

            totalAmount += item.getPrice() * itemDTO.getQuantity();
        }

        // remove items that are no longer in the updated request
        List<InvoiceItems> itemsToRemove = existingInvoice.getInvoiceItems().stream()
                .filter(ii -> updatedInvoiceItems.stream()
                        .noneMatch(updated -> updated.getItem().getId() == ii.getItem().getId()))
                .toList();

        for (InvoiceItems itemToRemove : itemsToRemove) {
            invoiceItemRepository.delete(itemToRemove); // delete from DB
            existingInvoice.getInvoiceItems().remove(itemToRemove); // remove from memory
        }

        // update invoice
        existingInvoice.setCustomer(customer);
        existingInvoice.setTotalAmount(totalAmount);
        existingInvoice.setInvoiceItems(updatedInvoiceItems);

        Invoice savedInvoice = repo.save(existingInvoice);
        return mapper.toDto(savedInvoice);
    }

    // ========================= Helper Methods ========================= //

    private Customer fetchCustomer(int customerId) {
        return customerRepository.findById(customerId)
                .orElseThrow(() -> new ResourceNotFoundException("Customer not found with id: " + customerId));
    }

    private Invoice fetchInvoice(int invoiceId) {
        return repo.findById(invoiceId)
                .orElseThrow(() -> new ResourceNotFoundException("Invoice with id " + invoiceId + " was not found"));
    }

    private Item fetchItem(int itemId) {
        return itemRepository.findById(itemId)
                .orElseThrow(() -> new ResourceNotFoundException("Item not found with id: " + itemId));
    }

    private void validateQuantity(Integer quantity) {
        if (quantity == null || quantity < 1) {
            throw new InvalidRequestException("Quantity must not be null or less than 1");
        }
    }

    private void adjustStock(Item item, int quantity) {
        if (quantity > item.getStockQuantity()) {
            throw new BusinessRuleException("Requested quantity (" + quantity
                    + ") exceeds available stock for item: " + item.getItemName()
                    + " (Available: " + item.getStockQuantity() + ")");
        }
        item.setStockQuantity(item.getStockQuantity() - quantity);
        itemRepository.save(item);
    }

    private InvoiceItems mapInvoiceItem(InvoiceItemsRequestDTO itemDTO, Item item, Invoice invoice) {
        InvoiceItems invoiceItem = invoiceItemMapper.toEntity(itemDTO, itemRepository);
        invoiceItem.setItem(item);
        invoiceItem.setInvoice(invoice);
        invoiceItem.setUnitPrice(item.getPrice());
        return invoiceItem;
    }

    private void updateExistingInvoiceItem(InvoiceItems invoiceItem, Item item, int newQuantity) {
        int quantityChange = newQuantity - invoiceItem.getQuantity();

        if (quantityChange > 0) {
            adjustStock(item, quantityChange);
        } else if (quantityChange < 0) {
            item.setStockQuantity(item.getStockQuantity() + Math.abs(quantityChange));
            itemRepository.save(item);
        }

        invoiceItem.setQuantity(newQuantity);
        invoiceItem.setUnitPrice(item.getPrice());
    }

    private InvoiceItems addNewInvoiceItem(Invoice invoice, Item item, InvoiceItemsRequestDTO itemDTO) {
        adjustStock(item, itemDTO.getQuantity());
        return mapInvoiceItem(itemDTO, item, invoice);
    }
}
