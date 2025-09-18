package com.example.backend_e_commerce.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

import com.example.backend_e_commerce.dto.CategoryRequestDTO;
import com.example.backend_e_commerce.dto.CategoryResponseDTO;
import com.example.backend_e_commerce.dto.ItemResponseDTO;
import com.example.backend_e_commerce.entity.Category;
import com.example.backend_e_commerce.entity.Item;

@Mapper(componentModel = "spring")
public interface CategoryMapper {

    Category toEntity(CategoryRequestDTO categoryDTO);

    CategoryResponseDTO toDto(Category category);

    // add this to manage Item response dto inside categories 
    @Mapping(target = "categoryId", expression = "java(item.getCategory() != null ? item.getCategory().getId() : null)")
    ItemResponseDTO itemToItemResponseDTO(Item item);
}
