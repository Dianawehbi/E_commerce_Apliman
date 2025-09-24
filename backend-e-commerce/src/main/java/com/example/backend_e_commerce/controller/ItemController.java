package com.example.backend_e_commerce.controller;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.backend_e_commerce.dto.ItemRequestDTO;
import com.example.backend_e_commerce.dto.ItemResponseDTO;
import com.example.backend_e_commerce.service.ItemService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;

@RestController
@RequestMapping("/items")
@CrossOrigin(origins = "*")
public class ItemController {

    @Autowired
    private ItemService itemService;

    // create item
    @PostMapping()
    public ItemResponseDTO createItem(@RequestBody ItemRequestDTO itemDTO) {
        return itemService.creaItem(itemDTO);
    }

    // get all items
    @GetMapping
    public Page<ItemResponseDTO> getAllItems(Pageable pageable) {
        return itemService.getAllItems(pageable);
    }

    // get item by id
    @GetMapping("/{id}")
    public ItemResponseDTO getItemById(@PathVariable int id) {
        return itemService.getItemById(id);
    }

    // get item by item_name, /items/search?name=...
    @GetMapping("/search")
    public Page<ItemResponseDTO> getItemByItemName(@RequestParam String name, Pageable pageable) {
        return itemService.searchItems(name, pageable);
    }

    // update item
    @PutMapping("/{id}")
    public ItemResponseDTO updateItem(@PathVariable int id, @RequestBody ItemRequestDTO itemDTO) {
        return itemService.updateItem(id, itemDTO);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<String> deleteItem(@PathVariable int id) {
        itemService.deleteItem(id);
        return ResponseEntity.ok("Item deleted successfully");
    }
}
