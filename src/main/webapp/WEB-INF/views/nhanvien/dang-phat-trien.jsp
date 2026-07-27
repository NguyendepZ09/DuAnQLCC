<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chức Năng Đang Phát Triển — Polybuilding</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #F4EFE4; font-family: 'Be Vietnam Pro', sans-serif; height: 100vh; display: flex; align-items: center; justify-content: center; }
        .card-dev { background: #FFF; border-radius: 16px; padding: 40px; text-align: center; max-width: 520px; box-shadow: 0 10px 30px rgba(0,0,0,0.06); border: 1px solid #DCE6E0; }
        .dev-icon { font-size: 3.5rem; margin-bottom: 16px; }
        .btn-logout { background: #1E3B34; color: #FFF; font-weight: 600; border-radius: 8px; padding: 10px 24px; text-decoration: none; display: inline-block; margin-top: 20px; }
        .btn-logout:hover { background: #B98A46; color: #FFF; }
    </style>
</head>
<body>

<div class="card-dev">
    <div class="dev-icon">🚧</div>
    <h3 class="fw-bold text-dark mb-2">Chức Năng Đang Phát Triển</h3>
    <p class="text-muted">
        Xin chào <strong>${sessionScope.hoTen != null ? sessionScope.hoTen : sessionScope.tenDangNhap}</strong> (${sessionScope.vaiTro})!<br>
        Giao diện làm việc cho bộ phận nhân viên hiện đang được nâng cấp và sẽ hoàn thiện ở phiên bản tiếp theo.
    </p>
    <a href="${pageContext.request.contextPath}/logout" class="btn-logout">🚪 Đăng Xuất</a>
</div>

</body>
</html>
