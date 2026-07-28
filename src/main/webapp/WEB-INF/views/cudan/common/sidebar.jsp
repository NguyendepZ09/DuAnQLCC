<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<div class="sidebar">
    <div class="sidebar-brand">
        <span class="mark"></span> POLYBUILDING CƯ DÂN
    </div>

    <div class="sidebar-user">
        <div class="avatar">
            ${not empty sessionScope.hoTen ? sessionScope.hoTen.substring(0,1).toUpperCase() : 'C'}
        </div>
        <div>
            <span class="name">${not empty sessionScope.hoTen ? sessionScope.hoTen : sessionScope.tenDangNhap}</span>
            <span class="role">Cư dân Polybuilding</span>
        </div>
    </div>

    <nav class="sidebar-nav">
        <a href="${pageContext.request.contextPath}/cudan/thong-bao" class="nav-item ${activeMenu == 'thong-bao' ? 'active' : ''}">
            📢 <span>Thông báo & Bình chọn</span>
            <c:if test="${not empty unreadCount && unreadCount > 0}">
                <span class="badge bg-danger rounded-pill ms-auto">${unreadCount}</span>
            </c:if>
        </a>
        <a href="${pageContext.request.contextPath}/cudan/phan-anh" class="nav-item ${activeMenu == 'phan-anh' ? 'active' : ''}">
            🛠️ <span>Phản ánh sự cố</span>
        </a>
        <a href="${pageContext.request.contextPath}/nhanvien/dang-phat-trien" class="nav-item">
            🧾 <span>Hóa đơn & Công nợ</span>
        </a>
        <a href="${pageContext.request.contextPath}/nhanvien/dang-phat-trien" class="nav-item">
            🏊 <span>Đặt dịch vụ & Tiện ích</span>
        </a>
        
        <div class="nav-divider"></div>
        <a href="${pageContext.request.contextPath}/logout" class="nav-item text-danger">
            🚪 <span>Đăng Xuất</span>
        </a>
    </nav>
</div>
