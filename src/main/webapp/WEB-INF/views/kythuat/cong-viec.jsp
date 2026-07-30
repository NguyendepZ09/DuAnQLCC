<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="util.DisplayUtil" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/WEB-INF/views/common/head.jsp" %>
    <title>Công Việc Được Giao — Kỹ Thuật Polybuilding</title>

    <style>
body { background-color: #F4EFE4; font-family: 'Be Vietnam Pro', sans-serif; }
        .card-custom { background: #FFF; border-radius: 12px; padding: 24px; border: 1px solid #EAE3D2; box-shadow: 0 4px 12px rgba(0,0,0,0.03); }
    </style>
</head>
<body>

<div class="app-layout">
    <%@ include file="/WEB-INF/views/kythuat/common/sidebar.jsp" %>

    <div class="main-wrapper">
        <%@ include file="/WEB-INF/views/kythuat/common/header.jsp" %>

        <div class="content-body">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h4 class="text-dark fw-bold m-0">🛠️ Danh Sách Công Việc Được Giao</h4>
                <span class="badge bg-warning text-dark fs-6 py-2 px-3">
                    ⚡ <strong>${totalItems}</strong> phiếu đang xử lý
                </span>
            </div>

            <!-- Alert messages -->
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger alert-dismissible fade show mb-4" role="alert">
                    <strong>⚠️ Lỗi:</strong> ${errorMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            <c:if test="${not empty successMessage}">
                <div class="alert alert-success alert-dismissible fade show mb-4" role="alert">
                    <strong>✅ Thành công:</strong> ${successMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <!-- BỘ LỌC DỮ LIỆU -->
            <div class="card-custom mb-4">
                <form action="${pageContext.request.contextPath}/kythuat/cong-viec" method="get" class="row g-3 align-items-end">
                    <div class="col-md-4">
                        <label class="form-label font-semibold small text-muted">Loại Sự Cố</label>
                        <select name="loaiSuCo" class="form-select form-select-sm">
                            <option value="ALL" ${loaiSuCoFilter == 'ALL' ? 'selected' : ''}>-- Tất cả loại sự cố --</option>
                            <option value="Dien" ${loaiSuCoFilter == 'Dien' ? 'selected' : ''}>Điện</option>
                            <option value="Nuoc" ${loaiSuCoFilter == 'Nuoc' ? 'selected' : ''}>Nước</option>
                            <option value="ThangMay" ${loaiSuCoFilter == 'ThangMay' ? 'selected' : ''}>Thang máy</option>
                            <option value="PCCC" ${loaiSuCoFilter == 'PCCC' ? 'selected' : ''}>PCCC</option>
                            <option value="AnNinh" ${loaiSuCoFilter == 'AnNinh' ? 'selected' : ''}>An ninh</option>
                            <option value="VeSinh" ${loaiSuCoFilter == 'VeSinh' ? 'selected' : ''}>Vệ sinh</option>
                            <option value="Khac" ${loaiSuCoFilter == 'Khac' ? 'selected' : ''}>Khác</option>
                        </select>
                    </div>

                    <div class="col-md-4">
                        <label class="form-label font-semibold small text-muted">Mức Độ Ưu Tiên</label>
                        <select name="mucDoUuTien" class="form-select form-select-sm">
                            <option value="ALL" ${mucDoUuTienFilter == 'ALL' ? 'selected' : ''}>-- Tất cả mức độ --</option>
                            <option value="Cao" ${mucDoUuTienFilter == 'Cao' ? 'selected' : ''}>Cao (khẩn)</option>
                            <option value="TrungBinh" ${mucDoUuTienFilter == 'TrungBinh' ? 'selected' : ''}>Trung bình</option>
                            <option value="Thap" ${mucDoUuTienFilter == 'Thap' ? 'selected' : ''}>Thấp</option>
                        </select>
                    </div>

                    <div class="col-md-4">
                        <button type="submit" class="btn btn-sm btn-dark w-100 fw-bold">🔍 Lọc Công Việc</button>
                    </div>
                </form>
            </div>

            <!-- BẢNG DỮ LIỆU CÔNG VIỆC -->
            <div class="card-custom">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h5 class="fw-bold text-dark m-0">📋 Danh Sách Nhiệm Vụ Của Tôi (${totalItems} việc)</h5>
                    <small class="text-muted">Ưu tiên <strong>Cao</strong> xếp đầu | Sắp xếp <strong>cũ nhất trước</strong></small>
                </div>

                <c:choose>
                    <c:when test="${not empty dsCongViec}">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle">
                                <thead class="table-light">
                                    <tr>
                                        <th style="width: 60px;">ID</th>
                                        <th style="width: 110px;">Căn Hộ</th>
                                        <th>Tiêu Đề & Nội Dung Sự Cố</th>
                                        <th class="text-center" style="width: 110px;">Ưu Tiên</th>
                                        <th class="text-center" style="width: 120px;">Trạng Thái</th>
                                        <th class="text-center" style="width: 140px;">Thời Gian Báo</th>
                                        <th class="text-center" style="width: 150px;">Thao Tác Kỹ Thuật</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="item" items="${dsCongViec}">
                                        <tr>
                                            <td><strong>#${item.id}</strong></td>
                                            <td>
                                                <span class="fw-bold text-primary">${not empty item.soPhong ? item.soPhong : (not empty item.maCanHoCode ? item.maCanHoCode : 'Căn #'.concat(item.maCanHoId))}</span>
                                            </td>
                                            <td>
                                                <div><strong>${item.tieuDe}</strong></div>
                                                <small class="text-muted">📁 ${DisplayUtil.getLoaiSuCoText(item.loaiSuCo)} | Nguồn: ${item.nguonGui}</small>
                                            </td>
                                            <td class="text-center">
                                                <span class="badge ${DisplayUtil.getMucDoUuTienBadgeClass(item.mucDoUuTien)}">
                                                    ${DisplayUtil.getMucDoUuTienText(item.mucDoUuTien)}
                                                </span>
                                            </td>
                                            <td class="text-center">
                                                <span class="badge ${DisplayUtil.getTrangThaiSuCoBadgeClass(item.trangThai)}">
                                                    ${DisplayUtil.getTrangThaiSuCoText(item.trangThai)}
                                                </span>
                                            </td>
                                            <td class="text-center text-muted small">
                                                <div>${DisplayUtil.formatDate(item.ngayGui)}</div>
                                                <c:if test="${item.soNgayTroiQua > 0}">
                                                    <span class="badge bg-warning text-dark mt-1">⏳ ${item.soNgayTroiQua} ngày</span>
                                                </c:if>
                                            </td>
                                            <td class="text-center">
                                                <a href="${pageContext.request.contextPath}/kythuat/cong-viec/detail?id=${item.id}" class="btn btn-sm btn-primary fw-bold">
                                                    👁️ Chi Tiết & Xử Lý
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>

                        <!-- Pagination -->
                        <c:if test="${totalPages > 1}">
                            <nav class="mt-3">
                                <ul class="pagination justify-content-center mb-0">
                                    <c:forEach var="p" begin="1" end="${totalPages}">
                                        <li class="page-item ${p == currentPage ? 'active' : ''}">
                                            <a class="page-link" href="${pageContext.request.contextPath}/kythuat/cong-viec?page=${p}&loaiSuCo=${loaiSuCoFilter}&mucDoUuTien=${mucDoUuTienFilter}">${p}</a>
                                        </li>
                                    </c:forEach>
                                </ul>
                            </nav>
                        </c:if>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center py-5 text-muted">
                            🎉 Bạn hiện không có công việc nào đang chờ xử lý.
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
