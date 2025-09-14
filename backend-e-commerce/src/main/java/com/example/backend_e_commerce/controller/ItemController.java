package com.example.backend_e_commerce.controller;

// import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.backend_e_commerce.entity.Item;
// import com.example.backend_e_commerce.service.ItemService;
import com.example.backend_e_commerce.service.ItemService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;

@RestController
@RequestMapping("/items")
public class ItemController {

    @Autowired
    private ItemService itemService;

    // create item
    @PostMapping()
    public Item createItem(@RequestBody Item item) {
        return itemService.creaItem(item);
    }

    // get all items
    @GetMapping
    public Page<Item> getAllItems(Pageable pageable) {
        return itemService.getAllItems(pageable);
    }

    // get item by item_name, /items/search?item_name=...
    @GetMapping("/search")
    public Page<Item> getItemByItemName(@RequestParam String item_name , Pageable pageable) {
        return itemService.searchItems(item_name, pageable);
    }

    // update item
    @PutMapping("/{id}")
    public Item updateItem(@PathVariable int id, @RequestBody Item item) {
        return itemService.updateItem(id, item);
    }

    // delete item
    @DeleteMapping("/{id}")
    public void deleteItem(@PathVariable int id) {
        itemService.deleteItem(id);;
    }

}
