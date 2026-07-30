<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<div class="sidebar">
    <div class="sidebar-brand">
        <span class="mark"></span> POLYBUILDING KẾ TOÁN
    </div>

    <div class="sidebar-user">
        <div class="avatar">
            ${not empty sessionScope.hoTen ? sessionScope.hoTen.substring(0,1).toUpperCase() : 'K'}
        </div>
        <div>
            <span class="name">${not empty sessionScope.hoTen ? sessionScope.hoTen : sessionScope.tenDangNhap}</span>
            <span class="role">Bộ Phận Kế Toán</span>
        </div>
    </div>

    <nav class="sidebar-nav">
        <a href="${pageContext.request.contextPath}/ketoan/chi-so" class="nav-item ${activeMenu == 'chi-so' ? 'active' : ''}">
            ⚡ <span>Ghi chỉ số điện nước</span>
        </a>
        <a href="${pageContext.request.contextPath}/ketoan/hoa-don" class="nav-item ${activeMenu == 'hoa-don' ? 'active' : ''}">
            🧾 <span>Hóa đơn</span>
        </a>
        <a href="${pageContext.request.contextPath}/ketoan/bieu-gia" class="nav-item ${activeMenu == 'bieu-gia' ? 'active' : ''}">
            🏷️ <span>Biểu giá dịch vụ</span>
        </a>
        <a href="${pageContext.request.contextPath}/ketoan/thanh-toan" class="nav-item ${activeMenu == 'xac-nhan' ? 'active' : ''}">
            💳 <span>Xác nhận thanh toán</span>
        </a>
        <a href="${pageContext.request.contextPath}/ketoan/doi-soat" class="nav-item ${activeMenu == 'doi-soat' ? 'active' : ''}">
            📊 <span>Đối soát sao kê</span>
        </a>
        <a href="${pageContext.request.contextPath}/ketoan/thong-bao" class="nav-item ${activeMenu == 'thong-bao' ? 'active' : ''}">
            📢 <span>Thông báo</span>
            <c:if test="${countThongBaoChuaDoc > 0}">
                <span class="badge bg-danger rounded-pill ms-auto">${countThongBaoChuaDoc}</span>
            </c:if>
        </a>
        <a href="${pageContext.request.contextPath}/ketoan/cham-cong" class="nav-item ${activeMenu == 'cham-cong' ? 'active' : ''}">
            ⏱️ <span>Chấm công của tôi</span>
        </a>
        
        <div class="nav-divider"></div>
        <a href="${pageContext.request.contextPath}/logout" class="nav-item text-danger">
            🚪 <span>Đăng Xuất</span>
        </a>
    </nav>
</div>
