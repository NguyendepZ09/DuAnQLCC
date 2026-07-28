<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="util.DisplayUtil" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Xử Lý Công Việc #${phanAnh.id} — Kỹ Thuật Polybuilding</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        body { background-color: #F8FAFC; font-family: 'Be Vietnam Pro', sans-serif; }
        .app-layout { display: flex; min-height: 100vh; }
        .sidebar { width: 260px; background: #1E293B; color: #FFF; padding: 24px; flex-shrink: 0; }
        .sidebar-brand { font-family: 'Fraunces', serif; font-size: 1.15rem; font-weight: 700; color: #F59E0B; margin-bottom: 30px; display: flex; align-items: center; gap: 8px; }
        .sidebar-brand .mark { width: 10px; height: 10px; background: #F59E0B; transform: rotate(45deg); display: inline-block; }
        .sidebar-user { display: flex; align-items: center; gap: 12px; padding: 12px; background: rgba(255,255,255,0.08); border-radius: 8px; margin-bottom: 24px; }
        .sidebar-user .avatar { width: 38px; height: 38px; background: #334155; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 0.8rem; color: #F59E0B; }
        .sidebar-user .name { font-size: 0.9rem; font-weight: 600; display: block; color: #FFF; }
        .sidebar-user .role { font-size: 0.75rem; color: rgba(255,255,255,0.6); }
        .sidebar-nav { display: flex; flex-direction: column; gap: 6px; }
        .nav-item { display: flex; align-items: center; gap: 12px; padding: 12px 16px; color: rgba(255,255,255,0.75); text-decoration: none; border-radius: 6px; font-size: 0.9rem; font-weight: 500; transition: all 0.2s; }
        .nav-item:hover, .nav-item.active { background: #334155; color: #F59E0B; }
        .nav-divider { height: 1px; background: rgba(255,255,255,0.1); margin: 12px 0; }
        .main-wrapper { flex-grow: 1; display: flex; flex-direction: column; overflow-x: hidden; }
        .top-header { background: #FFF; padding: 18px 32px; border-bottom: 1px solid #E2E8F0; display: flex; justify-content: space-between; align-items: center; }
        .top-header h2 { font-family: 'Fraunces', serif; font-size: 1.4rem; color: #1E293B; margin: 0; }
        .top-header .sub { font-size: 0.82rem; color: #64748B; }
        .content-body { padding: 32px; }
        .card-custom { background: #FFF; border-radius: 12px; padding: 24px; border: 1px solid #E2E8F0; box-shadow: 0 4px 12px rgba(0,0,0,0.03); margin-bottom: 24px; }

        .timeline { border-left: 3px solid #3B82F6; padding-left: 20px; margin-left: 10px; }
        .timeline-item { position: relative; margin-bottom: 20px; }
        .timeline-item::before { content: ''; position: absolute; left: -27px; top: 4px; width: 12px; height: 12px; background: #3B82F6; border-radius: 50%; }
    </style>
</head>
<body>

<div class="app-layout">
    <%@ include file="/WEB-INF/views/kythuat/common/sidebar.jsp" %>

    <div class="main-wrapper">
        <%@ include file="/WEB-INF/views/kythuat/common/header.jsp" %>

        <div class="content-body">
            <a href="${pageContext.request.contextPath}/kythuat/cong-viec" class="btn btn-outline-secondary btn-sm mb-3">
                ← Quay lại danh sách công việc được giao
            </a>

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
                <!-- KHU VỰC CHI TIẾT & THAO TÁC XỬ LÝ -->
                <div class="col-lg-7">
                    <div class="card-custom">
                        <div class="d-flex justify-content-between align-items-start mb-3">
                            <h4 class="fw-bold text-dark mb-0">🛠️ #${phanAnh.id} — ${phanAnh.tieuDe}</h4>
                            <span class="badge fs-6 ${DisplayUtil.getTrangThaiSuCoBadgeClass(phanAnh.trangThai)}">
                                ${DisplayUtil.getTrangThaiSuCoText(phanAnh.trangThai)}
                            </span>
                        </div>

                        <div class="d-flex gap-2 mb-3">
                            <span class="badge bg-secondary">📁 ${DisplayUtil.getLoaiSuCoText(phanAnh.loaiSuCo)}</span>
                            <span class="badge ${DisplayUtil.getMucDoUuTienBadgeClass(phanAnh.mucDoUuTien)}">
                                Ưu tiên: ${DisplayUtil.getMucDoUuTienText(phanAnh.mucDoUuTien)}
                            </span>
                            <span class="badge bg-light text-dark border">
                                Nguồn: ${phanAnh.nguonGui}
                            </span>
                        </div>

                        <!-- THÔNG TIN CĂN HỘ & NGƯỜI BÁO -->
                        <div class="p-3 bg-light rounded border mb-3">
                            <h6 class="fw-bold text-primary mb-2">🏠 Thông tin Căn hộ & Người báo:</h6>
                            <div class="row g-2 small">
                                <div class="col-md-6">
                                    <strong>Số phòng / Mã căn:</strong> ${not empty itemDetail.soPhong ? itemDetail.soPhong : (not empty itemDetail.maCanHoCode ? itemDetail.maCanHoCode : 'Căn #'.concat(phanAnh.maCanHo))}
                                </div>
                                <div class="col-md-6">
                                    <strong>Người báo sự cố:</strong> ${not empty itemDetail.tenCuDan ? itemDetail.tenCuDan : '(Lễ tân / Bảo vệ ghi nhận)'}
                                </div>
                                <div class="col-md-6">
                                    <strong>Số điện thoại:</strong> ${not empty itemDetail.sdtCuDan ? itemDetail.sdtCuDan : 'Chưa cập nhật'}
                                </div>
                                <div class="col-md-6">
                                    <strong>Thời gian báo:</strong> ${DisplayUtil.formatDate(phanAnh.ngayGui)}
                                </div>
                            </div>
                        </div>

                        <!-- MÔ TẢ & ẢNH HIỆN TRẠNG -->
                        <div class="p-3 bg-white rounded border mb-3">
                            <h6 class="fw-bold text-secondary mb-2">📄 Nội dung mô tả sự cố:</h6>
                            <p class="text-dark mb-0" style="white-space: pre-line;">${phanAnh.moTa}</p>
                        </div>

                        <div class="mb-4">
                            <h6 class="fw-bold text-dark mb-2">📷 Ảnh Hiện Trạng Trước Xử Lý:</h6>
                            <c:choose>
                                <c:when test="${not empty phanAnh.anhTruocXuLy}">
                                    <img src="${pageContext.request.contextPath}/${phanAnh.anhTruocXuLy}" class="img-fluid rounded border max-h-60" style="max-height: 250px; object-fit: cover;" alt="Ảnh trước xử lý">
                                </c:when>
                                <c:otherwise>
                                    <div class="p-3 bg-light rounded border text-muted small text-center">Không có ảnh đính kèm ban đầu</div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <hr class="my-4">

                        <!-- FORMS THAO TÁC CỦA KỸ THUẬT -->
                        <c:if test="${phanAnh.trangThai == 'DangXuLy'}">
                            <!-- FORM 1: CẬP NHẬT TIẾN ĐỘ GIỮA CHỪNG -->
                            <div class="p-3 border rounded bg-light mb-4">
                                <h6 class="fw-bold text-dark mb-2">📝 1. Cập Nhật Tiến Độ Giữa Chừng (Ghi chú nhật ký)</h6>
                                <form action="${pageContext.request.contextPath}/kythuat/cong-viec/cap-nhat-tien-do" method="post">
                                    <input type="hidden" name="id" value="${phanAnh.id}">
                                    <div class="mb-3">
                                        <textarea name="ghiChu" class="form-control" rows="2" placeholder="vd: Đã kiểm tra hỏng tụ điện, đang chờ đặt vật tư thay thế..." required></textarea>
                                    </div>
                                    <button type="submit" class="btn btn-sm btn-secondary fw-semibold">Ghi Nhận Tiến Độ</button>
                                </form>
                            </div>

                            <!-- FORM 2: HOÀN THÀNH VÀ NGHIỆM THU -->
                            <div class="p-3 border border-success rounded bg-success-subtle">
                                <h6 class="fw-bold text-success mb-2">✅ 2. Nghiệm Thu & Hoàn Thành Công Việc</h6>
                                <form action="${pageContext.request.contextPath}/kythuat/cong-viec/hoan-thanh" method="post" enctype="multipart/form-data">
                                    <input type="hidden" name="id" value="${phanAnh.id}">
                                    
                                    <div class="mb-3">
                                        <label class="form-label font-semibold">Tải Bắt Buộc Ảnh Nghiệm Thu Sau Xử Lý <span class="text-danger">*</span></label>
                                        <input type="file" name="anhSauXuLy" class="form-control" accept="image/png, image/jpeg, image/jpg" required>
                                        <div class="form-text">Bằng chứng hoàn thành sự cố (chỉ nhận .jpg, .png, tối đa 5MB).</div>
                                    </div>

                                    <div class="mb-3">
                                        <label class="form-label font-semibold">Ghi Chú Hoàn Thành / Báo Cáo Nghiệm Thu</label>
                                        <textarea name="ghiChu" class="form-control" rows="3" placeholder="vd: Đã thay mới công tắc và kiểm tra đường dây hoạt động bình thường."></textarea>
                                    </div>

                                    <button type="submit" class="btn btn-success fw-bold px-4">🚀 Báo Cáo Hoàn Thành Nhiệm Vụ</button>
                                </form>
                            </div>
                        </c:if>
                    </div>
                </div>

                <!-- DÒNG THỜI GIAN LỊCH SỬ XỬ LÝ -->
                <div class="col-lg-5">
                    <div class="card-custom">
                        <h5 class="fw-bold mb-4 text-dark">⏳ Dòng Thời Gian Nhật Ký Xử Lý</h5>
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
