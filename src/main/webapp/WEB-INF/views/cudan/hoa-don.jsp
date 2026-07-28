<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="util.DisplayUtil" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Hóa Đơn Của Tôi - PolyBuilding Cư Dân</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/role-cudan.css">
    <style>
        .stat-card {
            border-radius: 12px;
            padding: 20px;
            color: white;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            min-height: 105px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        }
        .stat-card .number {
            font-size: 1.8rem;
            font-weight: 700;
        }
        .stat-card .label {
            font-size: 0.85rem;
            opacity: 0.9;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .table-custom th {
            background-color: #f8f9fa;
            color: var(--cd-sidebar);
            font-weight: 600;
        }
    </style>
</head>
<body>

<div class="layout-wrapper">
    <jsp:include page="/WEB-INF/views/cudan/common/sidebar.jsp" />

    <div class="main-content">
        <jsp:include page="/WEB-INF/views/cudan/common/header.jsp" />

        <!-- 3 Thẻ Tổng Quan -->
        <div class="row g-3 mb-4">
            <div class="col-md-4">
                <div class="stat-card" style="background: linear-gradient(135deg, #1B2A4A, #2563EB);">
                    <span class="label">📜 Tổng Số Hóa Đơn</span>
                    <span class="number">${tongSoHoaDon}</span>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stat-card" style="background: linear-gradient(135deg, #f57c00, #ff9800);">
                    <span class="label">⏳ Hóa Đơn Chưa Thanh Toán</span>
                    <span class="number">${soChuaThanhToan}</span>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stat-card" style="background: linear-gradient(135deg, #c62828, #e53935);">
                    <span class="label">⚠️ Tổng Công Nợ Còn Lại</span>
                    <span class="number">${DisplayUtil.formatTien(tongCongNo)}</span>
                </div>
            </div>
        </div>

        <!-- Bảng Hóa Đơn Căn Hộ -->
        <div class="card-custom">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h5 class="fw-bold m-0" style="color: var(--cd-sidebar);">
                    🧾 Danh Sách Hóa Đơn Căn Hộ Của Tôi
                </h5>
            </div>

            <div class="table-responsive">
                <table class="table table-hover table-bordered table-custom align-middle">
                    <thead>
                    <tr>
                        <th class="text-center">Kỳ Hóa Đơn</th>
                        <th class="text-end">Tổng Tiền</th>
                        <th class="text-end">Đã Thanh Toán</th>
                        <th class="text-end">Còn Nợ</th>
                        <th class="text-center">Trạng Thái</th>
                        <th class="text-center">Thao Tác</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${not empty hoaDonList}">
                            <c:forEach var="row" items="${hoaDonList}">
                                <tr>
                                    <td class="text-center fw-bold text-primary">
                                        Tháng <c:out value="${row[1]}" />/<c:out value="${row[2]}" />
                                    </td>
                                    <td class="text-end fw-bold">${DisplayUtil.formatTienDouble(row[3])}</td>
                                    <td class="text-end text-success">${DisplayUtil.formatTien(row[5])}</td>
                                    <td class="text-end fw-bold text-danger">${DisplayUtil.formatTien(row[6])}</td>
                                    <td class="text-center">
                                        <span class="badge ${DisplayUtil.getTrangThaiThanhToanBadgeClass(row[4])}">
                                            ${DisplayUtil.getTrangThaiThanhToanText(row[4])}
                                        </span>
                                    </td>
                                    <td class="text-center">
                                        <a href="${pageContext.request.contextPath}/cudan/hoa-don/chi-tiet?id=${row[0]}"
                                           class="btn btn-sm btn-outline-primary fw-semibold">
                                            🔍 Xem Chi Tiết
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="6" class="text-center text-muted py-4">Chưa có hóa đơn nào cho căn hộ của bạn.</td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
