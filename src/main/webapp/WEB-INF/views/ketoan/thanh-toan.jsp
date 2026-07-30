<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="util.DisplayUtil" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/WEB-INF/views/common/head.jsp" %>
    <title>Xác Nhận Thanh Toán - PolyBuilding Kế Toán</title>

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
        .card-custom {
            background-color: white;
            border-radius: 12px;
            border: none;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            padding: 25px;
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
        .btn-success {
            background-color: var(--bg-primary);
            color: white;
            border: none;
            font-weight: 600;
        }
        .btn-success:hover {
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
                ❌ <strong>Lỗi:</strong> <c:out value="${param.error}" />
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Thẻ Thống Kê -->
        <div class="row g-3 mb-4">
            <div class="col-md-3">
                <div class="stat-card" style="background: linear-gradient(135deg, #f57c00, #ff9800);">
                    <span class="label">⏳ Giao Dịch Chờ Xác Nhận</span>
                    <span class="number">${stats.soChoXacNhan}</span>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card" style="background: linear-gradient(135deg, #0288d1, #03a9f4);">
                    <span class="label">💵 Tiền Chờ Xác Nhận</span>
                    <span class="number">${DisplayUtil.formatTien(stats.tongChoXacNhan)}</span>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card" style="background: linear-gradient(135deg, #c62828, #e53935);">
                    <span class="label">🧾 Số HĐ Chưa Thu</span>
                    <span class="number">${stats.soHoaDonChuaThu}</span>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card" style="background: linear-gradient(135deg, #1E3B34, #2d584e);">
                    <span class="label">⚠️ Tổng Công Nợ</span>
                    <span class="number">${DisplayUtil.formatTien(stats.tongCongNo)}</span>
                </div>
            </div>
        </div>

        <!-- KHỐI A: GIAO DỊCH CHỜ XÁC NHẬN -->
        <div class="card-custom border-start border-4 border-warning">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h5 class="fw-bold m-0 text-warning-emphasis">
                    ⏳ KHỐI A — Danh Sách Giao Dịch Chờ Đối Soát & Xác Nhận
                </h5>
                <span class="badge bg-warning text-dark">Chờ xử lý: ${pendingList != null ? pendingList.size() : 0}</span>
            </div>

            <div class="table-responsive">
                <table class="table table-hover table-bordered table-custom align-middle">
                    <thead>
                    <tr>
                        <th class="text-center">Mã GD</th>
                        <th class="text-center">Số Phòng</th>
                        <th class="text-center">Kỳ Hóa Đơn</th>
                        <th class="text-end">Số Tiền</th>
                        <th class="text-center">Phương Thức</th>
                        <th>Mã GD Ngân Hàng</th>
                        <th class="text-center">Thời Gian Tạo</th>
                        <th class="text-center">Thao Tác</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${not empty pendingList}">
                            <c:forEach var="row" items="${pendingList}">
                                <tr>
                                    <td class="text-center fw-bold">#<c:out value="${row[0]}" /></td>
                                    <td class="text-center fw-bold text-primary"><c:out value="${row[1]}" /></td>
                                    <td class="text-center">Tháng <c:out value="${row[2]}" />/<c:out value="${row[3]}" /></td>
                                    <td class="text-end fw-bold text-success">
                                        ${DisplayUtil.formatTien(row[4])}
                                    </td>
                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${not empty row[10]}">
                                                <span class="badge bg-primary mb-1 d-block">📱 Cư dân tạo</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary mb-1 d-block">💼 Kế toán ghi nhận</span>
                                            </c:otherwise>
                                        </c:choose>
                                        <span class="badge ${row[5] == 'QR' ? 'bg-warning text-dark' : 'bg-info text-dark'}">
                                            ${DisplayUtil.getPhuongThucText(row[5])}
                                        </span>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty row[6]}">
                                                <code class="fs-6 fw-bold text-dark"><c:out value="${row[6]}" /></code>
                                            </c:when>
                                            <c:otherwise><span class="text-muted">—</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-center small text-muted">
                                        <c:out value="${row[7]}" />
                                    </td>
                                    <td class="text-center text-nowrap">
                                        <form action="${pageContext.request.contextPath}/ketoan/thanh-toan/xac-nhan" method="post" class="d-inline"
                                              onsubmit="return confirm('Xác nhận đã nhận đủ số tiền cho giao dịch #${row[0]}?');">
                                            <input type="hidden" name="id" value="${row[0]}">
                                            <button type="submit" class="btn btn-sm btn-success me-1">
                                                ✅ Xác Nhận
                                            </button>
                                        </form>
                                        <form action="${pageContext.request.contextPath}/ketoan/thanh-toan/tu-choi" method="post" class="d-inline"
                                              onsubmit="return confirm('Từ chối giao dịch #${row[0]}?');">
                                            <input type="hidden" name="id" value="${row[0]}">
                                            <button type="submit" class="btn btn-sm btn-outline-danger">
                                                ❌ Từ Chối
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="8" class="text-center text-muted py-3">Hiện không có giao dịch nào đang chờ xác nhận.</td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- KHỐI B: HÓA ĐƠN CHƯA THU -->
        <div class="card-custom">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h5 class="fw-bold m-0" style="color: var(--bg-primary);">
                    💳 KHỐI B — Danh Sách Hóa Đơn Chưa Thu / Còn Nợ
                </h5>
                <form action="${pageContext.request.contextPath}/ketoan/thanh-toan" method="get" class="d-flex gap-2">
                    <select name="thang" class="form-select form-select-sm w-auto">
                        <option value="ALL">-- Tất cả tháng --</option>
                        <c:forEach var="m" begin="1" end="12">
                            <option value="${m}" ${m == thang ? 'selected' : ''}>Tháng ${m}</option>
                        </c:forEach>
                    </select>
                    <select name="nam" class="form-select form-select-sm w-auto">
                        <option value="ALL">-- Tất cả năm --</option>
                        <c:forEach var="y" begin="2025" end="2027">
                            <option value="${y}" ${y == nam ? 'selected' : ''}>Năm ${y}</option>
                        </c:forEach>
                    </select>
                    <button type="submit" class="btn btn-sm btn-gold">🔍 Lọc</button>
                </form>
            </div>

            <div class="table-responsive">
                <table class="table table-hover table-bordered table-custom align-middle">
                    <thead>
                    <tr>
                        <th class="text-center">Mã HĐ</th>
                        <th class="text-center">Số Phòng</th>
                        <th>Chủ Hộ</th>
                        <th class="text-center">Kỳ HĐ</th>
                        <th class="text-end">Tổng Tiền</th>
                        <th class="text-end">Đã Trả</th>
                        <th class="text-end">Còn Nợ</th>
                        <th class="text-center">Trạng Thái</th>
                        <th class="text-center">Thao Tác</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${not empty unpaidList}">
                            <c:forEach var="row" items="${unpaidList}">
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
                                    <td class="text-end fw-bold">${DisplayUtil.formatTien(row[5])}</td>
                                    <td class="text-end text-success">${DisplayUtil.formatTien(row[6])}</td>
                                    <td class="text-end fw-bold text-danger">${DisplayUtil.formatTien(row[7])}</td>
                                    <td class="text-center">
                                        <span class="badge ${DisplayUtil.getTrangThaiThanhToanBadgeClass(row[8])}">
                                            ${DisplayUtil.getTrangThaiThanhToanText(row[8])}
                                        </span>
                                    </td>
                                    <td class="text-center">
                                        <button class="btn btn-sm btn-success"
                                                onclick="openPaymentModal(${row[0]}, '${row[1]}', '${row[7]}', '${row[5]}')">
                                            💳 Ghi Nhận Thanh Toán
                                        </button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="9" class="text-center text-muted py-4">Tất cả hóa đơn đã được thanh toán đầy đủ!</td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<!-- Modal Ghi Nhận Thanh Toán -->
<div class="modal fade" id="modalThanhToan" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/ketoan/thanh-toan/ghi-nhan" method="post">
                <div class="modal-header style-header text-white" style="background-color: var(--bg-primary);">
                    <h5 class="modal-title fw-bold text-white">💳 Ghi Nhận Thanh Toán Cho Hóa Đơn</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" name="maHoaDon" id="payMaHoaDon">

                    <div class="mb-3 p-3 bg-light rounded border">
                        <div class="row">
                            <div class="col-6">
                                <small class="text-muted d-block">Hóa đơn phòng:</small>
                                <strong class="fs-5 text-primary" id="paySoPhong">—</strong>
                            </div>
                            <div class="col-6 text-end">
                                <small class="text-muted d-block">Tổng hóa đơn:</small>
                                <strong class="fs-5 text-dark" id="payTongTien">—</strong>
                            </div>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Số tiền thanh toán (VNĐ):</label>
                        <input type="number" step="0.01" min="0" name="soTien" id="paySoTien" class="form-control fw-bold text-success fs-5" required>
                        <small class="text-muted d-block mt-1">Còn nợ: <span id="payConNoText" class="fw-bold text-danger">0đ</span> (Đã prefill để trả đủ một lần)</small>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Phương thức thanh toán:</label>
                        <select name="phuongThuc" id="payPhuongThuc" class="form-select" onchange="onPhuongThucChanged()">
                            <option value="TienMat">💵 Tiền mặt (Tự động Xác nhận Thành công ngay)</option>
                            <option value="ChuyenKhoan">🏦 Chuyển khoản ngân hàng (Chờ đối soát)</option>
                            <option value="QR">📱 Quét mã QR (Chờ đối soát)</option>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Mã giao dịch ngân hàng / Tham chiếu:</label>
                        <input type="text" name="maGiaoDichNganHang" id="payMaGD" class="form-control" placeholder="Ví dụ: FT260728123456 (nếu có)">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-gold">💾 Lưu Giao Dịch</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    let paymentModal;

    document.addEventListener('DOMContentLoaded', function() {
        paymentModal = new bootstrap.Modal(document.getElementById('modalThanhToan'));
    });

    function openPaymentModal(maHoaDon, soPhong, conNo, tongTien) {
        document.getElementById('payMaHoaDon').value = maHoaDon;
        document.getElementById('paySoPhong').innerText = "Phòng " + soPhong + " (#" + maHoaDon + ")";
        document.getElementById('payTongTien').innerText = Number(tongTien).toLocaleString('vi-VN') + "đ";
        document.getElementById('paySoTien').value = conNo;
        document.getElementById('payConNoText').innerText = Number(conNo).toLocaleString('vi-VN') + "đ";
        document.getElementById('payPhuongThuc').value = "TienMat";
        document.getElementById('payMaGD').value = "";
        paymentModal.show();
    }
</script>
</body>
</html>
