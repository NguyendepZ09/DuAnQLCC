<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="util.DisplayUtil" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/WEB-INF/views/common/head.jsp" %>
    <title>Chi Tiết Hóa Đơn #${hoaDonInfo.hoaDonId} - PolyBuilding Kế Toán</title>

    <style>
:root {
            --bg-primary: #1E3B34;
            --bg-accent: #B98A46;
            --bg-cream: #F4EFE4;
            --text-dark: #2C3E50;
        }
        body {
            background-color: var(--bg-cream);
            color: var(--text-dark);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .card-custom {
            background-color: white;
            border-radius: 12px;
            border: none;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            padding: 25px;
            margin-bottom: 25px;
        }
        .info-label {
            font-size: 0.85rem;
            color: #6c757d;
            text-transform: uppercase;
            font-weight: 600;
        }
        .info-value {
            font-size: 1.1rem;
            font-weight: 700;
            color: var(--bg-primary);
        }
        .table-custom th {
            background-color: #f8f9fa;
            color: var(--bg-primary);
            font-weight: 600;
        }
    </style>
</head>
<body>

<div class="layout-wrapper">
    <jsp:include page="/WEB-INF/views/ketoan/common/sidebar.jsp" />

    <div class="main-content">
        <jsp:include page="/WEB-INF/views/ketoan/common/header.jsp" />

        <div class="mb-3">
            <a href="${pageContext.request.contextPath}/ketoan/hoa-don" class="btn btn-outline-secondary">
                ⬅️ Quay lại danh sách hóa đơn
            </a>
        </div>

        <!-- Thông Tin Tổng Quan Hóa Đơn -->
        <div class="card-custom">
            <div class="d-flex justify-content-between align-items-center mb-4 border-bottom pb-3">
                <div>
                    <h4 class="fw-bold m-0" style="color: var(--bg-primary);">
                        🧾 Chi Tiết Hóa Đơn #${hoaDonInfo.hoaDonId}
                    </h4>
                    <span class="text-muted">Kỳ thanh toán: Tháng ${hoaDonInfo.thang}/${hoaDonInfo.nam}</span>
                </div>
                <div>
                    <span class="badge fs-6 ${DisplayUtil.getTrangThaiThanhToanBadgeClass(hoaDonInfo.trangThaiThanhToan)}">
                        ${DisplayUtil.getTrangThaiThanhToanText(hoaDonInfo.trangThaiThanhToan)}
                    </span>
                </div>
            </div>

            <div class="row g-4">
                <div class="col-md-3">
                    <span class="info-label">Căn Hộ / Phòng</span>
                    <div class="info-value text-primary">Phòng ${hoaDonInfo.soPhong}</div>
                </div>
                <div class="col-md-3">
                    <span class="info-label">Diện Tích</span>
                    <div class="info-value">${hoaDonInfo.dienTich} m²</div>
                </div>
                <div class="col-md-3">
                    <span class="info-label">Chủ Hộ</span>
                    <div class="info-value">
                        <c:choose>
                            <c:when test="${not empty hoaDonInfo.tenChuHo}">${hoaDonInfo.tenChuHo}</c:when>
                            <c:otherwise><i>(Chưa cập nhật)</i></c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <div class="col-md-3">
                    <span class="info-label">Tổng Tiền Hóa Đơn</span>
                    <div class="info-value text-success fs-4">
                        ${DisplayUtil.formatTien(hoaDonInfo.tongTien)}
                    </div>
                </div>
            </div>
        </div>

        <!-- Bảng Chi Tiết Dịch Vụ -->
        <div class="card-custom">
            <h5 class="fw-bold mb-3" style="color: var(--bg-primary);">
                📋 Bảng Kê Dịch Vụ Chi Tiết
            </h5>

            <div class="table-responsive">
                <table class="table table-hover table-bordered table-custom align-middle">
                    <thead>
                    <tr>
                        <th>Loại Dịch Vụ</th>
                        <th class="text-center">Số Lượng</th>
                        <th class="text-center">Đơn Vị</th>
                        <th class="text-end">Đơn Giá</th>
                        <th class="text-end">Thành Tiền</th>
                        <th>Diễn Giải / Chi Tiết Tách Bậc</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${not empty chiTietList}">
                            <c:forEach var="ct" items="${chiTietList}">
                                <tr>
                                    <td class="fw-bold">
                                        ${DisplayUtil.getLoaiDichVuText(ct.loaiDichVu)}
                                    </td>
                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${not empty ct.soLuong}">${ct.soLuong}</c:when>
                                            <c:otherwise>-</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-center">
                                        ${DisplayUtil.getDonViTinhText(ct.donViTinh)}
                                    </td>
                                    <td class="text-end">
                                        <c:choose>
                                            <c:when test="${not empty ct.donGia}">${DisplayUtil.formatTien(ct.donGia)}</c:when>
                                            <c:otherwise>—</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-end fw-bold text-success">
                                        ${DisplayUtil.formatTien(ct.thanhTien)}
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty ct.dienGiai}">
                                                <span class="text-secondary" style="font-size: 0.9rem;">
                                                    <c:out value="${ct.dienGiai}" />
                                                </span>
                                            </c:when>
                                            <c:otherwise><span class="text-muted">—</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="6" class="text-center text-muted py-3">Chưa có dòng chi tiết nào.</td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                    <tfoot>
                    <tr class="table-light fw-bold">
                        <td colspan="4" class="text-end text-uppercase">TỔNG CỘNG HÓA ĐƠN:</td>
                        <td class="text-end text-success fs-5">
                            ${DisplayUtil.formatTien(hoaDonInfo.tongTien)}
                        </td>
                        <td></td>
                    </tr>
                    </tfoot>
                </table>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
