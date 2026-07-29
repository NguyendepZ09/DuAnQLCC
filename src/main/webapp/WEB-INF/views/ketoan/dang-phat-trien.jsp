<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chức Năng Đang Phát Triển — Kế Toán</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        body { background-color: #F4EFE4; font-family: 'Be Vietnam Pro', sans-serif; }
        .container-box { max-width: 600px; margin: 80px auto; background: #FFF; border-radius: 12px; padding: 48px; border: 1px solid #EAE3D2; box-shadow: 0 4px 12px rgba(0,0,0,0.04); text-align: center; }
    </style>
</head>
<body>

<div class="container-box">
    <div class="display-1 mb-3">💵</div>
    <h3 class="fw-bold text-dark mb-2">Phân Hệ Kế Toán Đang Phát Triển</h3>
    <p class="text-muted mb-4">
        Các tính năng quản lý thu phí, hóa đơn dịch vụ dành cho Bộ Phận Kế Toán sẽ ra mắt trong phiên bản tới.
    </p>
    <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-danger px-4 fw-bold">
        🚪 Đăng Xuất Hệ Thống
    </a>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
