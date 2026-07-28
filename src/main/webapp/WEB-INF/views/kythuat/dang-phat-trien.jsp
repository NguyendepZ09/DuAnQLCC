<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chức Năng Đang Phát Triển — Kỹ Thuật</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        body { background-color: #F8FAFC; font-family: 'Be Vietnam Pro', sans-serif; }
        .app-layout { display: flex; min-height: 100vh; }
        .sidebar { width: 260px; background: #1E293B; color: #FFF; padding: 24px; flex-shrink: 0; }
        .sidebar-brand { font-family: 'Fraunces', serif; font-size: 1.15rem; font-weight: 700; color: #F59E0B; margin-bottom: 30px; display: flex; align-items: center; gap: 8px; }
        .sidebar-brand .mark { width: 10px; height: 10px; background: #F59E0B; transform: rotate(45deg); display: inline-block; }
        .sidebar-user { display: flex; align-items: center; gap: 12px; padding: 12px; background: rgba(255,255,255,0.08); border-radius: 8px; margin-bottom: 24px; }
        .sidebar-user .avatar { width: 38px; height: 38px; background: #334155; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 0.8rem; color: #F59E0B; }
        .sidebar-user .name { font-size: 0.9rem; font-weight: 600; display: block; color: #FFF; }
        .sidebar-user .role { font-size: 0.75rem; color: rgba(255,255,255,0.6); }
        .sidebar-nav { display: flex; flex-direction: column; gap: 6px; }
        .nav-item { display: flex; align-items: center; gap: 12px; padding: 12px 16px; color: rgba(255,255,255,0.75); text-decoration: none; border-radius: 6px; font-size: 0.9rem; font-weight: 500; transition: all 0.2s; }
        .nav-item:hover, .nav-item.active { background: #334155; color: #F59E0B; }
        .nav-divider { height: 1px; background: rgba(255,255,255,0.1); margin: 12px 0; }
        .main-wrapper { flex-grow: 1; display: flex; flex-direction: column; overflow-x: hidden; }
        .top-header { background: #FFF; padding: 18px 32px; border-bottom: 1px solid #E2E8F0; display: flex; justify-content: space-between; align-items: center; }
        .top-header h2 { font-family: 'Fraunces', serif; font-size: 1.4rem; color: #1E293B; margin: 0; }
        .top-header .sub { font-size: 0.82rem; color: #64748B; }
        .content-body { padding: 32px; }
        .card-custom { background: #FFF; border-radius: 12px; padding: 48px; border: 1px solid #E2E8F0; text-align: center; }
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
