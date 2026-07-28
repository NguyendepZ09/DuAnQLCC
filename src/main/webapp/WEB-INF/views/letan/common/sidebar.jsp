<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<div class="sidebar">
    <div class="sidebar-brand">
        <span class="mark"></span> POLYBUILDING LỄ TÂN
    </div>

    <div class="sidebar-user">
        <div class="avatar">
            ${not empty sessionScope.hoTen ? sessionScope.hoTen.substring(0,1).toUpperCase() : 'L'}
        </div>
        <div>
            <span class="name">${not empty sessionScope.hoTen ? sessionScope.hoTen : sessionScope.tenDangNhap}</span>
            <span class="role">Bộ Phận Lễ Tân</span>
        </div>
    </div>

    <nav class="sidebar-nav">
        <a href="${pageContext.request.contextPath}/letan/su-co" class="nav-item ${activeMenu == 'su-co' ? 'active' : ''}">
            🛠️ <span>Tiếp nhận & Điều phối sự cố</span>
        </a>
        <a href="${pageContext.request.contextPath}/letan/dang-phat-trien" class="nav-item ${activeMenu == 'cu-dan' ? 'active' : ''}">
            👥 <span>Quản lý cư dân & Khách thuê</span>
        </a>
        <a href="${pageContext.request.contextPath}/letan/dang-phat-trien" class="nav-item ${activeMenu == 'the-tu' ? 'active' : ''}">
            🪪 <span>Quản lý thẻ từ</span>
        </a>
        
        <div class="nav-divider"></div>
        <a href="${pageContext.request.contextPath}/logout" class="nav-item text-danger">
            🚪 <span>Đăng Xuất</span>
        </a>
    </nav>
</div>
