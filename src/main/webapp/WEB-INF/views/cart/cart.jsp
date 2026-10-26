<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Giỏ hàng | TechGear</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
</head>
<body>
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
                <c:if test="${quantity > 0}">
                    <tr>
                        <td>
                            <img src="${pageContext.request.contextPath}/assets/images/razerhuntsmanv3pro.jpg"
                                 alt="Razer Huntsman V3 Pro" width="120" class="me-2">
                            Razer Huntsman V3 Pro
                        </td>
                        <td>5.990.000 đ</td>
                        <td>
                            <div class="d-flex align-items-center gap-2">
                                <c:if test="${quantity > 1}">
                                    <form action="${pageContext.request.contextPath}/cart" method="post">
                                        <input type="hidden" name="action" value="decrease">
                                        <button class="btn btn-outline-primary" type="submit">−</button>
                                    </form>
                                </c:if>
                                <c:if test="${quantity == 1}">
                                    <button class="btn btn-outline-secondary" type="button" disabled>−</button>
                                </c:if>
                                <span>${quantity}</span>
                                <c:if test="${quantity < 99}">
                                    <form action="${pageContext.request.contextPath}/cart" method="post">
                                        <input type="hidden" name="action" value="increase">
                                        <button class="btn btn-outline-primary" type="submit">+</button>
                                    </form>
                                </c:if>
                                <c:if test="${quantity == 99}">
                                    <button class="btn btn-outline-secondary" type="button" disabled>+</button>
                                </c:if>
                            </div>
                        </td>
                        <td>${totalText}</td>
                        <td>
                            <form action="${pageContext.request.contextPath}/cart" method="post">
                                <input type="hidden" name="action" value="remove">
                                <button class="btn btn-outline-danger" type="submit">Xóa</button>
                            </form>
                        </td>
                    </tr>
                </c:if>
                <c:if test="${quantity == 0}">
                    <tr>
                        <td colspan="5" class="text-center">Chưa có sản phẩm trong giỏ.</td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>

    <p class="text-end fs-5"><strong>Tổng tiền: ${totalText}</strong></p>
    <div class="d-flex justify-content-between">
        <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/products">Tiếp tục mua sắm</a>
        <c:if test="${quantity > 0}">
            <form action="${pageContext.request.contextPath}/checkout" method="post">
                <button class="btn btn-success" type="submit">Thanh toán</button>
            </form>
        </c:if>
        <c:if test="${quantity == 0}">
            <button class="btn btn-secondary" type="button" disabled>Thanh toán</button>
        </c:if>
    </div>
</main>
</body>
</html>


