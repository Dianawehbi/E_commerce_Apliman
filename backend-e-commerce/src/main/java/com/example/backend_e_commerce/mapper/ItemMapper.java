package com.example.backend_e_commerce.mapper;

import org.mapstruct.Context;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

import com.example.backend_e_commerce.dto.ItemRequestDTO;
import com.example.backend_e_commerce.dto.ItemResponseDTO;
import com.example.backend_e_commerce.entity.Category;
import com.example.backend_e_commerce.entity.Item;
import com.example.backend_e_commerce.exceptions.ResourceNotFoundException;
import com.example.backend_e_commerce.repository.CategoryRepository;

@Mapper(componentModel = "spring")
public interface ItemMapper {

    @Mapping(target = "category", expression = "java(mapCategory(dto.getCategoryId(), categoryRepository))")
    Item toEntity(ItemRequestDTO dto, @Context CategoryRepository categoryRepository);

    @Mapping(target = "categoryId", expression = "java(item.getCategory() != null ? item.getCategory().getId() : null)")
    ItemResponseDTO toDto(Item item);

    default Category mapCategory(Integer categoryId, @Context CategoryRepository categoryRepository) {
        if (categoryId == null)
            return null;
        return categoryRepository.findById(categoryId)
                .orElseThrow(() -> new ResourceNotFoundException("Category not found with id: " + categoryId));
    }
}
