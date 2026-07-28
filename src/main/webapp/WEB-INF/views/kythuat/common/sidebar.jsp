<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<div class="sidebar">
    <div class="sidebar-brand">
        <span class="mark"></span> POLYBUILDING KỸ THUẬT
    </div>

    <div class="sidebar-user">
        <div class="avatar">
            ${not empty sessionScope.hoTen ? sessionScope.hoTen.substring(0,1).toUpperCase() : 'K'}
        </div>
        <div>
            <span class="name">${not empty sessionScope.hoTen ? sessionScope.hoTen : sessionScope.tenDangNhap}</span>
            <span class="role">Bộ Phận Kỹ Thuật</span>
        </div>
    </div>

    <nav class="sidebar-nav">
        <a href="${pageContext.request.contextPath}/kythuat/cong-viec" class="nav-item ${activeMenu == 'cong-viec' ? 'active' : ''}">
            🛠️ <span>Công việc được giao</span>
        </a>
        <a href="${pageContext.request.contextPath}/kythuat/lich-su" class="nav-item ${activeMenu == 'lich-su' ? 'active' : ''}">
            📜 <span>Lịch sử xử lý của tôi</span>
        </a>
        <a href="${pageContext.request.contextPath}/kythuat/dang-phat-trien" class="nav-item ${activeMenu == 'cham-cong' ? 'active' : ''}">
            ⏱️ <span>Chấm công của tôi</span>
        </a>
        
        <div class="nav-divider"></div>
        <a href="${pageContext.request.contextPath}/logout" class="nav-item text-danger">
            🚪 <span>Đăng Xuất</span>
        </a>
    </nav>
</div>
