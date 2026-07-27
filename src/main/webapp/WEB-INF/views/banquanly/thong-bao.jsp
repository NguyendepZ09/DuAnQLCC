<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Phát Hành Thông Báo — Ban Quản Lý</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        body { background-color: #F4EFE4; font-family: 'Be Vietnam Pro', sans-serif; }
        .app-layout { display: flex; min-height: 100vh; }
        .sidebar { width: 260px; background: #1E3B34; color: #FFF; padding: 24px; flex-shrink: 0; }
        .sidebar-brand { font-family: 'Fraunces', serif; font-size: 1.15rem; font-weight: 700; color: #D9AE72; margin-bottom: 30px; display: flex; align-items: center; gap: 8px; }
        .sidebar-brand .mark { width: 10px; height: 10px; background: #D9AE72; transform: rotate(45deg); display: inline-block; }
        .sidebar-user { display: flex; align-items: center; gap: 12px; padding: 12px; background: rgba(255,255,255,0.08); border-radius: 8px; margin-bottom: 24px; }
        .sidebar-user .avatar { width: 38px; height: 38px; background: #B98A46; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 0.8rem; }
        .sidebar-user .name { font-size: 0.9rem; font-weight: 600; display: block; }
        .sidebar-user .role { font-size: 0.75rem; color: rgba(255,255,255,0.6); }
        .sidebar-nav { display: flex; flex-direction: column; gap: 6px; }
        .nav-item { display: flex; align-items: center; gap: 12px; padding: 12px 16px; color: rgba(255,255,255,0.75); text-decoration: none; border-radius: 6px; font-size: 0.9rem; font-weight: 500; transition: all 0.2s; }
        .nav-item:hover, .nav-item.active { background: #B98A46; color: #FFF; }
        .nav-divider { height: 1px; background: rgba(255,255,255,0.1); margin: 12px 0; }
        .main-wrapper { flex-grow: 1; display: flex; flex-direction: column; overflow-x: hidden; }
        .top-header { background: #FFF; padding: 18px 32px; border-bottom: 1px solid #DCE6E0; display: flex; justify-content: space-between; align-items: center; }
        .top-header h2 { font-family: 'Fraunces', serif; font-size: 1.4rem; color: #1E3B34; margin: 0; }
        .top-header .sub { font-size: 0.82rem; color: #6C757D; }
        .content-body { padding: 32px; }
        .card-custom { background: #FFF; border-radius: 12px; padding: 24px; border: 1px solid #DCE6E0; box-shadow: 0 4px 12px rgba(0,0,0,0.03); }
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
                                    <option value="Bảo trì">🔧 Bảo trì / Sửa chữa</option>
                                    <option value="Sự kiện">🎉 Sự kiện / Hoạt động</option>
                                    <option value="Khẩn cấp">🚨 Khẩn cấp / Báo động</option>
                                    <option value="Thông thường" selected>ℹ️ Thông tin chung</option>
                                </select>
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
                                        <th>Ngày Đăng</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="tb" items="${danhSachThongBao}">
                                        <tr>
                                            <td>${tb.id}</td>
                                            <td><strong>${tb.tieuDe}</strong></td>
                                            <td><span class="badge bg-secondary">${tb.loaiThongBao}</span></td>
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
