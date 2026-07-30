<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="util.DisplayUtil" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/WEB-INF/views/common/head.jsp" %>
    <title>Chi Tiết Hóa Đơn - PolyBuilding Cư Dân</title>

    <style>
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

        <div class="d-flex justify-content-between align-items-center mb-3">
            <a href="${pageContext.request.contextPath}/cudan/hoa-don" class="btn btn-outline-secondary btn-sm">
                ⬅️ Quay lại danh sách hóa đơn
            </a>

            <!-- 3b: Nút Thanh toán QR ở màn chi tiết nếu còn nợ -->
            <c:if test="${data.soConNo > 0}">
                <c:choose>
                    <c:when test="${data.hasPendingQR == true}">
                        <button type="button" 
                                class="btn btn-outline-warning text-dark fw-semibold btn-qr-trigger" 
                                data-id="${data.hoaDonId}">
                            🟡 Xem QR đã tạo
                        </button>
                    </c:when>
                    <c:otherwise>
                        <button type="button" 
                                class="btn btn-success fw-semibold btn-qr-trigger" 
                                data-id="${data.hoaDonId}">
                            📲 Thanh toán QR (${DisplayUtil.formatTien(data.soConNo)})
                        </button>
                    </c:otherwise>
                </c:choose>
            </c:if>
        </div>

        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show mb-3" role="alert">
                ⚠️ <strong>Lỗi:</strong> ${errorMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <div class="card-custom">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <div>
                    <h5 class="fw-bold m-0" style="color: var(--cd-sidebar);">
                        🧾 Chi Tiết Hóa Đơn Tháng ${data.thang}/${data.nam}
                    </h5>
                    <small class="text-muted">Căn hộ: Phòng ${data.soPhong} (Diện tích: ${data.dienTich} m²)</small>
                </div>
                <div>
                    <span class="badge fs-6 ${DisplayUtil.getTrangThaiThanhToanBadgeClass(data.trangThaiThanhToan)}">
                        ${DisplayUtil.getTrangThaiThanhToanText(data.trangThaiThanhToan)}
                    </span>
                </div>
            </div>

            <!-- Bảng Chi Tiết Các Món Tiền -->
            <div class="table-responsive mb-4">
                <table class="table table-bordered table-custom align-middle">
                    <thead>
                    <tr>
                        <th>Dịch Vụ</th>
                        <th class="text-center">Chỉ Số Cũ</th>
                        <th class="text-center">Chỉ Số Mới</th>
                        <th class="text-center">Số Lượng</th>
                        <th class="text-center">Đơn Vị</th>
                        <th class="text-end">Đơn Giá</th>
                        <th class="text-end">Thành Tiền</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="ct" items="${data.chiTietList}">
                        <tr>
                            <td class="fw-bold text-primary">
                                ${DisplayUtil.getLoaiDichVuText(ct.loaiDichVu)}
                            </td>
                            <td class="text-center">
                                <c:choose>
                                    <c:when test="${not empty ct.chiSoCu}">${ct.chiSoCu}</c:when>
                                    <c:otherwise><span class="text-muted">—</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td class="text-center">
                                <c:choose>
                                    <c:when test="${not empty ct.chiSoMoi}">${ct.chiSoMoi}</c:when>
                                    <c:otherwise><span class="text-muted">—</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td class="text-center fw-semibold">
                                <c:choose>
                                    <c:when test="${not empty ct.soLuong}">${ct.soLuong}</c:when>
                                    <c:otherwise><span class="text-muted">—</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td class="text-center text-muted">
                                ${DisplayUtil.getDonViTinhText(ct.donViTinh)}
                            </td>
                            <td class="text-end">
                                <c:choose>
                                    <c:when test="${not empty ct.donGia}">${DisplayUtil.formatTien(ct.donGia)}</c:when>
                                    <c:otherwise><span class="text-muted">—</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td class="text-end fw-bold text-success">
                                ${DisplayUtil.formatTienDouble(ct.thanhTien)}
                            </td>
                        </tr>
                        <!-- Dòng Diễn Giải (Bậc thang điện nước / cách tính) -->
                        <c:if test="${not empty ct.dienGiai}">
                            <tr class="table-light">
                                <td colspan="7" class="small text-muted ps-4 py-2">
                                    💡 <strong>Diễn giải chi tiết:</strong> <c:out value="${ct.dienGiai}"/>
                                </td>
                            </tr>
                        </c:if>
                    </c:forEach>
                    <tr class="table-warning fw-bold fs-6">
                        <td colspan="6" class="text-end text-dark">TỔNG CỘNG HÓA ĐƠN:</td>
                        <td class="text-end text-danger fs-5">${DisplayUtil.formatTienDouble(data.tongTien)}</td>
                    </tr>
                    <c:if test="${data.soConNo > 0}">
                        <tr class="table-danger fw-bold">
                            <td colspan="6" class="text-end text-danger">SỐ TIỀN CÒN NỢ PHẢI THANH TOÁN:</td>
                            <td class="text-end text-danger fs-5">${DisplayUtil.formatTien(data.soConNo)}</td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>
            </div>

            <!-- Bảng Lịch Sử Thanh Toán (3e: Hiển thị giao dịch QR, mã tham chiếu & trạng thái) -->
            <h6 class="fw-bold mb-3" style="color: var(--cd-sidebar);">
                💳 Lịch Sử Các Giao Dịch Thanh Toán Dành Cho Hóa Đơn Này
            </h6>
            <div class="table-responsive">
                <table class="table table-sm table-bordered align-middle">
                    <thead class="table-light">
                    <tr>
                        <th class="text-center">Mã GD</th>
                        <th class="text-center">Thời Gian</th>
                        <th class="text-end">Số Tiền</th>
                        <th class="text-center">Phương Thức</th>
                        <th>Mã Tham Chiếu / Nội Dung</th>
                        <th class="text-center">Trạng Thái</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${not empty data.giaoDichList}">
                            <c:forEach var="gd" items="${data.giaoDichList}">
                                <tr>
                                    <td class="text-center fw-bold">#<c:out value="${gd[0]}" /></td>
                                    <td class="text-center small"><c:out value="${gd[4]}" /></td>
                                    <td class="text-end fw-bold text-success">${DisplayUtil.formatTien(gd[1])}</td>
                                    <td class="text-center">
                                        <span class="badge ${gd[2] == 'QR' ? 'bg-warning text-dark' : 'bg-secondary'}">
                                            ${DisplayUtil.getPhuongThucText(gd[2])}
                                        </span>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty gd[5]}"><code class="fs-6 fw-bold"><c:out value="${gd[5]}" /></code></c:when>
                                            <c:otherwise><span class="text-muted">—</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-center">
                                        <span class="badge ${DisplayUtil.getTrangThaiGiaoDichBadgeClass(gd[3])}">
                                            ${DisplayUtil.getTrangThaiGiaoDichText(gd[3])}
                                        </span>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="6" class="text-center text-muted py-3">Chưa có giao dịch thanh toán nào được ghi nhận cho hóa đơn này.</td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
            </div>

            <!-- Dòng Hướng Dẫn Thanh Toán -->
            <div class="alert alert-info border-start border-4 border-info mt-4 mb-0">
                ℹ️ <strong>Hướng dẫn thanh toán:</strong> Cư dân có thể bấm nút <strong>"📲 Thanh Toán Qua Mã VietQR"</strong> ở trên để quét mã tự động nhập số tiền và nội dung chuyển khoản, hoặc thanh toán tiền mặt tại Văn phòng Kế toán.
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
