<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="util.DisplayUtil" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Phản Ánh Sự Cố — Cư Dân Polybuilding</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        body { background-color: #F0F4F8; font-family: 'Be Vietnam Pro', sans-serif; }
        .app-layout { display: flex; min-height: 100vh; }
        .sidebar { width: 260px; background: #1B2A4A; color: #FFF; padding: 24px; flex-shrink: 0; }
        .sidebar-brand { font-family: 'Fraunces', serif; font-size: 1.15rem; font-weight: 700; color: #3B82F6; margin-bottom: 30px; display: flex; align-items: center; gap: 8px; }
        .sidebar-brand .mark { width: 10px; height: 10px; background: #3B82F6; transform: rotate(45deg); display: inline-block; }
        .sidebar-user { display: flex; align-items: center; gap: 12px; padding: 12px; background: rgba(255,255,255,0.08); border-radius: 8px; margin-bottom: 24px; }
        .sidebar-user .avatar { width: 38px; height: 38px; background: #2563EB; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 0.8rem; color: #FFF; }
        .sidebar-user .name { font-size: 0.9rem; font-weight: 600; display: block; color: #FFF; }
        .sidebar-user .role { font-size: 0.75rem; color: rgba(255,255,255,0.6); }
        .sidebar-nav { display: flex; flex-direction: column; gap: 6px; }
        .nav-item { display: flex; align-items: center; gap: 12px; padding: 12px 16px; color: rgba(255,255,255,0.75); text-decoration: none; border-radius: 6px; font-size: 0.9rem; font-weight: 500; transition: all 0.2s; }
        .nav-item:hover, .nav-item.active { background: #2563EB; color: #FFF; }
        .nav-divider { height: 1px; background: rgba(255,255,255,0.1); margin: 12px 0; }
        .main-wrapper { flex-grow: 1; display: flex; flex-direction: column; overflow-x: hidden; }
        .top-header { background: #FFF; padding: 18px 32px; border-bottom: 1px solid #DCE6E0; display: flex; justify-content: space-between; align-items: center; }
        .top-header h2 { font-family: 'Fraunces', serif; font-size: 1.4rem; color: #1B2A4A; margin: 0; }
        .top-header .sub { font-size: 0.82rem; color: #6C757D; }
        .content-body { padding: 32px; }
        .card-custom { background: #FFF; border-radius: 12px; padding: 24px; border: 1px solid #DCE6E0; box-shadow: 0 4px 12px rgba(0,0,0,0.03); }
    </style>
</head>
<body>

<div class="app-layout">
    <%@ include file="/WEB-INF/views/cudan/common/sidebar.jsp" %>

    <div class="main-wrapper">
        <%@ include file="/WEB-INF/views/cudan/common/header.jsp" %>

        <div class="content-body">
            <h4 class="text-dark fw-bold mb-4">🛠️ Phản Ánh & Báo Cáo Sự Cố Căn Hộ</h4>

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

            <div class="row g-4">
                <!-- FORM GỬI PHẢN ÁNH -->
                <div class="col-lg-4">
                    <div class="card-custom">
                        <h5 class="fw-bold mb-3 text-dark">✍️ Gửi Phản Ánh Mới</h5>
                        <form action="${pageContext.request.contextPath}/cudan/phan-anh" method="post" enctype="multipart/form-data">
                            <div class="mb-3">
                                <label class="form-label font-semibold">Tiêu Đề Phản Ánh <span class="text-danger">*</span></label>
                                <input type="text" name="tieuDe" class="form-control" placeholder="vd: Rò rỉ nước bồn rửa bếp" required>
                            </div>

                            <div class="mb-3">
                                <label class="form-label font-semibold">Loại Sự Cố <span class="text-danger">*</span></label>
                                <select name="loaiSuCo" class="form-select" required>
                                    <option value="Dien">⚡ Điện</option>
                                    <option value="Nuoc">💧 Nước</option>
                                    <option value="ThangMay">🛗 Thang máy</option>
                                    <option value="PCCC">🧯 PCCC</option>
                                    <option value="AnNinh">🛡️ An ninh</option>
                                    <option value="VeSinh">🧹 Vệ sinh</option>
                                    <option value="Khac" selected>📌 Khác</option>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label class="form-label font-semibold">Mức Độ Ưu Tiên</label>
                                <select name="mucDoUuTien" class="form-select">
                                    <option value="TrungBinh" selected>🟡 Trung bình</option>
                                    <option value="Cao">🔴 Cao (khẩn)</option>
                                    <option value="Thap">🟢 Thấp</option>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label class="form-label font-semibold">Mô Tả Chi Tiết <span class="text-danger">*</span></label>
                                <textarea name="moTa" class="form-control" rows="4" placeholder="Mô tả cụ thể vị trí, tình trạng sự cố..." required></textarea>
                            </div>

                            <div class="mb-3">
                                <label class="form-label font-semibold">Ảnh Hiện Trạng (Tùy chọn)</label>
                                <input type="file" name="anhTruocXuLy" class="form-control" accept="image/png, image/jpeg, image/jpg">
                                <div class="form-text text-muted">Chấp nhận JPG/PNG, tối đa 5MB.</div>
                            </div>

                            <button type="submit" class="btn btn-primary w-100 fw-bold py-2">📩 Gửi Báo Cáo Sự Cố</button>
                        </form>
                    </div>
                </div>

                <!-- DANH SÁCH PHẢN ÁNH ĐÃ GỬI -->
                <div class="col-lg-8">
                    <div class="card-custom">
                        <h5 class="fw-bold mb-3 text-dark">📋 Danh Sách Phản Ánh Của Căn Hộ</h5>
                        <c:choose>
                            <c:when test="${not empty danhSachPhanAnh}">
                                <div class="table-responsive">
                                    <table class="table table-hover align-middle">
                                        <thead class="table-light">
                                            <tr>
                                                <th style="width: 50px;">ID</th>
                                                <th>Tiêu Đề & Loại Sự Cố</th>
                                                <th class="text-center" style="width: 120px;">Ưu Tiên</th>
                                                <th class="text-center" style="width: 130px;">Trạng Thái</th>
                                                <th class="text-center" style="width: 140px;">Ngày Gửi</th>
                                                <th class="text-center" style="width: 130px;">Thao Tác</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="pa" items="${danhSachPhanAnh}">
                                                <tr>
                                                    <td><strong>#${pa.id}</strong></td>
                                                    <td>
                                                        <div><strong>${pa.tieuDe}</strong></div>
                                                        <small class="text-muted">📁 ${DisplayUtil.getLoaiSuCoText(pa.loaiSuCo)}</small>
                                                    </td>
                                                    <td class="text-center">
                                                        <span class="badge ${DisplayUtil.getMucDoUuTienBadgeClass(pa.mucDoUuTien)}">
                                                            ${DisplayUtil.getMucDoUuTienText(pa.mucDoUuTien)}
                                                        </span>
                                                    </td>
                                                    <td class="text-center">
                                                        <span class="badge ${DisplayUtil.getTrangThaiSuCoBadgeClass(pa.trangThai)}">
                                                            ${DisplayUtil.getTrangThaiSuCoText(pa.trangThai)}
                                                        </span>
                                                    </td>
                                                    <td class="text-center text-muted small">
                                                        ${DisplayUtil.formatDate(pa.ngayGui)}
                                                    </td>
                                                    <td class="text-center">
                                                        <div class="d-flex justify-content-center gap-1">
                                                            <a href="${pageContext.request.contextPath}/cudan/phan-anh/detail?id=${pa.id}" class="btn btn-sm btn-outline-primary fw-semibold">
                                                                👁️ Chi tiết
                                                            </a>
                                                            <c:if test="${pa.trangThai == 'MoiTiepNhan'}">
                                                                <form action="${pageContext.request.contextPath}/cudan/phan-anh/huy" method="post" class="d-inline" onsubmit="return confirm('Bạn có chắc chắn muốn HỦY phản ánh này không?');">
                                                                    <input type="hidden" name="id" value="${pa.id}">
                                                                    <button type="submit" class="btn btn-sm btn-outline-danger fw-semibold">✖️ Hủy</button>
                                                                </form>
                                                            </c:if>
                                                        </div>
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
                                                    <a class="page-link" href="${pageContext.request.contextPath}/cudan/phan-anh?page=${p}">${p}</a>
                                                </li>
                                            </c:forEach>
                                        </ul>
                                    </nav>
                                </c:if>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center py-5 text-muted">
                                    📭 Căn hộ của bạn chưa từng gửi phản ánh sự cố nào.
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
