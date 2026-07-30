<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="util.DisplayUtil" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/WEB-INF/views/common/head.jsp" %>
    <title>Hồ Sơ Căn Hộ Của Tôi — PolyBuilding Cư Dân</title>

    <style>
.info-box {
            background-color: #FFFFFF;
            border-radius: 12px;
            border: 1px solid var(--cd-border);
            padding: 20px;
            margin-bottom: 24px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.04);
        }
        .info-label {
            font-size: 0.8rem;
            color: var(--cd-muted);
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 4px;
        }
        .info-value {
            font-size: 1.25rem;
            font-weight: 700;
            color: var(--cd-sidebar);
        }
        .badge-chuho {
            background-color: #1E3B34;
            color: #FFFFFF;
            font-weight: 600;
        }
        .badge-khachthue {
            background-color: #B98A46;
            color: #FFFFFF;
            font-weight: 600;
        }
    </style>
</head>
<body>

<div class="layout-wrapper">
    <jsp:include page="/WEB-INF/views/cudan/common/sidebar.jsp" />

    <div class="main-content">
        <jsp:include page="/WEB-INF/views/cudan/common/header.jsp" />

        <div class="container-fluid px-4 py-3">

            <!-- KHỐI A: THÔNG TIN CĂN HỘ -->
            <div class="card-custom mb-4">
                <h5 class="fw-bold mb-3" style="color: var(--cd-sidebar);">
                    🏠 KHỐI A — Thông Tin Căn Hộ
                </h5>
                <div class="row g-3">
                    <div class="col-md-3">
                        <div class="info-box mb-0 text-center">
                            <div class="info-label">Số Phòng</div>
                            <div class="info-value text-primary">P.<c:out value="${canHo.soPhong}" default="—" /></div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="info-box mb-0 text-center">
                            <div class="info-label">Tầng Tháp</div>
                            <div class="info-value text-success">Tầng <c:out value="${canHo.soTang}" default="—" /></div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="info-box mb-0 text-center">
                            <div class="info-label">Diện Tích</div>
                            <div class="info-value text-dark"><c:out value="${canHo.dienTich}" default="—" /> m²</div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="info-box mb-0 text-center">
                            <div class="info-label">Trạng Thái</div>
                            <div class="info-value text-warning fs-6">
                                <c:choose>
                                    <c:when test="${canHo.trangThai == 'DangO' or canHo.trangThai == 'DaDuocThue'}">
                                        <span class="badge bg-success">Đang ở</span>
                                    </c:when>
                                    <c:when test="${canHo.trangThai == 'Trong' or canHo.trangThai == 'TrongChoThue'}">
                                        <span class="badge bg-secondary">Căn trống</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-info"><c:out value="${canHo.trangThai}" default="—" /></span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- KHỐI B: THÀNH VIÊN TRONG CĂN HỘ -->
            <div class="card-custom mb-4">
                <h5 class="fw-bold mb-3" style="color: var(--cd-sidebar);">
                    👥 KHỐI B — Thành Viên Trong Căn Hộ
                </h5>
                <div class="table-responsive">
                    <table class="table table-hover table-bordered align-middle">
                        <thead class="table-light">
                        <tr>
                            <th style="width: 50px;" class="text-center">STT</th>
                            <th>Họ Và Tên</th>
                            <th class="text-center">Vai Trò / Loại Cư Dân</th>
                            <th class="text-center">Số Điện Thoại</th>
                            <th class="text-center">Ngày Chuyển Đến</th>
                        </tr>
                        </thead>
                        <tbody>
                        <%-- Comment NGOÀI c:choose --%>
                        <c:choose>
                            <c:when test="${not empty dsCuDan}">
                                <c:forEach var="cd" items="${dsCuDan}" varStatus="loop">
                                    <tr>
                                        <td class="text-center fw-bold">${loop.index + 1}</td>
                                        <td class="fw-bold text-dark"><c:out value="${cd.hoTen}" /></td>
                                        <td class="text-center">
                                            <span class="badge ${cd.loaiCuDan == 'ChuHo' ? 'badge-chuho' : 'badge-khachthue'}">
                                                ${DisplayUtil.getLoaiCuDanText(cd.loaiCuDan)}
                                            </span>
                                        </td>
                                        <td class="text-center fw-semibold text-primary">
                                            <c:out value="${cd.soDienThoai}" default="—" />
                                        </td>
                                        <td class="text-center">
                                            <c:out value="${cd.ngayChuyenDenText}" default="—" />
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="5" class="text-center text-muted py-4">Chưa có thông tin cư dân nào được ghi nhận.</td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- KHỐI C: THẺ TỪ CỦA CĂN HỘ -->
            <div class="card-custom mb-4">
                <h5 class="fw-bold mb-3" style="color: var(--cd-sidebar);">
                    🪪 KHỐI C — Danh Sách Thẻ Từ Đã Cấp
                </h5>
                <div class="table-responsive">
                    <table class="table table-hover table-bordered align-middle">
                        <thead class="table-light">
                        <tr>
                            <th class="text-center">Mã Thẻ Từ</th>
                            <th class="text-center">Ngày Cấp</th>
                            <th class="text-center">Ngày Hết Hạn</th>
                            <th>Chức Năng Được Phép</th>
                            <th class="text-center">Trạng Thái Thẻ</th>
                        </tr>
                        </thead>
                        <tbody>
                        <%-- Comment NGOÀI c:choose --%>
                        <c:choose>
                            <c:when test="${not empty dsTheTu}">
                                <c:forEach var="the" items="${dsTheTu}">
                                    <tr>
                                        <td class="text-center font-monospace fw-bold text-primary">
                                            <c:out value="${the[0]}" />
                                        </td>
                                        <td class="text-center"><c:out value="${the[1]}" default="—" /></td>
                                        <td class="text-center fw-semibold">
                                            <c:out value="${the[2]}" default="—" />
                                            <c:if test="${the[5] == true}">
                                                <span class="badge bg-danger ms-1">Hết hạn</span>
                                            </c:if>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty the[4]}">
                                                    <c:forEach var="cn" items="${the[4].split(',')}">
                                                        <span class="badge bg-light text-dark border me-1">
                                                            ${DisplayUtil.getChucNangTheText(cn)}
                                                        </span>
                                                    </c:forEach>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted small">Chưa phân quyền</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-center">
                                            <span class="badge ${DisplayUtil.getTrangThaiTheBadgeClass(the[3])}">
                                                ${DisplayUtil.getTrangThaiTheText(the[3])}
                                            </span>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="5" class="text-center text-muted py-4">Căn hộ chưa có thẻ từ nào được kích hoạt.</td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- KHỐI D: PHƯƠNG TIỆN ĐĂNG KÝ -->
            <div class="card-custom mb-4">
                <h5 class="fw-bold mb-3" style="color: var(--cd-sidebar);">
                    🚗 KHỐI D — Danh Sách Phương Tiện Đăng Ký
                </h5>
                <div class="table-responsive">
                    <table class="table table-hover table-bordered align-middle">
                        <thead class="table-light">
                        <tr>
                            <th class="text-center">Biển Số Xe</th>
                            <th class="text-center">Loại Phương Tiện</th>
                            <th class="text-center">Mã Thẻ Từ Gắn Kèm</th>
                        </tr>
                        </thead>
                        <tbody>
                        <%-- Comment NGOÀI c:choose --%>
                        <c:choose>
                            <c:when test="${not empty dsXe}">
                                <c:forEach var="xe" items="${dsXe}">
                                    <tr>
                                        <td class="text-center font-monospace fw-bold text-success">
                                            <c:out value="${xe[0]}" />
                                        </td>
                                        <td class="text-center">
                                            <span class="badge bg-light text-dark border">
                                                ${DisplayUtil.getLoaiXeText(xe[1])}
                                            </span>
                                        </td>
                                        <td class="text-center font-monospace">
                                            <c:choose>
                                                <c:when test="${not empty xe[2]}">
                                                    <span class="badge bg-primary"><c:out value="${xe[2]}" /></span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted small">Chưa gắn thẻ</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="3" class="text-center text-muted py-4">Căn hộ chưa đăng ký phương tiện nào.</td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>
                </div>

                <div class="alert alert-info border-start border-4 border-info mt-3 mb-0 small">
                    💡 <strong>Lưu ý:</strong> Để cấp thẻ từ mới hoặc đăng ký phương tiện gửi xe, vui lòng liên hệ trực tiếp quầy Lễ tân tòa nhà.
                </div>
            </div>

        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        // Màn hình Hồ sơ căn hộ cư dân PolyBuilding
    });
</script>
</body>
</html>
