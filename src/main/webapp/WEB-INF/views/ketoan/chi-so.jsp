<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Ghi Chỉ Số Điện Nước - PolyBuilding Kế Toán</title>
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
        .table-custom {
            vertical-align: middle;
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

        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                ❌ <strong>Lỗi ghi nhận:</strong> <c:out value="${error}" />
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Form Lọc Kỳ -->
        <div class="card-custom">
            <form action="${pageContext.request.contextPath}/ketoan/chi-so" method="get" class="row g-3 align-items-center">
                <div class="col-auto">
                    <label class="fw-bold">📅 Chọn Kỳ Ghi Chỉ Số:</label>
                </div>
                <div class="col-auto">
                    <select name="thang" class="form-select">
                        <c:forEach var="m" begin="1" end="12">
                            <option value="${m}" ${m == thang ? 'selected' : ''}>Tháng ${m}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-auto">
                    <select name="nam" class="form-select">
                        <c:forEach var="y" begin="2025" end="2027">
                            <option value="${y}" ${y == nam ? 'selected' : ''}>Năm ${y}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-auto">
                    <button type="submit" class="btn btn-gold">🔍 Xem Kỳ Này</button>
                </div>
            </form>
        </div>

        <!-- Form Bảng Ghi Chỉ Số -->
        <div class="card-custom">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h5 class="fw-bold m-0" style="color: var(--bg-primary);">
                    ⚡ Danh Sách Căn Hộ Cần Ghi Chỉ Số (Tháng ${thang}/${nam})
                </h5>
                <span class="badge bg-secondary">Tổng: ${chiSoList != null ? chiSoList.size() : 0} căn hộ Đang Ở</span>
            </div>

            <form action="${pageContext.request.contextPath}/ketoan/chi-so/luu" method="post">
                <input type="hidden" name="thang" value="${thang}">
                <input type="hidden" name="nam" value="${nam}">

                <div class="table-responsive">
                    <table class="table table-hover table-bordered table-custom">
                        <thead>
                        <tr>
                            <th class="text-center">Số Phòng</th>
                            <th class="text-center">Diện Tích (m²)</th>
                            <th class="text-center">Điện Kỳ Trước (kWh)</th>
                            <th class="text-center" style="background-color: #e8f5e9;">⚡ Chỉ Số Điện Mới</th>
                            <th class="text-center">Nước Kỳ Trước (m³)</th>
                            <th class="text-center" style="background-color: #e3f2fd;">💧 Chỉ Số Nước Mới</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${not empty chiSoList}">
                                <c:forEach var="row" items="${chiSoList}">
                                    <tr>
                                        <td class="text-center fw-bold">
                                            <c:out value="${row[1]}" />
                                            <input type="hidden" name="maCanHo" value="${row[0]}">
                                            <input type="hidden" name="chiSoDienKyTruoc_${row[0]}" value="${row[5]}">
                                            <input type="hidden" name="chiSoNuocKyTruoc_${row[0]}" value="${row[6]}">
                                        </td>
                                        <td class="text-center"><c:out value="${row[2]}" /> m²</td>
                                        <td class="text-center text-muted">
                                            <c:choose>
                                                <c:when test="${not empty row[5]}"><c:out value="${row[5]}" /></c:when>
                                                <c:otherwise><i>(Kỳ đầu)</i></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td style="background-color: #f1f8e9;">
                                            <input type="number" step="0.01" min="0"
                                                   name="chiSoDien_${row[0]}"
                                                   value="${row[3]}"
                                                   class="form-control text-end fw-bold"
                                                   placeholder="Nhập số điện...">
                                        </td>
                                        <td class="text-center text-muted">
                                            <c:choose>
                                                <c:when test="${not empty row[6]}"><c:out value="${row[6]}" /></c:when>
                                                <c:otherwise><i>(Kỳ đầu)</i></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td style="background-color: #e1f5fe;">
                                            <input type="number" step="0.01" min="0"
                                                   name="chiSoNuoc_${row[0]}"
                                                   value="${row[4]}"
                                                   class="form-control text-end fw-bold"
                                                   placeholder="Nhập số nước...">
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="6" class="text-center text-muted py-4">Không có căn hộ nào đang ở.</td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>
                </div>

                <div class="d-flex justify-content-end mt-3">
                    <button type="submit" class="btn btn-emerald btn-lg px-4 py-2">
                        💾 Lưu Tất Cả Chỉ Số Tháng ${thang}/${nam}
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
