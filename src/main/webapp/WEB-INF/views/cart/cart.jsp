<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Giỏ hàng | TechGear</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/cart.css">
</head>
<body class="tg-cart-page">
<main class="container py-4">
    <h1 class="mb-4">Giỏ hàng</h1>

    <div class="table-responsive">
        <table class="table table-bordered align-middle">
            <thead class="table-light">
                <tr>
                    <th>Sản phẩm</th>
                    <th>Giá</th>
                    <th>Số lượng</th>
                    <th>Thành tiền</th>
                    <th>Thao tác</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="row" items="${rows}">
                    <tr>
                        <td>
                            <c:if test="${not empty row.imageUrl}">
                                <img src="<c:out value="${row.imageUrl}"/>"
                                     alt="<c:out value="${row.name}"/>" width="120" class="me-2">
                            </c:if>
                            <c:out value="${row.name}"/>
                        </td>
                        <td>${row.priceText}</td>
                        <td>
                            <div class="d-flex align-items-center gap-2">
                                <form action="${pageContext.request.contextPath}/cart" method="post">
                                    <input type="hidden" name="action" value="decrease">
                                    <input type="hidden" name="productId" value="${row.productId}">
                                    <button class="btn btn-outline-primary" type="submit"
                                            <c:if test="${row.quantity <= 1}">disabled</c:if>>−</button>
                                </form>
                                <span>${row.quantity}</span>
                                <form action="${pageContext.request.contextPath}/cart" method="post">
                                    <input type="hidden" name="action" value="increase">
                                    <input type="hidden" name="productId" value="${row.productId}">
                                    <button class="btn btn-outline-primary" type="submit"
                                            <c:if test="${row.quantity >= 99 || row.quantity >= row.stock}">disabled</c:if>>+</button>
                                </form>
                            </div>
                        </td>
                        <td>${row.lineTotalText}</td>
                        <td>
                            <form action="${pageContext.request.contextPath}/cart" method="post">
                                <input type="hidden" name="action" value="remove">
                                <input type="hidden" name="productId" value="${row.productId}">
                                <button class="btn btn-outline-danger" type="submit">Xóa</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty rows}">
                    <tr>
                        <td colspan="5" class="text-center">Chưa có sản phẩm trong giỏ.</td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>

    <c:if test="${empty rows}">
        <div class="d-flex align-items-center gap-3 my-3">
            <img src="${pageContext.request.contextPath}/assets/images/razerhuntsmanv3pro.jpg"
                 alt="Razer Huntsman V3 Pro" width="120">
            <div>
                <div>Razer Huntsman V3 Pro — 5.990.000 đ</div>
                <form action="${pageContext.request.contextPath}/cart/add" method="post" class="mt-2">
                    <input type="hidden" name="productId" value="-1">
                    <button class="btn btn-primary" type="submit">Thêm vào giỏ</button>
                </form>
            </div>
        </div>
    </c:if>

    <p class="text-end fs-5"><strong>Tổng tiền: ${totalText}</strong></p>
    <div class="d-flex justify-content-between">
        <div class="d-flex gap-2">
            <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/products">Tiếp tục mua sắm</a>
        </div>
        <c:if test="${not empty rows}">
            <a class="btn btn-success" href="${pageContext.request.contextPath}/checkout">Tiến hành đặt hàng</a>
        </c:if>
        <c:if test="${empty rows}">
            <button class="btn btn-secondary" type="button" disabled>Tiến hành đặt hàng</button>
        </c:if>
    </div>
</main>
</body>
</html>
