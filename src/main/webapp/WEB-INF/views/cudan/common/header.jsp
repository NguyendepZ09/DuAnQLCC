<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<div class="top-header">
    <div>
        <h2>Hệ Thống Cư Dân Polybuilding</h2>
        <span class="sub">
            Xin chào <strong>${sessionScope.hoTen != null ? sessionScope.hoTen : sessionScope.tenDangNhap}</strong> 
            <c:if test="${not empty canHoInfo}">
                — 🏢 <strong>Phòng ${canHoInfo.soPhong} (Tầng ${canHoInfo.soTang})</strong>
            </c:if>
        </span>
    </div>
    <div class="d-flex align-items-center gap-3">
        <a href="${pageContext.request.contextPath}/logout" class="btn btn-sm btn-outline-danger font-semibold">Đăng Xuất</a>
    </div>
</div>
