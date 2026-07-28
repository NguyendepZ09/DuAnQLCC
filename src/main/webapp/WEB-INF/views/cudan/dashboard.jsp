<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Trang Cư Dân — Polybuilding</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/role-cudan.css">
    <style>
        /* Special page-specific styles can go here */
    </style>
</head>
<body>

<div class="app-layout">
    <%@ include file="/WEB-INF/views/cudan/common/sidebar.jsp" %>

    <div class="main-wrapper">
        <%@ include file="/WEB-INF/views/cudan/common/header.jsp" %>

        <div class="content-body">
            <h4 class="text-dark fw-bold mb-4">🏠 Trang Cư Dân Polybuilding</h4>

            <div class="card-custom mb-4">
                <h5 class="fw-bold text-dark mb-3">👋 Chào mừng bạn trở lại!</h5>
                <p class="text-secondary">
                    Hệ thống cư dân cho phép bạn theo dõi toàn bộ thông báo tòa nhà, tham gia bỏ phiếu trực tuyến các cuộc khảo sát ý kiến, xem hóa đơn và phản ánh sự cố.
                </p>
                <div class="row g-3 mt-2">
                    <div class="col-md-3">
                        <div class="p-3 bg-light rounded border text-center">
                            <span class="text-muted small block">Phòng Căn Hộ</span>
                            <h4 class="fw-bold text-primary m-0 mt-1">${not empty canHoInfo ? canHoInfo.soPhong : '0101'}</h4>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="p-3 bg-light rounded border text-center">
                            <span class="text-muted small block">Tầng Tòa Nhà</span>
                            <h4 class="fw-bold text-dark m-0 mt-1">${not empty canHoInfo ? canHoInfo.soTang : 1}</h4>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="p-3 bg-light rounded border text-center">
                            <span class="text-muted small block">Diện Tích Căn Hộ</span>
                            <h4 class="fw-bold text-success m-0 mt-1">${not empty canHoInfo ? canHoInfo.dienTich : 95.0} m²</h4>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="p-3 bg-light rounded border text-center">
                            <span class="text-muted small block">Trạng Thái Căn Hộ</span>
                            <h4 class="fw-bold text-info m-0 mt-1">${not empty canHoInfo ? canHoInfo.trangThai : 'DangO'}</h4>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
