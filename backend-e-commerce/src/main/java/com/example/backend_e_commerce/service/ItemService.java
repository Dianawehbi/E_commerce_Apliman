package com.example.backend_e_commerce.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import com.example.backend_e_commerce.entity.Item;
import com.example.backend_e_commerce.exceptions.BusinessRuleException;
import com.example.backend_e_commerce.exceptions.ResourceNotFoundException;
import com.example.backend_e_commerce.repository.ItemRepository;

import jakarta.transaction.Transactional;

@Service
public class ItemService {
    @Autowired
    private ItemRepository repo;

    // create item
    public Item creaItem(Item item) {
        if (item.getItemName() == null || item.getItemName().isBlank()) {
            throw new BusinessRuleException("Item name is required");
        }

        if (item.getPrice() == 0) {
            throw new BusinessRuleException("Item price is required");
        }
        // System.out.println(item.getCategory().getName());

        return repo.save(item);
    }

    // get all items
    public Page<Item> getAllItems(Pageable pageable) {
        return repo.findAll(pageable);
    }

    // search item by item_name
    public Page<Item> searchItems(String item_name, Pageable pageable) {
        return repo.findByItemNameContainingIgnoreCase(item_name , pageable);
    }

    // update item
    @Transactional
    public Item updateItem(int id, Item item) {
        // verify that a item with the given ID exists
        Item existingItem = repo.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Item with id " + id + " was not found"));

        // validate username and email
        if (item.getItemName() == null || item.getItemName().isBlank()) {
            throw new BusinessRuleException("Item name is required");
        }

        if (item.getPrice() == 0) {
            throw new BusinessRuleException("Item price is required");
        }

        // update all fields
        existingItem.setItemName(item.getItemName());
        existingItem.setDescription(item.getDescription());
        existingItem.setImage_path(item.getImage_path());
        existingItem.setPrice(item.getPrice());
        existingItem.setStock_quantity(item.getStock_quantity());
        existingItem.setCategory(item.getCategory());

        // then save
        return repo.save(existingItem);
    }

    // delete item
    public void deleteItem(int id) {

        Item item = repo.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Item with id " + id + " was not found"));

        repo.delete(item);
    }

}
