package com.wenting.backendroadmap.controller;

import com.wenting.backendroadmap.entity.Product;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.http.ResponseEntity;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.DeleteMapping;

import java.util.List;

@RestController
public class ProductController {

    private final JdbcTemplate jdbcTemplate;  //声明需要一个操作数据库的工具

    public ProductController(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }  //让spring把这个工具注入进来（构造器注入）

    @GetMapping("/products")//get这个路径就执行以下方法
    public List<Product> list() {
        return jdbcTemplate.query(
                "SELECT * FROM products",
                new BeanPropertyRowMapper<>(Product.class));
    }

    @PostMapping("/products")
    public String create(@RequestBody Product product) {
        jdbcTemplate.update(
                "INSERT INTO products (seller_id, title, description, price) VALUES (?, ?, ?, ?)",
                product.getSellerId(),
                product.getTitle(),
                product.getDescription(),
                product.getPrice());
        return "新增成功";
    }
    @GetMapping("/products/{id}")
    public ResponseEntity<Product> detail(@PathVariable Long id) {
        try {
            Product product = jdbcTemplate.queryForObject(
                    "SELECT * FROM products WHERE id = ?",
                    new BeanPropertyRowMapper<>(Product.class),
                    id);
            return ResponseEntity.ok(product);          // 200 + 数据
        } catch (EmptyResultDataAccessException e) {
            return ResponseEntity.notFound().build();   // 404 + 空body
        }
    }
    @PutMapping("/products/{id}")
    public ResponseEntity<String> update(@PathVariable Long id, @RequestBody Product product) {
        int rows = jdbcTemplate.update(
                "UPDATE products SET title = ?, description = ?, price = ?, status = ? WHERE id = ?",
                product.getTitle(), product.getDescription(), product.getPrice(),
                product.getStatus(), id);

        if (rows == 0) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok("更新成功");
    }

    @DeleteMapping("/products/{id}")
    public ResponseEntity<String> delete(@PathVariable Long id) {
        int rows = jdbcTemplate.update("DELETE FROM products WHERE id = ?", id);

        if (rows == 0) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok("删除成功");
    }
}