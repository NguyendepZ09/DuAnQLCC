<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%
    String currentUri = request.getRequestURI();
%>
<aside class="sidebar">
    <div class="sidebar-brand">
        <span class="mark"></span>
        <span>POLYBUILDING</span>
    </div>
    <div class="sidebar-user">
        <div class="avatar">BQL</div>
        <div class="user-info">
            <span class="name">${sessionScope.hoTen != null ? sessionScope.hoTen : 'Ban Quản Lý'}</span>
            <span class="role">Quản Trị Viên (Admin)</span>
        </div>
    </div>
    <nav class="sidebar-nav">
        <a href="${pageContext.request.contextPath}/banquanly/dashboard" class="nav-item <%= currentUri.contains("dashboard") || currentUri.contains("thong-ke") ? "active" : "" %>">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="7" height="9"/><rect x="14" y="3" width="7" height="5"/><rect x="14" y="12" width="7" height="9"/><rect x="3" y="16" width="7" height="5"/></svg>
            Bảng Thống Kê
        </a>
        <a href="${pageContext.request.contextPath}/banquanly/so-do" class="nav-item <%= currentUri.contains("so-do") ? "active" : "" %>">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 9l9-7 9 7v11a2 2 0 01-2 2H5a2 2 0 01-2-2z"/></svg>
            Sơ Đồ 200 Căn Hộ
        </a>
        <a href="${pageContext.request.contextPath}/banquanly/tai-khoan" class="nav-item <%= currentUri.contains("tai-khoan") ? "active" : "" %>">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M17 21v-2a4 4 0 00-4-4H5a4 4 0 00-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 010 7.75"/></svg>
            Quản Lý Tài Khoản
        </a>
        <a href="${pageContext.request.contextPath}/banquanly/thong-bao" class="nav-item <%= currentUri.contains("thong-bao") ? "active" : "" %>">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M18 8A6 6 0 006 8c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.73 21a2 2 0 01-3.46 0"/></svg>
            Phát Hành Thông Báo
        </a>
        <a href="${pageContext.request.contextPath}/banquanly/binh-chon" class="nav-item <%= currentUri.contains("binh-chon") ? "active" : "" %>">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 11l3 3L22 4"/><path d="M21 12v7a2 2 0 01-2 2H5a2 2 0 01-2-2V5a2 2 0 012-2h11"/></svg>
            Bình Chọn / Khảo Sát
        </a>
        <div class="nav-divider"></div>
        <a href="${pageContext.request.contextPath}/logout" class="nav-item text-danger">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 21H5a2 2 0 01-2-2V5a2 2 0 012-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>
            Đăng Xuất
        </a>
    </nav>
</aside>
