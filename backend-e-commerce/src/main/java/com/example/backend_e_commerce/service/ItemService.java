package com.example.backend_e_commerce.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import com.example.backend_e_commerce.dto.ItemRequestDTO;
import com.example.backend_e_commerce.dto.ItemResponseDTO;
import com.example.backend_e_commerce.entity.Item;
import com.example.backend_e_commerce.exceptions.BusinessRuleException;
import com.example.backend_e_commerce.exceptions.ResourceNotFoundException;
import com.example.backend_e_commerce.mapper.ItemMapper;
import com.example.backend_e_commerce.repository.CategoryRepository;
import com.example.backend_e_commerce.repository.ItemRepository;

import jakarta.transaction.Transactional;

@Service
public class ItemService {
    @Autowired
    private ItemRepository repo;

    @Autowired
    private ItemMapper mapper;

    @Autowired
    private CategoryRepository categoryRepository;

    // create item
    public ItemResponseDTO creaItem(ItemRequestDTO itemDTO) {
        if (itemDTO.getItemName() == null || itemDTO.getItemName().isBlank()) {
            throw new BusinessRuleException("Item's name is required");
        }

        if (itemDTO.getPrice() == 0) {
            throw new BusinessRuleException("Item's price is required");
        }
        Item item = mapper.toEntity(itemDTO, categoryRepository);
        return mapper.toDto(repo.save(item));
    }

    // get all items
    public Page<ItemResponseDTO> getAllItems(Pageable pageable) {
        Page<Item> items = repo.findAll(pageable);
        return items.map(mapper::toDto);
    }

    // get item by id
    public ItemResponseDTO getItemById(int id) {
        Item item = repo.findById(id).orElseThrow(() -> new ResourceNotFoundException("No Item with id " + id));
        return mapper.toDto(item);
    }

    // search item by item_name
    public Page<ItemResponseDTO> searchItems(String item_name, Pageable pageable) {
        Page<Item> items = repo.findByItemNameContainingIgnoreCase(item_name, pageable);
        return items.map(mapper::toDto);
    }

    // update item
    @Transactional
    public ItemResponseDTO updateItem(int id, ItemRequestDTO itemDTO) {
        Item item = mapper.toEntity(itemDTO, categoryRepository);

        // verify that a item with the given ID exists
        Item existingItem = repo.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Item with id " + id + " was not found"));

        // validate name and price
        if (itemDTO.getItemName() == null || itemDTO.getItemName().isBlank()) {
            throw new BusinessRuleException("Item name is required");
        }

        if (itemDTO.getPrice() == 0) {
            throw new BusinessRuleException("Item price is required");
        }

        // update all fields
        existingItem.setItemName(item.getItemName());
        existingItem.setDescription(item.getDescription());
        existingItem.setImage_path(item.getImage_path());
        existingItem.setPrice(item.getPrice());
        existingItem.setStockQuantity(item.getStockQuantity());
        existingItem.setCategory(item.getCategory());

        return mapper.toDto(repo.save(existingItem));
    }

    // delete item
    public void deleteItem(int id) {

        Item item = repo.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Item with id " + id + " was not found"));

        repo.delete(item);
    }

}
