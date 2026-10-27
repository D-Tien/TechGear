<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hàng hóa | TechGear</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/product.css">
</head>
<body>
<main class="container py-4">
    <h1 class="mb-4">Hàng hóa</h1>
    <div class="card" style="max-width: 400px;">
        <img src="${pageContext.request.contextPath}/assets/images/razerhuntsmanv3pro.jpg"
             class="card-img-top" alt="Razer Huntsman V3 Pro">
        <div class="card-body">
            <h2 class="card-title h5">Razer Huntsman V3 Pro</h2>
            <p class="card-text">5.990.000 đ</p>
            <form action="${pageContext.request.contextPath}/cart/add" method="post">
                <input type="hidden" name="productId" value="-1">
                <button class="btn btn-primary" type="submit">Thêm vào giỏ</button>
            </form>
        </div>
    </div>
    <a class="btn btn-outline-secondary mt-3" href="${pageContext.request.contextPath}/cart">Xem giỏ hàng</a>
</main>
</body>
</html>
