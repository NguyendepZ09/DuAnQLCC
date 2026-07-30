<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="util.DisplayUtil" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/WEB-INF/views/common/head.jsp" %>
    <title>Tiếp Nhận & Điều Phối Sự Cố — Lễ Tân Polybuilding</title>

    <style>
body { background-color: var(--lt-bg, #F4EFE4); }
        .btn-teal { background-color: #1E3B34 !important; border-color: #1E3B34 !important; color: #FFF !important; }
        .btn-teal:hover { background-color: #152A25 !important; border-color: #152A25 !important; }
    </style>
</head>
<body>

<div class="app-layout">
    <%@ include file="/WEB-INF/views/letan/common/sidebar.jsp" %>

    <div class="main-wrapper">
        <%@ include file="/WEB-INF/views/letan/common/header.jsp" %>

        <div class="content-body">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h4 class="text-dark fw-bold m-0">🛠️ Tiếp Nhận & Điều Phối Sự Cố Toàn Tòa Nhà</h4>
                <button type="button" class="btn btn-teal text-white fw-bold py-2 px-3" style="background-color: #1E3B34;" data-bs-toggle="modal" data-bs-target="#modalCreateHo">
                    ✍️ Ghi Nhận Sự Cố Hộ Cư Dân
                </button>
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
                <form action="${pageContext.request.contextPath}/letan/su-co" method="get" class="row g-3 align-items-end">
                    <div class="col-md-2">
                        <label class="form-label font-semibold small text-muted">Trạng Thái</label>
                        <select name="trangThai" class="form-select form-select-sm">
                            <option value="ALL" ${trangThaiFilter == 'ALL' ? 'selected' : ''}>-- Tất cả --</option>
                            <option value="MoiTiepNhan" ${trangThaiFilter == 'MoiTiepNhan' ? 'selected' : ''}>Mới tiếp nhận</option>
                            <option value="DaTiepNhan" ${trangThaiFilter == 'DaTiepNhan' ? 'selected' : ''}>Đã tiếp nhận</option>
                            <option value="DangXuLy" ${trangThaiFilter == 'DangXuLy' ? 'selected' : ''}>Đang xử lý</option>
                            <option value="HoanThanh" ${trangThaiFilter == 'HoanThanh' ? 'selected' : ''}>Hoàn thành</option>
                            <option value="Huy" ${trangThaiFilter == 'Huy' ? 'selected' : ''}>Đã hủy</option>
                        </select>
                    </div>

                    <div class="col-md-2">
                        <label class="form-label font-semibold small text-muted">Loại Sự Cố</label>
                        <select name="loaiSuCo" class="form-select form-select-sm">
                            <option value="ALL" ${loaiSuCoFilter == 'ALL' ? 'selected' : ''}>-- Tất cả --</option>
                            <option value="Dien" ${loaiSuCoFilter == 'Dien' ? 'selected' : ''}>Điện</option>
                            <option value="Nuoc" ${loaiSuCoFilter == 'Nuoc' ? 'selected' : ''}>Nước</option>
                            <option value="ThangMay" ${loaiSuCoFilter == 'ThangMay' ? 'selected' : ''}>Thang máy</option>
                            <option value="PCCC" ${loaiSuCoFilter == 'PCCC' ? 'selected' : ''}>PCCC</option>
                            <option value="AnNinh" ${loaiSuCoFilter == 'AnNinh' ? 'selected' : ''}>An ninh</option>
                            <option value="VeSinh" ${loaiSuCoFilter == 'VeSinh' ? 'selected' : ''}>Vệ sinh</option>
                            <option value="Khac" ${loaiSuCoFilter == 'Khac' ? 'selected' : ''}>Khác</option>
                        </select>
                    </div>

                    <div class="col-md-2">
                        <label class="form-label font-semibold small text-muted">Mức Ưu Tiên</label>
                        <select name="mucDoUuTien" class="form-select form-select-sm">
                            <option value="ALL" ${mucDoUuTienFilter == 'ALL' ? 'selected' : ''}>-- Tất cả --</option>
                            <option value="Cao" ${mucDoUuTienFilter == 'Cao' ? 'selected' : ''}>Cao (khẩn)</option>
                            <option value="TrungBinh" ${mucDoUuTienFilter == 'TrungBinh' ? 'selected' : ''}>Trung bình</option>
                            <option value="Thap" ${mucDoUuTienFilter == 'Thap' ? 'selected' : ''}>Thấp</option>
                        </select>
                    </div>

                    <div class="col-md-2">
                        <label class="form-label font-semibold small text-muted">Từ Ngày</label>
                        <input type="date" name="tuNgay" class="form-control form-select-sm" value="${tuNgayFilter}">
                    </div>

                    <div class="col-md-2">
                        <label class="form-label font-semibold small text-muted">Đến Ngày</label>
                        <input type="date" name="denNgay" class="form-control form-select-sm" value="${denNgayFilter}">
                    </div>

                    <div class="col-md-2">
                        <button type="submit" class="btn btn-sm btn-dark w-100 fw-bold">🔍 Lọc Dữ Liệu</button>
                    </div>
                </form>
            </div>

            <!-- DANH SÁCH BẢNG PHẢN ÁNH SỰ CỐ -->
            <div class="card-custom">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h5 class="fw-bold text-dark m-0">📋 Danh Sách Phản Ánh Sự Cố (${totalItems} bản ghi)</h5>
                    <small class="text-muted">Ưu tiên <strong>Cao</strong> xếp đầu | Sắp xếp <strong>cũ nhất trước</strong></small>
                </div>

                <c:choose>
                    <c:when test="${not empty dsPhanAnh}">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle">
                                <thead class="table-light">
                                    <tr>
                                        <th style="width: 60px;">ID</th>
                                        <th style="width: 110px;">Căn Hộ</th>
                                        <th>Tiêu Đề & Phân Loại</th>
                                        <th class="text-center" style="width: 110px;">Ưu Tiên</th>
                                        <th class="text-center" style="width: 120px;">Trạng Thái</th>
                                        <th class="text-center" style="width: 140px;">Thời Gian Gửi</th>
                                        <th class="text-center" style="width: 140px;">Kỹ Thuật / Phụ Trách</th>
                                        <th class="text-center" style="width: 170px;">Thao Tác Lễ Tân</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="item" items="${dsPhanAnh}">
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
                                            <td class="text-center small">
                                                <c:choose>
                                                    <c:when test="${not empty item.tenNhanVien}">
                                                        <span class="fw-semibold text-dark">👨‍🔧 ${item.tenNhanVien}</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">Chưa giao</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-center">
                                                <div class="d-flex justify-content-center gap-1">
                                                    <a href="${pageContext.request.contextPath}/letan/su-co/detail?id=${item.id}" class="btn btn-sm btn-outline-primary fw-semibold" title="Xem chi tiết">
                                                        👁️
                                                    </a>

                                                    <!-- 1. NUT TIEP NHAN (MoiTiepNhan) -->
                                                    <c:if test="${item.trangThai == 'MoiTiepNhan'}">
                                                        <form action="${pageContext.request.contextPath}/letan/su-co/tiep-nhan" method="post" class="d-inline">
                                                            <input type="hidden" name="id" value="${item.id}">
                                                            <button type="submit" class="btn btn-sm btn-success fw-bold">📥 Tiếp nhận</button>
                                                        </form>
                                                    </c:if>

                                                    <!-- 2. NUT GIAO VIEC (DaTiepNhan hoac DangXuLy) -->
                                                    <c:if test="${item.trangThai == 'DaTiepNhan' || item.trangThai == 'DangXuLy'}">
                                                        <button type="button" class="btn btn-sm btn-warning fw-bold text-dark" data-bs-toggle="modal" data-bs-target="#modalGiaoViec_${item.id}">
                                                            👨‍🔧 Giao việc
                                                        </button>
                                                    </c:if>

                                                    <!-- 3. NUT HUY PHAN ANH -->
                                                    <c:if test="${item.trangThai != 'HoanThanh' && item.trangThai != 'Huy'}">
                                                        <button type="button" class="btn btn-sm btn-outline-danger fw-semibold" data-bs-toggle="modal" data-bs-target="#modalHuy_${item.id}">
                                                            🛑 Hủy
                                                        </button>
                                                    </c:if>
                                                </div>
                                            </td>
                                        </tr>

                                        <!-- MODAL GIAO VIEC -->
                                        <div class="modal fade" id="modalGiaoViec_${item.id}" tabindex="-1">
                                            <div class="modal-dialog">
                                                <div class="modal-content">
                                                    <form action="${pageContext.request.contextPath}/letan/su-co/giao-viec" method="post">
                                                        <input type="hidden" name="id" value="${item.id}">
                                                        <div class="modal-header bg-warning">
                                                            <h5 class="modal-title fw-bold text-dark">👨‍🔧 Giao Việc Xử Lý Sự Cố #${item.id}</h5>
                                                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                        </div>
                                                        <div class="modal-body">
                                                            <p class="mb-2"><strong>Sự cố:</strong> ${item.tieuDe} (${DisplayUtil.getLoaiSuCoText(item.loaiSuCo)})</p>
                                                            
                                                            <div class="mb-3">
                                                                <label class="form-label font-semibold">Chọn Nhân Viên Phụ Trách Xử Lý <span class="text-danger">*</span></label>
                                                                <select name="maNhanVienGiao" class="form-select" required>
                                                                    <option value="">-- Chọn nhân viên --</option>
                                                                    <optgroup label="🛠️ Bộ phận Kỹ thuật">
                                                                        <c:forEach var="nv" items="${dsNhanVien}">
                                                                            <c:if test="${nv.boPhan == 'KyThuat'}">
                                                                                <option value="${nv.id}" ${item.maNhanVien == nv.id ? 'selected' : ''}>[KT] ${nv.hoTen}</option>
                                                                            </c:if>
                                                                        </c:forEach>
                                                                    </optgroup>
                                                                    <optgroup label="🛡️ Bộ phận Bảo vệ">
                                                                        <c:forEach var="nv" items="${dsNhanVien}">
                                                                            <c:if test="${nv.boPhan == 'BaoVe'}">
                                                                                <option value="${nv.id}" ${item.maNhanVien == nv.id ? 'selected' : ''}>[BV] ${nv.hoTen}</option>
                                                                            </c:if>
                                                                        </c:forEach>
                                                                    </optgroup>
                                                                </select>
                                                                <div class="form-text text-muted">
                                                                    Gợi ý: Sự cố Điện/Nước/Thang máy → Kỹ thuật; An ninh/PCCC → Bảo vệ.
                                                                </div>
                                                            </div>

                                                            <div class="mb-3">
                                                                <label class="form-label font-semibold">Mức Độ Ưu Tiên Xử Lý</label>
                                                                <select name="mucDoUuTien" class="form-select">
                                                                    <option value="Cao" ${item.mucDoUuTien == 'Cao' ? 'selected' : ''}>🔴 Cao (khẩn)</option>
                                                                    <option value="TrungBinh" ${item.mucDoUuTien == 'TrungBinh' ? 'selected' : ''}>🟡 Trung bình</option>
                                                                    <option value="Thap" ${item.mucDoUuTien == 'Thap' ? 'selected' : ''}>🟢 Thấp</option>
                                                                </select>
                                                            </div>
                                                        </div>
                                                        <div class="modal-footer">
                                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                                                            <button type="submit" class="btn btn-warning fw-bold text-dark">🚀 Xác Nhận Giao Việc</button>
                                                        </div>
                                                    </form>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- MODAL HUY PHAN ANH -->
                                        <div class="modal fade" id="modalHuy_${item.id}" tabindex="-1">
                                            <div class="modal-dialog">
                                                <div class="modal-content">
                                                    <form action="${pageContext.request.contextPath}/letan/su-co/huy" method="post">
                                                        <input type="hidden" name="id" value="${item.id}">
                                                        <div class="modal-header bg-danger text-white">
                                                            <h5 class="modal-title fw-bold">🛑 Hủy Phản Ánh Sự Cố #${item.id}</h5>
                                                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                                                        </div>
                                                        <div class="modal-body">
                                                            <p class="mb-2"><strong>Sự cố:</strong> ${item.tieuDe}</p>
                                                            <div class="mb-3">
                                                                <label class="form-label font-semibold">Lý Do Hủy Phản Ánh <span class="text-danger">*</span></label>
                                                                <textarea name="lyDoHuy" class="form-control" rows="3" placeholder="vd: Phản ánh bị trùng, cư dân đã tự khắc phục..." required></textarea>
                                                            </div>
                                                        </div>
                                                        <div class="modal-footer">
                                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy bỏ</button>
                                                            <button type="submit" class="btn btn-danger fw-bold">🛑 Xác Nhận Hủy Phản Ánh</button>
                                                        </div>
                                                    </form>
                                                </div>
                                            </div>
                                        </div>
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
                                            <a class="page-link" href="${pageContext.request.contextPath}/letan/su-co?page=${p}&trangThai=${trangThaiFilter}&loaiSuCo=${loaiSuCoFilter}&mucDoUuTien=${mucDoUuTienFilter}&tuNgay=${tuNgayFilter}&denNgay=${denNgayFilter}">${p}</a>
                                        </li>
                                    </c:forEach>
                                </ul>
                            </nav>
                        </c:if>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center py-5 text-muted">
                            📭 Không tìm thấy phản ánh sự cố nào khớp với bộ lọc.
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<!-- MODAL GHI NHAN SU CO HO CU DAN -->
<div class="modal fade" id="modalCreateHo" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/letan/su-co/create-ho" method="post" enctype="multipart/form-data">
                <div class="modal-header bg-teal text-white" style="background-color: #1E3B34;">
                    <h5 class="modal-title fw-bold">✍️ Ghi Nhận Sự Cố Hộ Cư Dân (Lễ Tân Nhập Trực Tiếp)</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label font-semibold">Chọn Căn Hộ Báo Sự Cố <span class="text-danger">*</span></label>
                            <select name="maCanHo" class="form-select" required>
                                <option value="">-- Chọn căn hộ --</option>
                                <c:forEach var="ch" items="${dsCanHoDangO}">
                                    <option value="${ch.id}">[Phòng ${ch.soPhong}] - Mã ${ch.maCanHo} (Tầng ${ch.tang})</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-6">
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
                        <div class="col-md-6">
                            <label class="form-label font-semibold">Tiêu Đề Sự Cố <span class="text-danger">*</span></label>
                            <input type="text" name="tieuDe" class="form-control" placeholder="vd: Hỏng vòi xịt vệ sinh phòng 0101" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label font-semibold">Mức Độ Ưu Tiên</label>
                            <select name="mucDoUuTien" class="form-select">
                                <option value="TrungBinh" selected>🟡 Trung bình</option>
                                <option value="Cao">🔴 Cao (khẩn)</option>
                                <option value="Thap">🟢 Thấp</option>
                            </select>
                        </div>
                        <div class="col-12">
                            <label class="form-label font-semibold">Mô Tả Chi Tiết <span class="text-danger">*</span></label>
                            <textarea name="moTa" class="form-control" rows="3" placeholder="Ghi nhận thông tin phản ánh qua hotline hoặc tại quầy lễ tân..." required></textarea>
                        </div>
                        <div class="col-12">
                            <label class="form-label font-semibold">Ảnh Đính Kèm (Tùy chọn)</label>
                            <input type="file" name="anhTruocXuLy" class="form-control" accept="image/png, image/jpeg, image/jpg">
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy bỏ</button>
                    <button type="submit" class="btn btn-teal text-white fw-bold" style="background-color: #1E3B34;">📥 Tiếp Nhận Ngay</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
