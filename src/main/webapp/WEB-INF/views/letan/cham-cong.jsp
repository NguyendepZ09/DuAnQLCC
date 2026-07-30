<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="util.DisplayUtil" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/WEB-INF/views/common/head.jsp" %>
    <title>Chấm Công Của Tôi — PolyBuilding Lễ Tân</title>

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
















        .card-custom {
            background: var(--card-bg);
            border-radius: 12px;
            border: 1px solid var(--border);
            box-shadow: 0 2px 8px rgba(0,0,0,0.04);
            padding: 24px;
            margin-bottom: 25px;
        }

        .stat-card {
            background: #FFFFFF;
            border: 1px solid #EAE3D2;
            border-radius: 12px;
            padding: 18px;
            color: var(--text-dark);
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            min-height: 100px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.04);
        }

        .stat-card .number {
            font-size: 1.6rem;
            font-weight: 700;
            color: #1E3B34;
        }

        .stat-card .label {
            font-size: 0.82rem;
            color: #6C757D;
            font-weight: 600;
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

        <!-- 4 Thẻ Thống Kê Chấm Công Cá Nhân -->
        <div class="row g-3 mb-4">
            <div class="col-md-3">
                <div class="stat-card">
                    <span class="label">⏱️ Tổng Ca Làm Việc</span>
                    <span class="number">${thongKe.soNgayCong}</span>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card">
                    <span class="label">⏳ Tổng Giờ Làm Lũy Kế</span>
                    <span class="number">${thongKe.tongGioLam} giờ</span>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card">
                    <span class="label">☀️ Ca Sáng / 🌤️ Ca Chiều</span>
                    <span class="number">${thongKe.soCaSang} / ${thongKe.soCaChieu}</span>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card">
                    <span class="label">🌙 Ca Đêm (22:00-06:00)</span>
                    <span class="number">${thongKe.soCaDem}</span>
                </div>
            </div>
        </div>

        <!-- Bảng Nhật Ký Chấm Công -->
        <div class="card-custom">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h5 class="fw-bold m-0" style="color: var(--primary);">
                    ⏱️ Bảng Nhật Ký Chấm Công Cá Nhân
                </h5>
                <form action="${pageContext.request.contextPath}/letan/cham-cong" method="get" class="d-flex align-items-center gap-2">
                    <label class="form-label mb-0 small text-muted">Từ ngày:</label>
                    <input type="date" name="tuNgay" value="${tuNgayChon}" class="form-control form-control-sm w-auto">
                    <label class="form-label mb-0 small text-muted">Đến ngày:</label>
                    <input type="date" name="denNgay" value="${denNgayChon}" class="form-control form-control-sm w-auto">
                    <button type="submit" class="btn btn-sm btn-dark fw-semibold" style="background-color: var(--primary);">🔍 Lọc</button>
                </form>
            </div>

            <div class="table-responsive">
                <table class="table table-hover table-bordered table-custom align-middle">
                    <thead>
                    <tr>
                        <th class="text-center" style="width: 60px;">STT</th>
                        <th class="text-center">Ngày Làm</th>
                        <th class="text-center">Ca Làm</th>
                        <th class="text-center">Giờ Vào</th>
                        <th class="text-center">Giờ Ra</th>
                        <th class="text-end">Số Giờ Làm</th>
                        <th class="text-center">Trạng Thái</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%-- Comment NGOÀI c:choose --%>
                    <c:choose>
                        <c:when test="${not empty dsChamCong}">
                            <c:forEach var="row" items="${dsChamCong}" varStatus="loop">
                                <tr>
                                    <td class="text-center text-muted">${loop.index + 1}</td>
                                    <td class="text-center fw-bold text-primary">${row[0]}</td>
                                    <td class="text-center fw-semibold">
                                        <span class="badge ${row[1] == 'Sang' ? 'bg-warning text-dark' : (row[1] == 'Chieu' ? 'bg-info text-dark' : 'bg-dark')}">
                                            ${DisplayUtil.getCaTrucText(row[1])}
                                        </span>
                                    </td>
                                    <td class="text-center font-monospace fw-semibold">${not empty row[2] ? row[2] : '—'}</td>
                                    <td class="text-center font-monospace fw-semibold">${not empty row[3] ? row[3] : '—'}</td>
                                    <td class="text-end fw-bold">
                                        <c:choose>
                                            <c:when test="${not empty row[4]}">
                                                <span class="text-success">${row[4]} giờ</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted">—</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${row[5] == 'DangTruc'}">
                                                <span class="badge bg-success">🟢 Đang trực</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary">⚪ Hoàn thành</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="7" class="text-center text-muted py-4">Chưa có dữ liệu chấm công trong khoảng thời gian này.</td>
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
        // Màn hình xem nhật ký chấm công cá nhân (Chỉ đọc)
    });
</script>
</body>
</html>
