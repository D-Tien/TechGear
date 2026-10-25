package com.techgear.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/** Shared model contract; coordinate field changes with the whole team. */
public class Order {
    private int orderId;
    private int userId;
    private String recipientName;
    private String shippingAddress;
    private String phone;
    private BigDecimal totalAmount;
    private String status;
    private String paymentMethod;
    private LocalDateTime createdAt;

    public Order() { }

    public Order(int orderId, int userId, String recipientName, String shippingAddress, String phone, BigDecimal totalAmount, String status, String paymentMethod, LocalDateTime createdAt) {
        this.orderId = orderId;
        this.userId = userId;
        this.recipientName = recipientName;
        this.shippingAddress = shippingAddress;
        this.phone = phone;
        this.totalAmount = totalAmount;
        this.status = status;
        this.paymentMethod = paymentMethod;
        this.createdAt = createdAt;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getRecipientName() {
        return recipientName;
    }

    public void setRecipientName(String recipientName) {
        this.recipientName = recipientName;
    }

    public String getShippingAddress() {
        return shippingAddress;
    }

    public void setShippingAddress(String shippingAddress) {
        this.shippingAddress = shippingAddress;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}
