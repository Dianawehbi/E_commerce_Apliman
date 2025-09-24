package com.example.backend_e_commerce.controller;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.backend_e_commerce.dto.CategoryRequestDTO;
import com.example.backend_e_commerce.dto.CategoryResponseDTO;
import com.example.backend_e_commerce.service.CategoryService;

@RestController
@RequestMapping("/categories")
@CrossOrigin(origins = "*")
public class CategoryController {

    @Autowired
    private CategoryService categoryService;

    // add new category
    @PostMapping
    public CategoryResponseDTO createCategory(@RequestBody CategoryRequestDTO categoryDTO) {
        return categoryService.createCategory(categoryDTO);
    }

    // get all categories
    @GetMapping
    public List<CategoryResponseDTO> getAllCategories() {
        return categoryService.getAllCategories();
    }

    // get category by id
    @GetMapping("/{id}")
    public CategoryResponseDTO getCategoryById(@PathVariable int id) {
        return categoryService.getCategoryById(id);
    }
}
