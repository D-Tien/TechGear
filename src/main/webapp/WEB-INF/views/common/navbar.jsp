<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<nav class="customer-nav" aria-label="Điều hướng chính">
    <a href="<c:url value='/home'/>" class="${empty activeNav or activeNav eq 'home' ? 'active' : ''}">Trang chủ</a>
    <a href="<c:url value='/products'/>" class="${activeNav eq 'products' ? 'active' : ''}">Sản phẩm</a>
    <a href="<c:url value='/home#categories'/>" class="${activeNav eq 'categories' ? 'active' : ''}">Danh mục</a>
    <a href="<c:url value='/home#deals'/>" class="${activeNav eq 'deals' ? 'active' : ''}">Ưu đãi</a>
    <a href="<c:url value='/profile'/>">Hỗ trợ</a>
</nav>
