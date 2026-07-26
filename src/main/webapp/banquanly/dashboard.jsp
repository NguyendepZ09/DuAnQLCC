<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Bảng Thống Kê & Hiệu Suất — Ban Quản Lý</title>
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
        .stat-card { background: #FFF; border-radius: 12px; padding: 24px; border: 1px solid #DCE6E0; box-shadow: 0 4px 12px rgba(0,0,0,0.03); height: 100%; }
        .stat-card .title { font-size: 0.85rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.05em; color: #6C757D; margin-bottom: 12px; }
        .stat-card .value { font-family: 'Fraunces', serif; font-size: 1.8rem; color: #1E3B34; font-weight: 600; margin-bottom: 8px; }
    </style>
</head>
<body>

<div class="app-layout">
    <%@ include file="/banquanly/common/sidebar.jsp" %>

    <div class="main-wrapper">
        <%@ include file="/banquanly/common/header.jsp" %>

        <div class="content-body">
            <h4 class="mb-4 text-dark fw-bold">📊 Tổng Quan Tài Chính & Vận Hành Tòa Nhà</h4>

            <!-- Stat Cards Row -->
            <div class="row g-4 mb-4">
                <div class="col-md-3">
                    <div class="stat-card">
                        <div class="title">Tổng Doanh Thu Hóa Đơn</div>
                        <div class="value text-success">
                            <fmt:formatNumber value="${tongDoanhThu}" type="number" pattern="#,##0"/> VNĐ
                        </div>
                        <span class="badge bg-success">Tỷ lệ thu: ${tyLeThu}%</span>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card">
                        <div class="title">Đã Thanh Toán</div>
                        <div class="value text-primary">
                            <fmt:formatNumber value="${daThanhToan}" type="number" pattern="#,##0"/> VNĐ
                        </div>
                        <span class="badge bg-primary">Thu thực tế</span>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card">
                        <div class="title">Chưa Thanh Toán (Còn Nợ)</div>
                        <div class="value text-danger">
                            <fmt:formatNumber value="${chuaThanhToan}" type="number" pattern="#,##0"/> VNĐ
                        </div>
                        <span class="badge bg-danger">Cần nhắc phí</span>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card">
                        <div class="title">Nhân Viên Xuất Sắc Nhất</div>
                        <div class="value fs-5 text-warning fw-bold">${topNhanVien}</div>
                        <span class="badge bg-warning text-dark">⭐ Xử lý sự cố</span>
                    </div>
                </div>
            </div>

            <!-- Detailed Tables / Incident Status Breakdown -->
            <div class="row g-4">
                <div class="col-md-6">
                    <div class="stat-card">
                        <h5 class="fw-bold mb-3 text-dark">🛠️ Hiệu Suất Xử Lý Sự Cố Tòa Nhà</h5>
                        <table class="table table-hover align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th>Trạng Thái Sự Cố</th>
                                    <th>Số Lượng Phản Ánh</th>
                                    <th>Tiến Độ Xử Lý</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td><span class="badge bg-warning text-dark">Chờ tiếp nhận</span></td>
                                    <td><strong>${soCaCho}</strong> ca</td>
                                    <td><span class="text-warning font-monospace">Đang chờ Lễ tân phân công</span></td>
                                </tr>
                                <tr>
                                    <td><span class="badge bg-info text-dark">Đang xử lý</span></td>
                                    <td><strong>${soCaDangXuLy}</strong> ca</td>
                                    <td><span class="text-info font-monospace">Kỹ thuật viên đang làm</span></td>
                                </tr>
                                <tr>
                                    <td><span class="badge bg-success">Đã hoàn thành</span></td>
                                    <td><strong>${soCaHoanThanh}</strong> ca</td>
                                    <td><span class="text-success font-monospace">Đã nghiệm thu xong</span></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div class="col-md-6">
                    <div class="stat-card">
                        <h5 class="fw-bold mb-3 text-dark">💰 Tóm Tắt Dòng Tiền Phí Dịch Vụ</h5>
                        <div class="p-3 bg-light rounded border mb-3">
                            <div class="d-flex justify-content-between mb-2">
                                <span>Phí quản lý & dịch vụ chung:</span>
                                <strong>${tyLeThu}% đã thu</strong>
                            </div>
                            <div class="progress" style="height: 8px;">
                                <div class="progress-bar bg-success" style="width: ${tyLeThu}%;"></div>
                            </div>
                        </div>
                        <div class="p-3 bg-light rounded border">
                            <div class="d-flex justify-content-between mb-2">
                                <span>Phí điện nước & gửi xe:</span>
                                <strong>100% đúng hạn</strong>
                            </div>
                            <div class="progress" style="height: 8px;">
                                <div class="progress-bar bg-primary" style="width: 100%;"></div>
                            </div>
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
