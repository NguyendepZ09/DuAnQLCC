<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="util.DisplayUtil" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi Tiết Hóa Đơn - PolyBuilding Cư Dân</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/role-cudan.css">
    <style>
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

        <div class="mb-3">
            <a href="${pageContext.request.contextPath}/cudan/hoa-don" class="btn btn-outline-secondary btn-sm">
                ⬅️ Quay lại danh sách hóa đơn
            </a>
        </div>

        <div class="card-custom">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <div>
                    <h5 class="fw-bold m-0" style="color: var(--cd-sidebar);">
                        🧾 Chi Tiết Hóa Đơn Tháng ${data.thang}/${data.nam}
                    </h5>
                    <small class="text-muted">Căn hộ: Phòng ${data.soPhong} (Diện tích: ${data.dienTich} m²)</small>
                </div>
                <div>
                    <span class="badge fs-6 ${DisplayUtil.getTrangThaiThanhToanBadgeClass(data.trangThaiThanhToan)}">
                        ${DisplayUtil.getTrangThaiThanhToanText(data.trangThaiThanhToan)}
                    </span>
                </div>
            </div>

            <!-- Bảng Chi Tiết Các Món Tiền -->
            <div class="table-responsive mb-4">
                <table class="table table-bordered table-custom align-middle">
                    <thead>
                    <tr>
                        <th>Dịch Vụ</th>
                        <th class="text-center">Chỉ Số Cũ</th>
                        <th class="text-center">Chỉ Số Mới</th>
                        <th class="text-center">Số Lượng</th>
                        <th class="text-center">Đơn Vị</th>
                        <th class="text-end">Đơn Giá</th>
                        <th class="text-end">Thành Tiền</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="ct" items="${data.chiTietList}">
                        <tr>
                            <td class="fw-bold text-primary">
                                ${DisplayUtil.getLoaiDichVuText(ct.loaiDichVu)}
                            </td>
                            <td class="text-center">
                                <c:choose>
                                    <c:when test="${not empty ct.chiSoCu}">${ct.chiSoCu}</c:when>
                                    <c:otherwise><span class="text-muted">—</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td class="text-center">
                                <c:choose>
                                    <c:when test="${not empty ct.chiSoMoi}">${ct.chiSoMoi}</c:when>
                                    <c:otherwise><span class="text-muted">—</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td class="text-center fw-semibold">
                                <c:choose>
                                    <c:when test="${not empty ct.soLuong}">${ct.soLuong}</c:when>
                                    <c:otherwise><span class="text-muted">—</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td class="text-center text-muted">
                                ${DisplayUtil.getDonViTinhText(ct.donViTinh)}
                            </td>
                            <td class="text-end">
                                <c:choose>
                                    <c:when test="${not empty ct.donGia}">${DisplayUtil.formatTien(ct.donGia)}</c:when>
                                    <c:otherwise><span class="text-muted">—</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td class="text-end fw-bold text-success">
                                ${DisplayUtil.formatTienDouble(ct.thanhTien)}
                            </td>
                        </tr>
                        <!-- Dòng Diễn Giải (Bậc thang điện nước / cách tính) -->
                        <c:if test="${not empty ct.dienGiai}">
                            <tr class="table-light">
                                <td colspan="7" class="small text-muted ps-4 py-2">
                                    💡 <strong>Diễn giải chi tiết:</strong> <c:out value="${ct.dienGiai}"/>
                                </td>
                            </tr>
                        </c:if>
                    </c:forEach>
                    <tr class="table-warning fw-bold fs-6">
                        <td colspan="6" class="text-end text-dark">TỔNG CỘNG HÓA ĐƠN:</td>
                        <td class="text-end text-danger fs-5">${DisplayUtil.formatTienDouble(data.tongTien)}</td>
                    </tr>
                    </tbody>
                </table>
            </div>

            <!-- Bảng Lịch Sử Thanh Toán -->
            <h6 class="fw-bold mb-3" style="color: var(--cd-sidebar);">
                💳 Lịch Sử Các Giao Dịch Thanh Toán Dành Cho Hóa Đơn Này
            </h6>
            <div class="table-responsive">
                <table class="table table-sm table-bordered align-middle">
                    <thead class="table-light">
                    <tr>
                        <th class="text-center">Mã GD</th>
                        <th class="text-center">Thời Gian</th>
                        <th class="text-end">Số Tiền</th>
                        <th class="text-center">Phương Thức</th>
                        <th>Mã GD Ngân Hàng</th>
                        <th class="text-center">Trạng Thái</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${not empty data.giaoDichList}">
                            <c:forEach var="gd" items="${data.giaoDichList}">
                                <tr>
                                    <td class="text-center fw-bold">#<c:out value="${gd[0]}" /></td>
                                    <td class="text-center small"><c:out value="${gd[4]}" /></td>
                                    <td class="text-end fw-bold text-success">${DisplayUtil.formatTien(gd[1])}</td>
                                    <td class="text-center">${DisplayUtil.getPhuongThucText(gd[2])}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty gd[5]}"><code><c:out value="${gd[5]}" /></code></c:when>
                                            <c:otherwise><span class="text-muted">—</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-center">
                                        <span class="badge ${DisplayUtil.getTrangThaiGiaoDichBadgeClass(gd[3])}">
                                            ${DisplayUtil.getTrangThaiGiaoDichText(gd[3])}
                                        </span>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="6" class="text-center text-muted py-3">Chưa có giao dịch thanh toán nào được ghi nhận cho hóa đơn này.</td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
            </div>

            <!-- Dòng Hướng Dẫn Thanh Toán -->
            <div class="alert alert-info border-start border-4 border-info mt-4 mb-0">
                ℹ️ <strong>Hướng dẫn thanh toán:</strong> Quý cư dân vui lòng thanh toán trực tiếp bằng tiền mặt tại Văn phòng Kế toán tòa nhà hoặc chuyển khoản ngân hàng tới tài khoản Ban quản lý với nội dung: <code>[Số phòng] Thanh toan HD [Mã HĐ]</code>.
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
