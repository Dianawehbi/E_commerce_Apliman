package com.example.backend_e_commerce.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.backend_e_commerce.dto.CategoryRequestDTO;
import com.example.backend_e_commerce.dto.CategoryResponseDTO;
import com.example.backend_e_commerce.entity.Category;
import com.example.backend_e_commerce.exceptions.ResourceNotFoundException;
import com.example.backend_e_commerce.mapper.CategoryMapper;
import com.example.backend_e_commerce.repository.CategoryRepository;

@Service
public class CategoryService {

    @Autowired
    private CategoryRepository repo;

    @Autowired
    private CategoryMapper mapper;

    // get all category
    public List<CategoryResponseDTO> getAllCategories() {
        List<Category> categories = repo.findAll(); // map for stream and Page not for List
        return categories.stream().map(mapper::toDto).toList();
    }

    // get category by id
    public CategoryResponseDTO getCategoryById(int id) {
        return mapper.toDto(repo.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Category with id " + id + " was not found")));
    }

    // create category
    public CategoryResponseDTO createCategory(CategoryRequestDTO categoryreRequestDTO) {
        Category category = mapper.toEntity(categoryreRequestDTO);
        return mapper.toDto(repo.save(category));
    }
}
