<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="util.DisplayUtil" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/WEB-INF/views/common/head.jsp" %>
    <title>Nhật Ký Tuần Tra — PolyBuilding</title>

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

















        .card-custom {
            background: var(--bv-card-bg);
            border-radius: 12px;
            border: 1px solid var(--bv-border);
            box-shadow: 0 2px 8px rgba(0,0,0,0.04);
            margin-bottom: 20px;
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

        /* Floor Grid Layout (Ordered Top 25 -> Bottom 1) */
        .floor-grid {
            display: grid;
            grid-template-columns: repeat(5, 1fr);
            gap: 10px;
        }

        .floor-card {
            border-radius: 8px;
            padding: 12px;
            text-align: center;
            font-weight: 700;
            font-size: 0.95rem;
            cursor: pointer;
            transition: transform 0.15s, box-shadow 0.15s;
        }

        .floor-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }

        .floor-scanned {
            background-color: #198754;
            color: #FFFFFF;
        }

        .floor-unscanned {
            background-color: #DC3545;
            color: #FFFFFF;
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

            <!-- LƯỚI 25 TẦNG TÒA NHÀ (TẦNG 25 Ở TRÊN, TẦNG 1 Ở DƯỚI) -->
            <div class="card-custom">
                <div class="card-header-custom">
                    <span>🏢 Trạng Thái Tuần Tra 25 Tầng Tòa Nhà (Trong 24H Qua)</span>
                    <div class="d-flex align-items-center gap-3">
                        <span class="badge bg-success">🟢 Đã quét (24h)</span>
                        <span class="badge bg-danger">🔴 Chưa quét (24h)</span>
                        <button type="button" class="btn btn-sm btn-success" data-bs-toggle="modal" data-bs-target="#modalGhiTuanTra">
                            ➕ Ghi Nhận Tuần Tra Mới
                        </button>
                    </div>
                </div>
                <div class="card-body p-3">
                    <p class="text-muted small mb-3">
                        <i>Ghi chú: Sơ đồ hiển thị từ Tầng 25 (trên cùng) xuống Tầng 1 (tầng trệt). Nhấp vào ô tầng để quét nhanh tầng đó.</i>
                    </p>

                    <div class="floor-grid">
                        <c:forEach var="i" begin="1" end="25">
                            <c:set var="floorNum" value="${26 - i}" />
                            <c:choose>
                                <c:when test="${tangChuaTuanTraSet.contains(floorNum)}">
                                    <div class="floor-card floor-unscanned btn-scan-floor" data-floor="${floorNum}">
                                        🏢 Tầng <c:out value="${floorNum}"/>
                                        <div class="small fw-normal text-white-50">Chưa quét</div>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="floor-card floor-scanned btn-scan-floor" data-floor="${floorNum}">
                                        🏢 Tầng <c:out value="${floorNum}"/>
                                        <div class="small fw-normal text-white-50">Đã quét 24h</div>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                    </div>
                </div>
            </div>

            <!-- BẢNG LƯỢT TUẦN TRA THEO NGÀY -->
            <div class="card-custom">
                <div class="card-header-custom">
                    <span>📋 Danh Sách Tuần Tra Trong Ngày</span>
                    <form action="${pageContext.request.contextPath}/baove/tuan-tra" method="get" class="d-flex gap-2">
                        <input type="date" name="ngay" class="form-control form-control-sm" value="${ngayChon}">
                        <button type="submit" class="btn btn-sm btn-secondary">🔍 Lọc</button>
                    </form>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle m-0">
                            <thead class="table-light">
                                <tr>
                                    <th class="ps-3">STT</th>
                                    <th>Tầng Tuần Tra</th>
                                    <th>Thời Gian Quét</th>
                                    <th>Ảnh Minh Chứng</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty tuanTraList}">
                                        <c:forEach var="row" items="${tuanTraList}" varStatus="loop">
                                            <tr>
                                                <td class="ps-3 fw-bold">${loop.count}</td>
                                                <td>
                                                    <span class="badge bg-primary fs-6">Tầng <c:out value="${row[1]}"/></span>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty row[2]}">
                                                            <c:out value="${DisplayUtil.formatDate(row[2])}"/>
                                                        </c:when>
                                                        <c:otherwise>—</c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty row[3]}">
                                                            <span class="text-muted small">📷 <c:out value="${row[3]}"/></span>
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
                                            <td colspan="4" class="text-center text-muted py-4">Không có lượt tuần tra nào trong ngày <c:out value="${ngayChon}"/>.</td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

        </div>
    </div>

    <!-- MODAL GHI NHẬN TUẦN TRA -->
    <div class="modal fade" id="modalGhiTuanTra" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <form action="${pageContext.request.contextPath}/baove/tuan-tra/ghi" method="post">
                    <div class="modal-header">
                        <h5 class="modal-title fw-bold text-success">🛡️ Ghi Nhận Tuần Tra Tầng</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label fw-bold">Chọn Tầng (1 -> 25):</label>
                            <select name="soTang" id="selectSoTang" class="form-select" required>
                                <option value="">-- Chọn Tầng --</option>
                                <c:forEach var="f" begin="1" end="25">
                                    <option value="${f}">Tầng ${f}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold">Tên File Ảnh Minh Chứng (Tùy chọn):</label>
                            <input type="text" name="anhMinhChung" class="form-control" placeholder="Ví dụ: assets/tuan-tra/tang05.jpg">
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                        <button type="submit" class="btn btn-success">💾 Lưu Kết Quả Quét</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const scanButtons = document.querySelectorAll('.btn-scan-floor');
            const selectSoTang = document.getElementById('selectSoTang');
            const modalEl = document.getElementById('modalGhiTuanTra');

            if (scanButtons && selectSoTang && modalEl) {
                const modal = new bootstrap.Modal(modalEl);
                scanButtons.forEach(btn => {
                    btn.addEventListener('click', function () {
                        const floor = this.getAttribute('data-floor');
                        if (floor) {
                            selectSoTang.value = floor;
                            modal.show();
                        }
                    });
                });
            }
        });
    </script>
</body>
</html>
