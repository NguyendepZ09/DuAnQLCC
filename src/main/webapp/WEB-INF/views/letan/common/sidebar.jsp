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
        <a href="${pageContext.request.contextPath}/letan/the-tu" class="nav-item ${activeMenu == 'the-tu' ? 'active' : ''}">
            🪪 <span>Thẻ từ cư dân</span>
        </a>
        <a href="${pageContext.request.contextPath}/letan/nfc-the" class="nav-item ${activeMenu == 'nfc-the' ? 'active' : ''}">
            📱 <span>Ghi thẻ NFC</span>
        </a>
        <a href="${pageContext.request.contextPath}/letan/quan-ly-xe" class="nav-item ${activeMenu == 'quan-ly-xe' ? 'active' : ''}">
            🚗 <span>Quản lý xe</span>
        </a>
        <a href="${pageContext.request.contextPath}/letan/cu-dan" class="nav-item ${activeMenu == 'cu-dan' ? 'active' : ''}">
            👥 <span>Quản lý cư dân & Khách thuê</span>
        </a>
        <a href="${pageContext.request.contextPath}/letan/duyet-tien-ich" class="nav-item ${activeMenu == 'duyet-tien-ich' ? 'active' : ''}">
            🏊 <span>Duyệt đặt tiện ích</span>
        </a>
        <a href="${pageContext.request.contextPath}/letan/thong-bao" class="nav-item ${activeMenu == 'thong-bao' ? 'active' : ''}">
            📢 <span>Thông báo</span>
            <c:if test="${countThongBaoChuaDoc > 0}">
                <span class="badge bg-danger rounded-pill ms-auto">${countThongBaoChuaDoc}</span>
            </c:if>
        </a>
        <a href="${pageContext.request.contextPath}/letan/cham-cong" class="nav-item ${activeMenu == 'cham-cong' ? 'active' : ''}">
            ⏱️ <span>Chấm công của tôi</span>
        </a>
        
        <div class="nav-divider"></div>
        <a href="${pageContext.request.contextPath}/logout" class="nav-item text-danger">
            🚪 <span>Đăng Xuất</span>
        </a>
    </nav>
</div>
