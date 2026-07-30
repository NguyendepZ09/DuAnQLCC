<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<div class="sidebar">
    <div class="sidebar-brand">
        <span class="mark"></span> POLYBUILDING BẢO VỆ
    </div>

    <div class="sidebar-user">
        <div class="avatar">
            ${not empty sessionScope.hoTen ? sessionScope.hoTen.substring(0,1).toUpperCase() : 'B'}
        </div>
        <div>
            <span class="name">${not empty sessionScope.hoTen ? sessionScope.hoTen : sessionScope.tenDangNhap}</span>
            <span class="role">Đội Ngũ Bảo Vệ</span>
        </div>
    </div>

    <nav class="sidebar-nav">
        <a href="${pageContext.request.contextPath}/baove/dashboard" class="nav-item ${activeMenu == 'dashboard' ? 'active' : ''}">
            📊 <span>Bảng Tin</span>
        </a>
        <a href="${pageContext.request.contextPath}/baove/tuan-tra" class="nav-item ${activeMenu == 'tuan-tra' ? 'active' : ''}">
            🛡️ <span>Nhật Ký Tuần Tra</span>
        </a>
        <a href="${pageContext.request.contextPath}/baove/ca-truc" class="nav-item ${activeMenu == 'ca-truc' ? 'active' : ''}">
            🤝 <span>Ca Trực & Bàn Giao</span>
        </a>
        <a href="${pageContext.request.contextPath}/baove/tra-cuu" class="nav-item ${activeMenu == 'tra-cuu' ? 'active' : ''}">
            🔍 <span>Tra Cứu Xe & Thẻ</span>
        </a>
        <a href="${pageContext.request.contextPath}/baove/thong-bao" class="nav-item ${activeMenu == 'thong-bao' ? 'active' : ''}">
            📢 <span>Thông Báo</span>
            <c:if test="${countThongBaoChuaDoc > 0}">
                <span class="badge bg-danger rounded-pill ms-auto">${countThongBaoChuaDoc}</span>
            </c:if>
        </a>
        <a href="${pageContext.request.contextPath}/baove/cham-cong" class="nav-item ${activeMenu == 'cham-cong' ? 'active' : ''}">
            ⏱️ <span>Chấm Công Của Tôi</span>
        </a>
        
        <div class="nav-divider"></div>
        <a href="${pageContext.request.contextPath}/logout" class="nav-item text-danger">
            🚪 <span>Đăng Xuất</span>
        </a>
    </nav>
</div>
