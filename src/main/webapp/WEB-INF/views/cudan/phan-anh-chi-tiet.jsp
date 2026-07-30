<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="util.DisplayUtil" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/WEB-INF/views/common/head.jsp" %>
    <title>Chi Tiết Phản Ánh #${phanAnh.id} — Cư Dân Polybuilding</title>

    <style>
.timeline { border-left: 3px solid #B98A46; padding-left: 20px; margin-left: 10px; }
        .timeline-item { position: relative; margin-bottom: 20px; }
        .timeline-item::before { content: ''; position: absolute; left: -27px; top: 4px; width: 12px; height: 12px; background: #B98A46; border-radius: 50%; }
    </style>
</head>
<body>

<div class="app-layout">
    <%@ include file="/WEB-INF/views/cudan/common/sidebar.jsp" %>

    <div class="main-wrapper">
        <%@ include file="/WEB-INF/views/cudan/common/header.jsp" %>

        <div class="content-body">
            <a href="${pageContext.request.contextPath}/cudan/phan-anh" class="btn btn-outline-secondary btn-sm mb-3">
                ← Quay lại danh sách phản ánh
            </a>

            <div class="row g-4">
                <!-- THÔNG TIN CHI TIẾT -->
                <div class="col-lg-7">
                    <div class="card-custom">
                        <div class="d-flex justify-content-between align-items-start mb-3">
                            <h4 class="fw-bold text-dark mb-0">🛠️ ${phanAnh.tieuDe}</h4>
                            <span class="badge fs-6 ${DisplayUtil.getTrangThaiSuCoBadgeClass(phanAnh.trangThai)}">
                                ${DisplayUtil.getTrangThaiSuCoText(phanAnh.trangThai)}
                            </span>
                        </div>

                        <div class="d-flex gap-2 mb-3">
                            <span class="badge bg-secondary">📁 ${DisplayUtil.getLoaiSuCoText(phanAnh.loaiSuCo)}</span>
                            <span class="badge ${DisplayUtil.getMucDoUuTienBadgeClass(phanAnh.mucDoUuTien)}">
                                Ưu tiên: ${DisplayUtil.getMucDoUuTienText(phanAnh.mucDoUuTien)}
                            </span>
                        </div>

                        <div class="p-3 bg-light rounded border mb-3">
                            <h6 class="fw-bold text-secondary mb-2">📄 Nội dung mô tả sự cố:</h6>
                            <p class="text-dark mb-0" style="white-space: pre-line;">${phanAnh.moTa}</p>
                        </div>

                        <div class="row g-3 text-secondary small mb-4">
                            <div class="col-md-6">
                                📅 <strong>Ngày gửi:</strong> ${DisplayUtil.formatDate(phanAnh.ngayGui)}
                            </div>
                            <div class="col-md-6">
                                👨‍🔧 <strong>Kỹ thuật phụ trách:</strong> ${not empty tenNhanVien ? tenNhanVien : 'Chưa phân công'}
                            </div>
                            <div class="col-md-6">
                                ✅ <strong>Ngày hoàn thành:</strong> ${phanAnh.ngayHoanThanh != null ? DisplayUtil.formatDate(phanAnh.ngayHoanThanh) : 'Chưa hoàn thành'}
                            </div>
                        </div>

                        <!-- HÌNH ẢNH SỰ CỐ -->
                        <h6 class="fw-bold text-dark mb-3">📷 Hình Ảnh Hiện Trạng & Xử Lý</h6>
                        <div class="row g-3">
                            <div class="col-md-6">
                                <div class="border rounded p-2 text-center bg-white">
                                    <small class="fw-bold text-muted d-block mb-2">Ảnh Trước Xử Lý (Cư dân gửi)</small>
                                    <c:choose>
                                        <c:when test="${not empty phanAnh.anhTruocXuLy}">
                                            <img src="${pageContext.request.contextPath}/${phanAnh.anhTruocXuLy}" class="img-fluid rounded border" style="max-height: 220px; object-fit: cover;" alt="Ảnh trước xử lý">
                                        </c:when>
                                        <c:otherwise>
                                            <div class="py-4 text-muted small">Chưa có ảnh đính kèm</div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="border rounded p-2 text-center bg-white">
                                    <small class="fw-bold text-muted d-block mb-2">Ảnh Sau Xử Lý (Kỹ thuật tải lên)</small>
                                    <c:choose>
                                        <c:when test="${not empty phanAnh.anhSauXuLy}">
                                            <img src="${pageContext.request.contextPath}/${phanAnh.anhSauXuLy}" class="img-fluid rounded border" style="max-height: 220px; object-fit: cover;" alt="Ảnh sau xử lý">
                                        </c:when>
                                        <c:otherwise>
                                            <div class="py-4 text-muted small">Chưa có ảnh hoàn thành</div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- DÒNG THỜI GIAN LỊCH SỬ XỬ LÝ -->
                <div class="col-lg-5">
                    <div class="card-custom">
                        <h5 class="fw-bold mb-4 text-dark">⏳ Tiến Trình & Lịch Sử Xử Lý</h5>
                        <c:choose>
                            <c:when test="${not empty lichSuList}">
                                <div class="timeline">
                                    <c:forEach var="ls" items="${lichSuList}">
                                        <div class="timeline-item">
                                            <div class="d-flex justify-content-between align-items-center mb-1">
                                                <span class="badge ${DisplayUtil.getTrangThaiSuCoBadgeClass(ls.trangThai)}">
                                                    ${DisplayUtil.getTrangThaiSuCoText(ls.trangThai)}
                                                </span>
                                                <small class="text-muted">${DisplayUtil.formatDate(ls.thoiGian)}</small>
                                            </div>
                                            <p class="text-dark small mb-0 fw-semibold">${ls.ghiChu}</p>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center py-4 text-muted">
                                    Chưa có tiến trình ghi nhận.
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
