<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/WEB-INF/views/common/head.jsp" %>
    <title>Phát Hành Thông Báo — Ban Quản Lý</title>

    <style>
body { background-color: #F4EFE4; font-family: 'Be Vietnam Pro', sans-serif; }
        .card-custom { background: #FFF; border-radius: 12px; padding: 24px; border: 1px solid #EAE3D2; box-shadow: 0 4px 12px rgba(0,0,0,0.03); }
    </style>
</head>
<body>

<div class="app-layout">
    <%@ include file="/WEB-INF/views/banquanly/common/sidebar.jsp" %>

    <div class="main-wrapper">
        <%@ include file="/WEB-INF/views/banquanly/common/header.jsp" %>

        <div class="content-body">
            <h4 class="text-dark fw-bold mb-4">📢 Phát Hành Thông Báo Toàn Tòa Nhà</h4>

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
                <!-- Create Notice Form -->
                <div class="col-md-5">
                    <div class="card-custom">
                        <h5 class="fw-bold mb-3 text-dark">✍️ Tạo Thông Báo Mới</h5>
                        <form action="${pageContext.request.contextPath}/banquanly/thong-bao" method="post">
                            <div class="mb-3">
                                <label class="form-label font-semibold">Tiêu Đề Thông Báo</label>
                                <input type="text" name="tieuDe" class="form-control" placeholder="vd: Bảo trì thang máy tháp A định kỳ" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label font-semibold">Loại Thông Báo</label>
                                <select name="loaiThongBao" class="form-select" required>
                                    <option value="ThongThuong" selected>ℹ️ Thông tin chung</option>
                                    <option value="BaoTri">🔧 Bảo trì / Sửa chữa</option>
                                    <option value="KhanCap">🚨 Khẩn cấp / Báo động</option>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label class="form-label font-semibold">Đối Tượng Nhận Thông Báo</label>
                                <select name="doiTuong" class="form-select" required>
                                    <option value="TatCa" selected>🌐 Toàn bộ (Cư dân & Nhân viên)</option>
                                    <option value="CuDan">🏠 Chỉ gửi Cư dân</option>
                                    <option value="NhanVien">👷 Chỉ gửi Nhân viên</option>
                                </select>
                                <div class="form-text text-muted small mt-1">Nhân viên sẽ nhận thông báo tại mục Thông báo trong giao diện bộ phận của mình.</div>
                            </div>
                            <div class="mb-3">
                                <label class="form-label font-semibold">Nội Dung Chi Tiết</label>
                                <textarea name="noiDung" class="form-control" rows="4" placeholder="Nhập nội dung chi tiết thông báo..." required></textarea>
                            </div>
                            <button type="submit" class="btn btn-warning w-100 fw-bold py-2 text-dark">🚀 Phát Hành Ngay</button>
                        </form>
                    </div>
                </div>

                <!-- Existing Notices List -->
                <div class="col-md-7">
                    <div class="card-custom">
                        <h5 class="fw-bold mb-3 text-dark">📜 Danh Sách Thông Báo Đã Đăng</h5>
                        <div class="table-responsive">
                            <table class="table table-hover align-middle">
                                <thead class="table-light">
                                    <tr>
                                        <th>ID</th>
                                        <th>Tiêu Đề</th>
                                        <th>Loại</th>
                                        <th>Đối Tượng</th>
                                        <th>Ngày Đăng</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="tb" items="${danhSachThongBao}">
                                        <tr>
                                            <td>${tb.id}</td>
                                            <td><strong>${tb.tieuDe}</strong></td>
                                            <td>
                                                <span class="badge ${tb.loaiThongBao == 'KhanCap' ? 'bg-danger' : (tb.loaiThongBao == 'BaoTri' ? 'bg-warning text-dark' : 'bg-secondary')}">
                                                    ${tb.loaiThongBao == 'KhanCap' ? 'Khẩn cấp' : (tb.loaiThongBao == 'BaoTri' ? 'Bảo trì' : 'Thông thường')}
                                                </span>
                                            </td>
                                            <td>
                                                <span class="badge bg-info text-dark">
                                                    ${tb.doiTuong == 'CuDan' ? 'Cư dân' : (tb.doiTuong == 'NhanVien' ? 'Nhân viên' : 'Toàn bộ')}
                                                </span>
                                            </td>
                                            <td class="text-muted small">${tb.ngayTao}</td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
