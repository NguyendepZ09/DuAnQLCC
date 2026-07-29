<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="util.DisplayUtil" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Duyệt Đặt Tiện Ích — PolyBuilding Lễ Tân</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        :root {
            --primary: #1E3B34;
            --accent: #B98A46;
            --bg-cream: #F4EFE4;
            --card-bg: #FFFFFF;
            --text-dark: #2C3E50;
            --border: #EAE3D2;
        }

        body {
            background-color: var(--bg-cream);
            color: var(--text-dark);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            display: flex;
            min-height: 100vh;
        }

        .sidebar {
            width: 260px;
            background-color: var(--primary);
            color: #FFFFFF;
            flex-shrink: 0;
            display: flex;
            flex-direction: column;
        }

        .sidebar-brand {
            padding: 20px;
            font-size: 1.15rem;
            font-weight: 700;
            color: var(--accent);
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }

        .sidebar-user {
            padding: 15px 20px;
            display: flex;
            align-items: center;
            gap: 12px;
            border-bottom: 1px solid rgba(255,255,255,0.1);
            background-color: rgba(0,0,0,0.1);
        }

        .sidebar-user .avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background-color: var(--accent);
            color: #FFF;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
        }

        .sidebar-user .name {
            font-weight: 600;
            font-size: 0.95rem;
            display: block;
        }

        .sidebar-user .role {
            font-size: 0.75rem;
            color: rgba(255,255,255,0.7);
        }

        .sidebar-nav {
            padding: 15px 0;
            display: flex;
            flex-direction: column;
            gap: 4px;
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
            border-left: 4px solid var(--accent);
        }

        .nav-divider {
            height: 1px;
            background-color: rgba(255,255,255,0.1);
            margin: 10px 0;
        }

        .main-content {
            flex-grow: 1;
            display: flex;
            flex-direction: column;
        }

        .top-header {
            background-color: #FFFFFF;
            padding: 15px 30px;
            border-bottom: 1px solid var(--border);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .top-header h2 {
            margin: 0;
            font-size: 1.3rem;
            color: var(--primary);
            font-weight: 700;
        }

        .top-header .sub {
            font-size: 0.85rem;
            color: #718096;
        }

        .content-body {
            padding: 25px 30px;
        }

        .card-custom {
            background: var(--card-bg);
            border-radius: 12px;
            border: 1px solid var(--border);
            box-shadow: 0 2px 8px rgba(0,0,0,0.04);
            padding: 24px;
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
            font-size: 0.82rem;
            opacity: 0.9;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .table-custom th {
            background-color: #f8f9fa;
            color: var(--primary);
            font-weight: 600;
        }
    </style>
</head>
<body>

<jsp:include page="/WEB-INF/views/letan/common/sidebar.jsp" />

<div class="main-content">
    <jsp:include page="/WEB-INF/views/letan/common/header.jsp" />

    <div class="content-body">

        <c:if test="${not empty param.msg}">
            <div class="alert alert-success alert-dismissible fade show mb-4" role="alert">
                ✅ <c:out value="${param.msg}" />
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <c:if test="${not empty param.error}">
            <div class="alert alert-danger alert-dismissible fade show mb-4" role="alert">
                ❌ <strong>Lỗi:</strong> <c:out value="${param.error}" />
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- 4 Thẻ Thống Kê Lượt Đặt Tiện Ích -->
        <div class="row g-3 mb-4">
            <div class="col-md-3">
                <div class="stat-card" style="background: linear-gradient(135deg, #f57c00, #ff9800);">
                    <span class="label">⏳ Lượt Chờ Duyệt</span>
                    <span class="number">${soChoDuyet}</span>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card" style="background: linear-gradient(135deg, #1E3B34, #2d584e);">
                    <span class="label">✅ Lượt Đã Duyệt</span>
                    <span class="number">${soDaDuyet}</span>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card" style="background: linear-gradient(135deg, #0288d1, #03a9f4);">
                    <span class="label">🏁 Đã Hoàn Thành (Đã Dùng)</span>
                    <span class="number">${soHoanThanh}</span>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card" style="background: linear-gradient(135deg, #757575, #9e9e9e);">
                    <span class="label">🚫 Lượt Đã Hủy / Từ Chối</span>
                    <span class="number">${soDaHuy}</span>
                </div>
            </div>
        </div>

        <!-- Bảng Duyệt Đặt Tiện Ích -->
        <div class="card-custom">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h5 class="fw-bold m-0" style="color: var(--primary);">
                    🏊 Danh Sách Đăng Ký Sử Dụng Tiện Ích Cư Dân
                </h5>

                <!-- Bộ Lọc Trạng Thái & Ngày -->
                <form action="${pageContext.request.contextPath}/letan/duyet-tien-ich" method="get" class="d-flex align-items-center gap-2">
                    <select name="trangThai" class="form-select form-select-sm w-auto fw-semibold">
                        <option value="ALL" ${trangThaiChon == 'ALL' ? 'selected' : ''}>-- Tất cả trạng thái --</option>
                        <option value="ChoDuyet" ${trangThaiChon == 'ChoDuyet' ? 'selected' : ''}>⏳ Chờ duyệt (${soChoDuyet})</option>
                        <option value="DaDuyet" ${trangThaiChon == 'DaDuyet' ? 'selected' : ''}>✅ Đã duyệt (${soDaDuyet})</option>
                        <option value="HoanThanh" ${trangThaiChon == 'HoanThanh' ? 'selected' : ''}>🏁 Đã hoàn thành (${soHoanThanh})</option>
                        <option value="DaHuy" ${trangThaiChon == 'DaHuy' ? 'selected' : ''}>🚫 Đã hủy (${soDaHuy})</option>
                    </select>

                    <input type="date" name="tuNgay" value="${tuNgayChon}" class="form-control form-control-sm w-auto" placeholder="Từ ngày">
                    <input type="date" name="denNgay" value="${denNgayChon}" class="form-control form-control-sm w-auto" placeholder="Đến ngày">

                    <button type="submit" class="btn btn-sm btn-dark fw-semibold" style="background-color: var(--primary);">🔍 Lọc</button>
                </form>
            </div>

            <div class="table-responsive">
                <table class="table table-hover table-bordered table-custom align-middle">
                    <thead>
                    <tr>
                        <th class="text-center" style="width: 50px;">Mã</th>
                        <th>Tiện Ích</th>
                        <th class="text-center">Số Phòng</th>
                        <th>Cư Dân Đặt</th>
                        <th class="text-center">Ngày Đặt</th>
                        <th class="text-center">Khung Giờ</th>
                        <th class="text-end">Giá Tiền</th>
                        <th class="text-center">Trạng Thái</th>
                        <th class="text-center">Thao Tác</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%-- Comment NGOÀI c:choose --%>
                    <c:choose>
                        <c:when test="${not empty dsLuotDat}">
                            <c:forEach var="row" items="${dsLuotDat}">
                                <tr>
                                    <td class="text-center fw-bold">#<c:out value="${row[0]}" /></td>
                                    <td class="fw-bold text-primary"><c:out value="${row[1]}" /></td>
                                    <td class="text-center fw-bold text-success"><c:out value="${row[2]}" /></td>
                                    <td><c:out value="${row[3]}" /></td>
                                    <td class="text-center fw-semibold"><c:out value="${row[4]}" /></td>
                                    <td class="text-center font-monospace fw-bold"><c:out value="${row[5]}" /></td>
                                    <td class="text-end fw-bold text-danger">${DisplayUtil.formatTien(row[6])}</td>
                                    <td class="text-center">
                                        <span class="badge ${DisplayUtil.getTrangThaiDatLichBadgeClass(row[7])}">
                                            ${DisplayUtil.getTrangThaiDatLichText(row[7])}
                                        </span>
                                    </td>
                                    <td class="text-center text-nowrap">
                                        <%-- Cờ Java: coTheDuyet (row[8]), coTheTuChoi (row[9]), coTheHoanThanh (row[10]) --%>
                                        <c:choose>
                                            <c:when test="${row[8] == true}">
                                                <form action="${pageContext.request.contextPath}/letan/duyet-tien-ich/duyet" method="post" class="d-inline"
                                                      onsubmit="return confirm('Xác nhận duyệt lượt đặt tiện ích #${row[0]} cho phòng ${row[2]}?');">
                                                    <input type="hidden" name="id" value="${row[0]}">
                                                    <button type="submit" class="btn btn-sm btn-success me-1">
                                                        ✅ Duyệt
                                                    </button>
                                                </form>
                                                <form action="${pageContext.request.contextPath}/letan/duyet-tien-ich/tu-choi" method="post" class="d-inline"
                                                      onsubmit="return confirm('Từ chối lượt đặt tiện ích #${row[0]} của phòng ${row[2]}?');">
                                                    <input type="hidden" name="id" value="${row[0]}">
                                                    <button type="submit" class="btn btn-sm btn-outline-danger">
                                                        ❌ Từ chối
                                                    </button>
                                                </form>
                                            </c:when>
                                            <c:when test="${row[10] == true}">
                                                <form action="${pageContext.request.contextPath}/letan/duyet-tien-ich/hoan-thanh" method="post" class="d-inline"
                                                      onsubmit="return confirm('Xác nhận cư dân phòng ${row[2]} ĐÃ SỬ DỤNG xong lượt đặt #${row[0]}?');">
                                                    <input type="hidden" name="id" value="${row[0]}">
                                                    <button type="submit" class="btn btn-sm btn-primary">
                                                        🏁 Xác nhận đã dùng
                                                    </button>
                                                </form>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted">—</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="9" class="text-center text-muted py-4">Không có lượt đặt tiện ích nào theo điều kiện lọc hiện tại.</td>
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
<script>
    document.addEventListener('DOMContentLoaded', function () {
        // Màn hình Duyệt Đặt Tiện Ích - Lễ Tân PolyBuilding
    });
</script>
</body>
</html>
