<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="util.DisplayUtil" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ca Trực & Bàn Giao — PolyBuilding</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        :root {
            --bv-bg: #F4EFE4;
            --bv-primary: #1E3B34;
            --bv-gold: #B98A46;
            --bv-card-bg: #FFFFFF;
            --bv-text: #2D3748;
            --bv-border: #EAE3D2;
        }

        body {
            background-color: var(--bv-bg);
            color: var(--bv-text);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            display: flex;
            min-height: 100vh;
        }

        .sidebar {
            width: 260px;
            background-color: var(--bv-primary);
            color: #FFFFFF;
            flex-shrink: 0;
            display: flex;
            flex-direction: column;
        }

        .sidebar-brand {
            padding: 20px;
            font-size: 1.2rem;
            font-weight: 700;
            color: var(--bv-gold);
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
            background-color: var(--bv-gold);
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
            color: #A0AEC0;
        }

        .sidebar-nav {
            padding: 15px 10px;
            display: flex;
            flex-direction: column;
            gap: 5px;
        }

        .nav-item {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 10px 15px;
            color: rgba(255, 255, 255, 0.8);
            text-decoration: none;
            border-radius: 8px;
            transition: all 0.2s;
            font-size: 0.95rem;
        }

        .nav-item:hover {
            background-color: rgba(255,255,255,0.1);
            color: #FFF;
        }

        .nav-item.active {
            background-color: var(--bv-gold);
            color: #FFF;
            font-weight: 600;
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
            border-bottom: 1px solid var(--bv-border);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .top-header h2 {
            margin: 0;
            font-size: 1.3rem;
            color: var(--bv-primary);
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
            background: var(--bv-card-bg);
            border-radius: 12px;
            border: 1px solid var(--bv-border);
            box-shadow: 0 2px 8px rgba(0,0,0,0.04);
            margin-bottom: 25px;
        }

        .card-custom .card-header-custom {
            padding: 15px 20px;
            border-bottom: 1px solid var(--bv-border);
            font-weight: 700;
            color: var(--bv-primary);
            background: rgba(30, 59, 52, 0.02);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
    </style>
</head>
<body>

    <!-- SIDEBAR -->
    <jsp:include page="/WEB-INF/views/baove/common/sidebar.jsp" />

    <!-- MAIN CONTENT -->
    <div class="main-content">
        <jsp:include page="/WEB-INF/views/baove/common/header.jsp" />

        <div class="content-body">
            
            <!-- MESSAGES -->
            <c:if test="${param.msg != null}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    ✅ <c:out value="${param.msg}"/>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            <c:if test="${param.error != null}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    ❌ <c:out value="${param.error}"/>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <!-- KHỐI A: CA TRỰC CỦA TÔI -->
            <div class="card-custom">
                <div class="card-header-custom">
                    <span>📋 KHỐI A — Nhật Ký Ca Trực Của Tôi (30 Ngày Gần Nhất)</span>
                    <button type="button" class="btn btn-sm btn-success" data-bs-toggle="modal" data-bs-target="#modalGhiCaTruc">
                        ➕ Ghi Nhật Ký Ca Trực Mới
                    </button>
                </div>
                <div class="card-body p-0">
                    <table class="table table-hover align-middle m-0">
                        <thead class="table-light">
                            <tr>
                                <th class="ps-3">STT</th>
                                <th>Ngày Trực</th>
                                <th>Ca Trực</th>
                                <th>Nội Dung Nhật Ký</th>
                                <th>Trạng Thái Bàn Giao</th>
                                <th>Người Nhận Ca</th>
                                <th class="pe-3">Thao Tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty caTrucCuaToiList}">
                                    <c:forEach var="row" items="${caTrucCuaToiList}" varStatus="loop">
                                        <tr>
                                            <td class="ps-3 fw-bold">${loop.count}</td>
                                            <td><c:out value="${row[9]}"/></td>
                                            <td>
                                                <span class="badge ${DisplayUtil.getCaTrucBadgeClass(row[1])}">
                                                    ${DisplayUtil.getCaTrucText(row[1])}
                                                </span>
                                            </td>
                                            <td><c:out value="${row[3]}"/></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${row[8] == true}">
                                                        <span class="badge bg-warning text-dark">Chưa bàn giao</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-success">Đã bàn giao</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty row[6]}">
                                                        👤 <c:out value="${row[6]}"/>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">—</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="pe-3">
                                                <c:choose>
                                                    <c:when test="${row[8] == true}">
                                                        <button type="button" 
                                                                class="btn btn-sm btn-outline-primary btn-ban-giao"
                                                                data-id="${row[0]}"
                                                                data-catruc="${DisplayUtil.getCaTrucText(row[1])}"
                                                                data-ngay="${row[9]}">
                                                            🤝 Bàn Giao Ca
                                                        </button>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted small">✓ Đã hoàn tất</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="7" class="text-center text-muted py-4">Bạn chưa ghi nhật ký ca trực nào trong 30 ngày gần đây.</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- KHỐI B: CA TRỰC CHỜ TÔI NHẬN -->
            <div class="card-custom">
                <div class="card-header-custom">
                    <span>🤝 KHỐI B — Danh Sách Ca Trực Được Bàn Giao Cho Tôi</span>
                </div>
                <div class="card-body p-0">
                    <table class="table table-hover align-middle m-0">
                        <thead class="table-light">
                            <tr>
                                <th class="ps-3">STT</th>
                                <th>Bảo Vệ Giao Ca</th>
                                <th>Ngày Trực</th>
                                <th>Ca Trực</th>
                                <th>Nội Dung Nhật Ký</th>
                                <th>Lưu Ý Bàn Giao</th>
                                <th>Thời Gian Bàn Giao</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty caChoNhanList}">
                                    <c:forEach var="row" items="${caChoNhanList}" varStatus="loop">
                                        <tr>
                                            <td class="ps-3 fw-bold">${loop.count}</td>
                                            <td class="fw-semibold">👤 <c:out value="${row[2]}"/></td>
                                            <td><c:out value="${row[8]}"/></td>
                                            <td>
                                                <span class="badge ${DisplayUtil.getCaTrucBadgeClass(row[3])}">
                                                    ${DisplayUtil.getCaTrucText(row[3])}
                                                </span>
                                            </td>
                                            <td><c:out value="${row[5]}"/></td>
                                            <td class="text-primary fw-semibold">
                                                <c:choose>
                                                    <c:when test="${not empty row[6]}">
                                                        📌 <c:out value="${row[6]}"/>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted font-normal">—</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td><c:out value="${row[9]}"/></td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="7" class="text-center text-muted py-4">Chưa có ca trực nào được bàn giao cho bạn.</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>

        </div>
    </div>

    <!-- MODAL GHI NHẬT KÝ CA TRỰC MỚI -->
    <div class="modal fade" id="modalGhiCaTruc" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <form action="${pageContext.request.contextPath}/baove/ca-truc/ghi" method="post">
                    <div class="modal-header">
                        <h5 class="modal-title fw-bold text-success">📝 Ghi Nhật Ký Ca Trực</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label fw-bold">Ca Trực:</label>
                            <select name="caTruc" class="form-select" required>
                                <option value="Sang">Ca sáng (06:00 - 14:00)</option>
                                <option value="Chieu">Ca chiều (14:00 - 22:00)</option>
                                <option value="Dem">Ca đêm (22:00 - 06:00)</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold">Ngày Trực:</label>
                            <input type="date" name="ngayTruc" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold">Nội Dung Nhật Ký Ca Trực:</label>
                            <textarea name="noiDung" class="form-control" rows="3" placeholder="Nhập tình hình an ninh, tuần tra trong ca trực..." required></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                        <button type="submit" class="btn btn-success">💾 Lưu Nhật Ký</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- MODAL BÀN GIAO CA -->
    <div class="modal fade" id="modalBanGiaoCa" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <form action="${pageContext.request.contextPath}/baove/ca-truc/ban-giao" method="post">
                    <input type="hidden" name="maCaTruc" id="modalCaTrucId">
                    <div class="modal-header">
                        <h5 class="modal-title fw-bold text-primary">🤝 Bàn Giao Ca Trực</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div class="alert alert-info py-2" id="modalCaTrucInfo">
                            <!-- Shift info filled by JS -->
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold">Bảo Vệ Nhận Ca:</label>
                            <select name="maNguoiNhanCa" class="form-select" required>
                                <option value="">-- Chọn Bảo Vệ Nhận Ca --</option>
                                <c:forEach var="nv" items="${dsBaoVeKhac}">
                                    <option value="${nv[0]}">${nv[1]} (${nv[2]})</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold">Lưu Ý Bàn Giao / Ghi Chú:</label>
                            <textarea name="luuYBanGiao" class="form-control" rows="3" placeholder="Ví dụ: Bàn giao bộ đàm, chìa khóa phòng máy, sổ giao ca..."></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                        <button type="submit" class="btn btn-primary">🤝 Xác Nhận Bàn Giao</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            // Set default date input in new shift modal to today
            const ngayTrucInput = document.querySelector('input[name="ngayTruc"]');
            if (ngayTrucInput && !ngayTrucInput.value) {
                const today = new Date().toISOString().split('T')[0];
                ngayTrucInput.value = today;
            }

            // Handover Modal event handling
            const banGiaoButtons = document.querySelectorAll('.btn-ban-giao');
            const modalEl = document.getElementById('modalBanGiaoCa');
            const inputCaId = document.getElementById('modalCaTrucId');
            const infoBox = document.getElementById('modalCaTrucInfo');

            if (banGiaoButtons && modalEl && inputCaId && infoBox) {
                const modal = new bootstrap.Modal(modalEl);
                banGiaoButtons.forEach(btn => {
                    btn.addEventListener('click', function () {
                        const id = this.getAttribute('data-id');
                        const caTruc = this.getAttribute('data-catruc');
                        const ngay = this.getAttribute('data-ngay');

                        if (id) {
                            inputCaId.value = id;
                            infoBox.innerHTML = '📌 <b>Bàn giao ca:</b> ' + (caTruc || '') + ' - Ngày: ' + (ngay || '');
                            modal.show();
                        }
                    });
                });
            }
        });
    </script>
</body>
</html>
