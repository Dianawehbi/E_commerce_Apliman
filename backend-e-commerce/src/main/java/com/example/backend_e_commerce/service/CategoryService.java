package com.example.backend_e_commerce.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.backend_e_commerce.entity.Category;
import com.example.backend_e_commerce.exceptions.ResourceNotFoundException;
import com.example.backend_e_commerce.repository.CategoryRepository;

@Service
public class CategoryService {

    @Autowired
    private CategoryRepository repo;

    // get all category
    public List<Category> getAllCategories() {
        return repo.findAll();
    }

    // get category by id
    public Category getCategoryById(int id) {
        return repo.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Category with id " + id + " was not found"));
    }

    // create category
    public Category createCategory(Category category) {
        return repo.save(category);
    }
}
