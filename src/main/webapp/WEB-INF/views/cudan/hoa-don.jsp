<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="util.DisplayUtil" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/WEB-INF/views/common/head.jsp" %>
    <title>Hóa Đơn Của Tôi - PolyBuilding Cư Dân</title>

    <style>
.stat-card {
            border-radius: 12px;
            padding: 20px;
            color: white;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            min-height: 105px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        }
        .stat-card .number {
            font-size: 1.8rem;
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
            color: var(--cd-sidebar);
            font-weight: 600;
        }
    </style>
</head>
<body>

<div class="layout-wrapper">
    <jsp:include page="/WEB-INF/views/cudan/common/sidebar.jsp" />

    <div class="main-content">
        <jsp:include page="/WEB-INF/views/cudan/common/header.jsp" />

        <!-- 3 Thẻ Tổng Quan -->
        <div class="row g-3 mb-4">
            <div class="col-md-4">
                <div class="stat-card" style="background: linear-gradient(135deg, #1E3B34, #2d584e);">
                    <span class="label">📜 Tổng Số Hóa Đơn</span>
                    <span class="number">${tongSoHoaDon}</span>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stat-card" style="background: linear-gradient(135deg, #f57c00, #ff9800);">
                    <span class="label">⏳ Hóa Đơn Chưa Thanh Toán</span>
                    <span class="number">${soChuaThanhToan}</span>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stat-card" style="background: linear-gradient(135deg, #c62828, #e53935);">
                    <span class="label">⚠️ Tổng Công Nợ Còn Lại</span>
                    <span class="number">${DisplayUtil.formatTien(tongCongNo)}</span>
                </div>
            </div>
        </div>

        <!-- Bảng Hóa Đơn Căn Hộ -->
        <div class="card-custom">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h5 class="fw-bold m-0" style="color: var(--cd-sidebar);">
                    🧾 Danh Sách Hóa Đơn Căn Hộ Của Tôi
                </h5>
            </div>

            <div class="table-responsive">
                <table class="table table-hover table-bordered table-custom align-middle">
                    <thead>
                    <tr>
                        <th class="text-center">Kỳ Hóa Đơn</th>
                        <th class="text-end">Tổng Tiền</th>
                        <th class="text-end">Đã Thanh Toán</th>
                        <th class="text-end">Còn Nợ</th>
                        <th class="text-center">Trạng Thái</th>
                        <th class="text-center">Thao Tác</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${not empty hoaDonList}">
                            <c:forEach var="row" items="${hoaDonList}">
                                <c:set var="conNo" value="${row[6]}" />
                                <c:set var="countPendingQR" value="${row[7]}" />

                                <tr>
                                    <td class="text-center fw-bold text-primary">
                                        Tháng <c:out value="${row[1]}" />/<c:out value="${row[2]}" />
                                    </td>
                                    <td class="text-end fw-bold">${DisplayUtil.formatTienDouble(row[3])}</td>
                                    <td class="text-end text-success">${DisplayUtil.formatTien(row[5])}</td>
                                    <td class="text-end fw-bold text-danger">${DisplayUtil.formatTien(row[6])}</td>
                                    <td class="text-center">
                                        <span class="badge ${DisplayUtil.getTrangThaiThanhToanBadgeClass(row[4])}">
                                            ${DisplayUtil.getTrangThaiThanhToanText(row[4])}
                                        </span>
                                    </td>
                                    <td class="text-center">
                                        <div class="d-flex justify-content-center align-items-center gap-2">
                                            <a href="${pageContext.request.contextPath}/cudan/hoa-don/chi-tiet?id=${row[0]}"
                                               class="btn btn-sm btn-outline-primary fw-semibold">
                                                🔍 Chi Tiết
                                            </a>

                                            <%-- 3a & 3d: Nút hoặc badge Thanh Toán QR --%>
                                            <c:if test="${conNo > 0}">
                                                <c:choose>
                                                    <c:when test="${countPendingQR > 0}">
                                                        <button type="button" 
                                                                class="btn btn-sm btn-outline-warning text-dark fw-semibold btn-qr-trigger" 
                                                                data-id="${row[0]}">
                                                            🟡 Xem QR đã tạo
                                                        </button>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <button type="button" 
                                                                class="btn btn-sm btn-success fw-semibold btn-qr-trigger" 
                                                                data-id="${row[0]}">
                                                            📲 Thanh toán QR
                                                        </button>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:if>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="6" class="text-center text-muted py-4">Chưa có hóa đơn nào cho căn hộ của bạn.</td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<!-- MODAL THANH TOÁN VIETQR -->
<div class="modal fade" id="modalThanhToanQR" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content border-0 shadow-lg">
            <div class="modal-header bg-dark text-white" style="background-color: #1E3B34 !important;">
                <h5 class="modal-title fw-bold text-white">📲 Thanh Toán Qua Mã QR Ngân Hàng (VietQR)</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body p-4">
                <div id="qrLoading" class="text-center py-4" style="display: none;">
                    <div class="spinner-border text-success" role="status"></div>
                    <p class="mt-2 text-muted fw-semibold">Đang sinh mã QR VietQR tự động nhập số tiền...</p>
                </div>

                <div id="qrErrorAlert" class="alert alert-danger" style="display: none;"></div>

                <div id="qrContentBox" class="row g-4 align-items-center">
                    <!-- Cột Trái: Ảnh QR -->
                    <div class="col-md-5 text-center">
                        <div class="p-3 bg-light rounded border shadow-sm" id="qrImgContainer" style="display: inline-block;">
                            <img id="qrImg" src="" alt="Mã VietQR" class="img-fluid rounded" style="max-width: 240px; min-height: 240px;" onerror="handleQRError(this)">
                        </div>
                        <small class="text-muted d-block mt-2">📱 Dùng app Ngân hàng (MB, Vietcombank, Techcombank...) quét mã</small>
                    </div>

                    <!-- Cột Phải: Thông Tin Chi Tiết Chuyển Khoản -->
                    <div class="col-md-7">
                        <div class="card p-3 border-secondary bg-light">
                            <div class="mb-2">
                                <small class="text-muted text-uppercase fw-bold d-block">Ngân hàng thụ hưởng:</small>
                                <strong class="text-dark fs-6">VIETCOMBANK (Ngân hàng TMCP Ngoại Thương)</strong>
                            </div>
                            <div class="mb-2">
                                <small class="text-muted text-uppercase fw-bold d-block">Số tài khoản nhận:</small>
                                <div class="d-flex align-items-center justify-content-between">
                                    <span class="fs-5 fw-bold text-primary font-monospace" id="qrAccNo">1234567890</span>
                                    <button type="button" class="btn btn-sm btn-outline-primary" id="btnCopyAcc">📋 Sao chép</button>
                                </div>
                            </div>
                            <div class="mb-2">
                                <small class="text-muted text-uppercase fw-bold d-block">Chủ tài khoản:</small>
                                <strong class="text-dark" id="qrAccName">BAN QUAN LY CHUNG CU POLYBUILDING</strong>
                            </div>
                            <div class="mb-2">
                                <small class="text-muted text-uppercase fw-bold d-block">Số tiền thanh toán:</small>
                                <span class="fs-4 fw-bold text-danger" id="qrAmount">0đ</span>
                            </div>
                            <div>
                                <small class="text-muted text-uppercase fw-bold d-block">Nội dung chuyển khoản (Giữ nguyên):</small>
                                <div class="d-flex align-items-center justify-content-between bg-white p-2 rounded border border-warning">
                                    <span class="fs-5 fw-bold text-dark font-monospace" id="qrRefCode">PB...</span>
                                    <button type="button" class="btn btn-sm btn-warning text-dark fw-bold" id="btnCopyRef">📋 Sao chép</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="alert alert-warning border-warning mb-0 mt-3 small">
                    ℹ️ <strong>Lưu ý:</strong> Sau khi chuyển khoản, Kế toán sẽ đối soát và xác nhận trong vòng 24 giờ. Vui lòng <strong>giữ nguyên nội dung chuyển khoản</strong>.
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary fw-semibold" data-bs-dismiss="modal">Đóng</button>
            </div>
        </div>
    </div>
</div>

<span id="metaContextPath" data-path="${pageContext.request.contextPath}"></span>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function handleQRError(img) {
        img.style.display = 'none';
        const container = document.getElementById('qrImgContainer');
        if (container) {
            container.innerHTML = '<div class="alert alert-danger p-2 small m-0">⚠️ Không tải được hình ảnh mã QR do kết nối mạng. Vui lòng chuyển khoản thủ công theo thông tin số tài khoản bên cạnh.</div>';
        }
    }

    document.addEventListener('DOMContentLoaded', function () {
        const contextPath = document.getElementById('metaContextPath').getAttribute('data-path');
        const modalEl = document.getElementById('modalThanhToanQR');
        let bsModal = null;
        if (modalEl) {
            bsModal = new bootstrap.Modal(modalEl);
        }

        const qrTriggers = document.querySelectorAll('.btn-qr-trigger');
        qrTriggers.forEach(function (btn) {
            btn.addEventListener('click', function () {
                const maHoaDon = this.getAttribute('data-id');
                if (!maHoaDon) return;

                document.getElementById('qrLoading').style.display = 'block';
                document.getElementById('qrContentBox').style.display = 'none';
                document.getElementById('qrErrorAlert').style.display = 'none';
                bsModal.show();

                fetch(contextPath + '/cudan/hoa-don/thanh-toan-qr', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                        'X-Requested-With': 'XMLHttpRequest'
                    },
                    body: 'maHoaDon=' + encodeURIComponent(maHoaDon)
                })
                .then(function (res) { return res.json(); })
                .then(function (data) {
                    document.getElementById('qrLoading').style.display = 'none';
                    if (data.success) {
                        document.getElementById('qrContentBox').style.display = 'flex';
                        const img = document.getElementById('qrImg');
                        img.style.display = 'block';
                        img.src = data.qrUrl;

                        document.getElementById('qrAccNo').innerText = data.accountNo;
                        document.getElementById('qrAccName').innerText = data.accountName;
                        document.getElementById('qrAmount').innerText = data.soTienFormatted;
                        document.getElementById('qrRefCode').innerText = data.noiDungChuyenKhoan;
                    } else {
                        document.getElementById('qrErrorAlert').style.display = 'block';
                        document.getElementById('qrErrorAlert').innerText = data.loi || 'Không thể sinh mã QR.';
                    }
                })
                .catch(function (err) {
                    document.getElementById('qrLoading').style.display = 'none';
                    document.getElementById('qrErrorAlert').style.display = 'block';
                    document.getElementById('qrErrorAlert').innerText = 'Lỗi kết nối mạng: ' + err;
                });
            });
        });

        const btnCopyAcc = document.getElementById('btnCopyAcc');
        if (btnCopyAcc) {
            btnCopyAcc.addEventListener('click', function () {
                copyTextById('qrAccNo', this);
            });
        }

        const btnCopyRef = document.getElementById('btnCopyRef');
        if (btnCopyRef) {
            btnCopyRef.addEventListener('click', function () {
                copyTextById('qrRefCode', this);
            });
        }

        function copyTextById(targetId, btn) {
            const txt = document.getElementById(targetId).innerText;
            if (navigator.clipboard) {
                navigator.clipboard.writeText(txt).then(function () {
                    const oldTxt = btn.innerText;
                    btn.innerText = '✅ Đã chép!';
                    setTimeout(function () { btn.innerText = oldTxt; }, 2000);
                });
            } else {
                alert('Nội dung: ' + txt);
            }
        }
    });
</script>
</body>
</html>
