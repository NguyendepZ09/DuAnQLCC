<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/WEB-INF/views/common/head.jsp" %>
    <title>Chức Năng Đang Phát Triển — Kỹ Thuật</title>

    <style>
body { background-color: #F4EFE4; font-family: 'Be Vietnam Pro', sans-serif; }
        .card-custom { background: #FFF; border-radius: 12px; padding: 48px; border: 1px solid #EAE3D2; text-align: center; }
    </style>
</head>
<body>

<div class="app-layout">
    <%@ include file="/WEB-INF/views/kythuat/common/sidebar.jsp" %>

    <div class="main-wrapper">
        <%@ include file="/WEB-INF/views/kythuat/common/header.jsp" %>

        <div class="content-body">
            <div class="card-custom text-center">
                <div class="display-1 mb-3">🛠️</div>
                <h3 class="fw-bold text-dark mb-2">Chức Năng Đang Trong Quá Trình Phát Triển</h3>
                <p class="text-muted max-w-md mx-auto mb-4">
                    Tính năng này đang được đội ngũ kỹ thuật xây dựng và sẽ sớm ra mắt trong phiên bản tiếp theo.
                </p>
                <a href="${pageContext.request.contextPath}/kythuat/cong-viec" class="btn btn-dark px-4 fw-bold text-warning">
                    ← Quay lại Danh sách Công việc được giao
                </a>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
