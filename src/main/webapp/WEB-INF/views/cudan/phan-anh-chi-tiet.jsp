<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="util.DisplayUtil" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi Tiết Phản Ánh #${phanAnh.id} — Cư Dân Polybuilding</title>
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
        .card-custom { background: #FFF; border-radius: 12px; padding: 24px; border: 1px solid #DCE6E0; box-shadow: 0 4px 12px rgba(0,0,0,0.03); margin-bottom: 24px; }
        
        .timeline { border-left: 3px solid #2563EB; padding-left: 20px; margin-left: 10px; }
        .timeline-item { position: relative; margin-bottom: 20px; }
        .timeline-item::before { content: ''; position: absolute; left: -27px; top: 4px; width: 12px; height: 12px; background: #2563EB; border-radius: 50%; }
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
