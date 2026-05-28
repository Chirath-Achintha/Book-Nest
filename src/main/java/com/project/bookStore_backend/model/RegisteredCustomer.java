package com.project.bookStore_backend.model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "registered_customer")
@Getter
@Setter
public class RegisteredCustomer {

    @Id
    @Column(name = "cid")
    private Long cid; // primary key and foreign key to customer.cid

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "cid", insertable = false, updatable = false)
    private Customer customer;

    @Column(nullable = false, unique = true, length = 50)
    private String username;

    @Column(nullable = false)
    private String password;

    @Column(unique = true, length = 100)
    private String email;

    private String phone;
    private String address;

    @Column(nullable = false)
    private String role = "CUSTOMER"; // Default role
}
