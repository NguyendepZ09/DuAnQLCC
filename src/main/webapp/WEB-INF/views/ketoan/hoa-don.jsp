<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="util.DisplayUtil" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Hóa Đơn - PolyBuilding Kế Toán</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        :root {
            --bg-primary: #1E3B34;
            --bg-accent: #B98A46;
            --bg-cream: #F4EFE4;
            --text-dark: #2C3E50;
        }
        body {
            background-color: var(--bg-cream);
            color: var(--text-dark);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .layout-wrapper {
            display: flex;
            min-height: 100vh;
        }
        .sidebar {
            width: 260px;
            background-color: var(--bg-primary);
            color: white;
            padding: 20px 0;
            flex-shrink: 0;
        }
        .sidebar-brand {
            padding: 0 20px 20px 20px;
            font-size: 1.1rem;
            font-weight: 700;
            color: var(--bg-accent);
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }
        .sidebar-brand .mark {
            display: inline-block;
            width: 10px;
            height: 10px;
            background-color: var(--bg-accent);
            border-radius: 50%;
            margin-right: 8px;
        }
        .sidebar-user {
            padding: 15px 20px;
            display: flex;
            align-items: center;
            gap: 12px;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }
        .sidebar-user .avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background-color: var(--bg-accent);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
        }
        .sidebar-user .name {
            font-weight: 600;
            font-size: 0.95rem;
            display: block;
        }
        .sidebar-user .role {
            font-size: 0.8rem;
            color: rgba(255,255,255,0.7);
        }
        .sidebar-nav {
            padding: 15px 0;
        }
        .nav-item {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px 20px;
            color: rgba(255,255,255,0.8);
            text-decoration: none;
            transition: all 0.2s;
        }
        .nav-item:hover, .nav-item.active {
            background-color: rgba(255,255,255,0.1);
            color: white;
            border-left: 4px solid var(--bg-accent);
        }
        .nav-divider {
            height: 1px;
            background-color: rgba(255,255,255,0.1);
            margin: 15px 0;
        }
        .main-content {
            flex-grow: 1;
            padding: 25px;
        }
        .top-header {
            background-color: white;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            margin-bottom: 25px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .top-header h2 {
            margin: 0;
            font-size: 1.4rem;
            color: var(--bg-primary);
            font-weight: 700;
        }
        .top-header .sub {
            font-size: 0.85rem;
            color: #6c757d;
        }
        .card-custom {
            background-color: white;
            border-radius: 12px;
            border: none;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            padding: 20px;
            margin-bottom: 25px;
        }
        .stat-card {
            border-radius: 12px;
            padding: 18px;
            color: white;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            min-height: 100px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        }
        .stat-card .number {
            font-size: 1.6rem;
            font-weight: 700;
        }
        .stat-card .label {
            font-size: 0.85rem;
            opacity: 0.9;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .table-custom th {
            background-color: #f8f9fa;
            color: var(--bg-primary);
            font-weight: 600;
        }
        .btn-gold {
            background-color: var(--bg-accent);
            color: white;
            border: none;
            font-weight: 600;
        }
        .btn-gold:hover {
            background-color: #a07639;
            color: white;
        }
        .btn-emerald {
            background-color: var(--bg-primary);
            color: white;
            border: none;
            font-weight: 600;
        }
        .btn-emerald:hover {
            background-color: #152b26;
            color: white;
        }
    </style>
</head>
<body>

<div class="layout-wrapper">
    <jsp:include page="/WEB-INF/views/ketoan/common/sidebar.jsp" />

    <div class="main-content">
        <jsp:include page="/WEB-INF/views/ketoan/common/header.jsp" />

        <c:if test="${not empty param.msg}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                ✅ <c:out value="${param.msg}" />
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <c:if test="${not empty param.error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                ❌ <c:out value="${param.error}" />
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Thẻ Thống Kê -->
        <div class="row g-3 mb-4">
            <div class="col-md-3">
                <div class="stat-card" style="background: linear-gradient(135deg, #1E3B34, #2d584e);">
                    <span class="label">📄 Tổng Số Hóa Đơn</span>
                    <span class="number">${stats.soHoaDon}</span>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card" style="background: linear-gradient(135deg, #0288d1, #03a9f4);">
                    <span class="label">💰 Tổng Phải Thu</span>
                    <span class="number">${DisplayUtil.formatTien(stats.tongPhaiThu)}</span>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card" style="background: linear-gradient(135deg, #2e7d32, #4caf50);">
                    <span class="label">✅ Đã Thanh Toán</span>
                    <span class="number">${DisplayUtil.formatTien(stats.tongDaThu)}</span>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card" style="background: linear-gradient(135deg, #c62828, #e53935);">
                    <span class="label">⚠️ Còn Nợ</span>
                    <span class="number">${DisplayUtil.formatTien(stats.tongConNo)}</span>
                </div>
            </div>
        </div>

        <!-- Khung Xuất Hóa Đơn Hàng Loạt -->
        <div class="card-custom border-start border-4 border-warning">
            <div class="d-flex justify-content-between align-items-center flex-wrap gap-3">
                <div>
                    <h5 class="fw-bold text-dark m-0">⚡ Xuất Hóa Đơn Hàng Loạt Cho Tất Cả Căn Hộ</h5>
                    <small class="text-muted">Hệ thống sẽ tự động tính Điện, Nước, Phí quản lý, Gửi xe & Tiện ích</small>
                </div>
                <form action="${pageContext.request.contextPath}/ketoan/hoa-don/xuat" method="post"
                      class="d-flex align-items-center gap-2"
                      onsubmit="return confirm('Bạn có chắc chắn muốn xuất hóa đơn hàng loạt cho kỳ được chọn?');">
                    <select name="thang" class="form-select w-auto">
                        <c:forEach var="m" begin="1" end="12">
                            <option value="${m}" ${m == (thang != null ? thang : 7) ? 'selected' : ''}>Tháng ${m}</option>
                        </c:forEach>
                    </select>
                    <select name="nam" class="form-select w-auto">
                        <c:forEach var="y" begin="2025" end="2027">
                            <option value="${y}" ${y == (nam != null ? nam : 2026) ? 'selected' : ''}>Năm ${y}</option>
                        </c:forEach>
                    </select>
                    <button type="submit" class="btn btn-gold text-nowrap">
                        🚀 Xuất Hóa Đơn
                    </button>
                </form>
            </div>
        </div>

        <!-- Bộ Lọc Danh Sách Hóa Đơn -->
        <div class="card-custom">
            <form action="${pageContext.request.contextPath}/ketoan/hoa-don" method="get" class="row g-3 align-items-center">
                <div class="col-md-3">
                    <label class="form-label fw-semibold">Tháng kỳ hóa đơn:</label>
                    <select name="thang" class="form-select">
                        <option value="ALL">-- Tất cả tháng --</option>
                        <c:forEach var="m" begin="1" end="12">
                            <option value="${m}" ${m == thang ? 'selected' : ''}>Tháng ${m}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-3">
                    <label class="form-label fw-semibold">Năm kỳ hóa đơn:</label>
                    <select name="nam" class="form-select">
                        <option value="ALL">-- Tất cả năm --</option>
                        <c:forEach var="y" begin="2025" end="2027">
                            <option value="${y}" ${y == nam ? 'selected' : ''}>Năm ${y}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-3">
                    <label class="form-label fw-semibold">Trạng thái thanh toán:</label>
                    <select name="trangThai" class="form-select">
                        <option value="ALL" ${'ALL' == trangThai ? 'selected' : ''}>-- Tất cả trạng thái --</option>
                        <option value="ChuaThanhToan" ${'ChuaThanhToan' == trangThai ? 'selected' : ''}>Chưa thanh toán</option>
                        <option value="DaThanhToan" ${'DaThanhToan' == trangThai ? 'selected' : ''}>Đã thanh toán</option>
                        <option value="QuaHan" ${'QuaHan' == trangThai ? 'selected' : ''}>Quá hạn</option>
                    </select>
                </div>
                <div class="col-md-3 d-flex align-items-end">
                    <button type="submit" class="btn btn-emerald w-100 py-2">
                        🔍 Lọc Danh Sách
                    </button>
                </div>
            </form>
        </div>

        <!-- Bảng Danh Sách Hóa Đơn -->
        <div class="card-custom">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h5 class="fw-bold m-0" style="color: var(--bg-primary);">
                    🧾 Danh Sách Hóa Đơn Chung Cư
                </h5>
                <span class="badge bg-secondary">Tìm thấy: ${hoaDonList != null ? hoaDonList.size() : 0} hóa đơn</span>
            </div>

            <div class="table-responsive">
                <table class="table table-hover table-bordered table-custom">
                    <thead>
                    <tr>
                        <th class="text-center">Mã HĐ</th>
                        <th class="text-center">Số Phòng</th>
                        <th>Chủ Hộ</th>
                        <th class="text-center">Kỳ Hóa Đơn</th>
                        <th class="text-end">Tổng Tiền</th>
                        <th class="text-center">Trạng Thái</th>
                        <th class="text-center">Thao Tác</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${not empty hoaDonList}">
                            <c:forEach var="row" items="${hoaDonList}">
                                <tr>
                                    <td class="text-center fw-bold">#<c:out value="${row[0]}" /></td>
                                    <td class="text-center fw-bold text-primary"><c:out value="${row[1]}" /></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty row[2]}"><c:out value="${row[2]}" /></c:when>
                                            <c:otherwise><span class="text-muted"><i>(Chưa xác định)</i></span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-center">Tháng <c:out value="${row[3]}" />/<c:out value="${row[4]}" /></td>
                                    <td class="text-end fw-bold text-success">
                                        ${DisplayUtil.formatTien(row[5])}
                                    </td>
                                    <td class="text-center">
                                        <span class="badge ${DisplayUtil.getTrangThaiThanhToanBadgeClass(row[6])}">
                                            ${DisplayUtil.getTrangThaiThanhToanText(row[6])}
                                        </span>
                                    </td>
                                    <td class="text-center">
                                        <a href="${pageContext.request.contextPath}/ketoan/hoa-don/chi-tiet?id=${row[0]}" class="btn btn-sm btn-outline-primary">
                                            👁️ Xem Chi Tiết
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="7" class="text-center text-muted py-4">Không tìm thấy hóa đơn nào khớp với bộ lọc.</td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
