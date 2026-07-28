<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="util.DisplayUtil" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đặt Tiện Ích — Cư Dân Polybuilding</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/role-cudan.css">
    <style>
        .amenity-card {
            border: 1px solid var(--cd-border);
            border-radius: 12px;
            transition: all 0.2s ease-in-out;
            height: 100%;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            background: #ffffff;
        }
        .amenity-card:hover {
            box-shadow: 0 8px 20px rgba(0,0,0,0.08);
            transform: translateY(-2px);
        }
        .amenity-card.disabled-card {
            opacity: 0.55;
            background-color: #f8f9fa;
        }
        .table-custom th {
            background-color: #f8f9fa;
            color: var(--cd-sidebar);
            font-weight: 600;
        }
    </style>
</head>
<body>

<div class="app-layout">
    <%@ include file="/WEB-INF/views/cudan/common/sidebar.jsp" %>

    <div class="main-wrapper">
        <%@ include file="/WEB-INF/views/cudan/common/header.jsp" %>

        <div class="content-body">
            <h4 class="text-dark fw-bold mb-4">🏊 Đặt Lịch Dịch Vụ & Tiện Ích Tòa Nhà</h4>

            <!-- ALERTS THÔNG BÁO -->
            <c:set var="msgAlert" value="${not empty param.msg ? param.msg : (not empty msg ? msg : successMessage)}" />
            <c:set var="errAlert" value="${not empty param.error ? param.error : (not empty param.err ? param.err : (not empty error ? error : errorMessage))}" />

            <c:if test="${not empty msgAlert}">
                <div class="alert alert-success alert-dismissible fade show mb-4" role="alert">
                    ✅ <strong>Thành công:</strong> <c:out value="${msgAlert}" />
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <c:if test="${not empty errAlert}">
                <div class="alert alert-danger alert-dismissible fade show mb-4" role="alert">
                    ❌ <strong>Lỗi:</strong> <c:out value="${errAlert}" />
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <c:set var="amenityList" value="${not empty amenities ? amenities : danhSachTienIch}" />
            <c:set var="daDatList" value="${not empty historyList ? historyList : danhSachDaDat}" />

            <!-- KHỐI A: DANH SÁCH TIỆN ÍCH -->
            <div class="card-custom mb-4">
                <h5 class="fw-bold mb-3" style="color: var(--cd-sidebar);">
                    🏊 KHỐI A — Danh Sách Tiện Ích Tòa Nhà
                </h5>
                <div class="row g-4">
                    <c:choose>
                        <c:when test="${not empty amenityList}">
                            <c:forEach var="t" items="${amenityList}">
                                <c:set var="isHoatDong" value="${'HoatDong'.equalsIgnoreCase(t.trangThaiHoatDong)}" />
                                <div class="col-md-4">
                                    <div class="amenity-card p-3 ${!isHoatDong ? 'disabled-card' : ''}">
                                        <div>
                                            <div class="d-flex justify-content-between align-items-center mb-2">
                                                <h6 class="fw-bold m-0 text-primary fs-5"><c:out value="${t.tenTienIch}" /></h6>
                                                <c:choose>
                                                    <c:when test="${isHoatDong}">
                                                        <span class="badge bg-success">Đang hoạt động</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary">${DisplayUtil.getTrangThaiTienIchText(t.trangThaiHoatDong)}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <p class="text-muted small mb-3"><c:out value="${t.moTa}" default="Không có mô tả" /></p>

                                            <ul class="list-unstyled small text-secondary mb-3">
                                                <li>👥 <strong>Sức chứa:</strong> <c:out value="${t.sucChua}" default="—" /> người</li>
                                                <li>⏰ <strong>Giờ mở cửa:</strong> <c:out value="${t.gioMoCua}" default="06:00" /> - <c:out value="${t.gioDongCua}" default="22:00" /></li>
                                                <li>💰 <strong>Giá đặt:</strong> <span class="fw-bold text-success fs-6">${DisplayUtil.formatTien(t.giaThueMacDinh)}</span> / lượt (1h)</li>
                                            </ul>
                                        </div>

                                        <div>
                                            <c:choose>
                                                <c:when test="${isHoatDong}">
                                                    <button type="button" class="btn btn-primary w-100 py-2 fw-semibold btn-dat-lich"
                                                            data-id="${t.id}"
                                                            data-ten="<c:out value='${t.tenTienIch}'/>"
                                                            data-gia="${DisplayUtil.formatTien(t.giaThueMacDinh)}"
                                                            data-mo="<c:out value='${t.gioMoCua}'/>"
                                                            data-dong="<c:out value='${t.gioDongCua}'/>">
                                                        ➕ Đặt Lịch Ngay
                                                    </button>
                                                </c:when>
                                                <c:otherwise>
                                                    <button type="button" class="btn btn-secondary w-100 py-2" disabled>
                                                        ⛔ ${DisplayUtil.getTrangThaiTienIchText(t.trangThaiHoatDong)}
                                                    </button>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="col-12 text-center text-muted py-4">Chưa có tiện ích nào trong danh mục.</div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- VỊ TRÍ AN TOÀN CHO JS SCRIPTS: NGAY SAU KHỐI A, TRƯỚC KHỐI B -->
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
            <script>
                document.addEventListener('DOMContentLoaded', function() {
                    const bookingModalEl = document.getElementById('modalBooking');
                    if (!bookingModalEl) return;
                    const bookingModal = new bootstrap.Modal(bookingModalEl);

                    const nut = document.querySelectorAll('.btn-dat-lich');
                    console.log('Đã gắn sự kiện cho ' + nut.length + ' nút đặt lịch');

                    nut.forEach(function(btn) {
                        btn.addEventListener('click', function() {
                            const id = btn.dataset.id;
                            const ten = btn.dataset.ten || 'Tiện ích';
                            const gia = btn.dataset.gia || '0đ';
                            let openTime = btn.dataset.mo || '06:00';
                            let closeTime = btn.dataset.dong || '22:00';

                            document.getElementById('bookMaTienIch').value = id;
                            document.getElementById('bookTenTienIch').innerText = ten;
                            document.getElementById('bookGiaTien').innerText = gia;

                            if (openTime.length >= 5) openTime = openTime.substring(0, 5);
                            if (closeTime.length >= 5) closeTime = closeTime.substring(0, 5);

                            let openHour = parseInt(openTime.split(':')[0], 10);
                            let closeHour = parseInt(closeTime.split(':')[0], 10);

                            if (isNaN(openHour)) openHour = 6;
                            if (isNaN(closeHour)) closeHour = 22;
                            if (closeHour <= openHour) closeHour = 22;

                            const selectSlot = document.getElementById('bookKhungGio');
                            selectSlot.innerHTML = '<option value="">-- Chọn khung giờ --</option>';

                            for (let h = openHour; h < closeHour; h++) {
                                let startStr = (h < 10 ? '0' : '') + h + ":00";
                                let endStr = ((h + 1) < 10 ? '0' : '') + (h + 1) + ":00";
                                let slotVal = startStr + "-" + endStr;

                                let opt = document.createElement('option');
                                opt.value = slotVal;
                                opt.innerText = "Khung giờ " + slotVal;
                                selectSlot.appendChild(opt);
                            }

                            bookingModal.show();
                        });
                    });
                });
            </script>

            <!-- KHỐI B: LỊCH ĐÃ ĐẶT CỦA CĂN HỘ TÔI (ĐƯỢC BỌC C:CATCH BẢO VỆ) -->
            <div class="card-custom">
                <h5 class="fw-bold mb-3" style="color: var(--cd-sidebar);">
                    📋 KHỐI B — Danh Sách Tiện Ích Đã Đặt Của Căn Hộ Tôi
                </h5>
                <c:catch var="loiKhoiB">
                    <div class="table-responsive">
                        <table class="table table-hover table-bordered table-custom align-middle">
                            <thead>
                            <tr>
                                <th class="text-center">Mã Lượt</th>
                                <th>Tên Tiện Ích</th>
                                <th class="text-center">Ngày Đặt</th>
                                <th class="text-center">Khung Giờ</th>
                                <th class="text-end">Giá Tiền</th>
                                <th class="text-center">Trạng Thái</th>
                                <th class="text-center">Thao Tác</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:choose>
                                <c:when test="${not empty daDatList}">
                                    <c:forEach var="d" items="${daDatList}">
                                        <tr>
                                            <td class="text-center fw-bold">#<c:out value="${d[0]}" /></td>
                                            <td class="fw-bold text-primary"><c:out value="${d[1]}" /></td>
                                            <td class="text-center fw-semibold"><c:out value="${d[9]}" default="${d[2]}" /></td>
                                            <td class="text-center">
                                                <span class="badge bg-light text-dark border">
                                                    <c:out value="${d[3]}" />
                                                </span>
                                            </td>
                                            <td class="text-end fw-bold text-success">${DisplayUtil.formatTien(d[4])}</td>
                                            <td class="text-center">
                                                <span class="badge ${DisplayUtil.getTrangThaiDatLichBadgeClass(d[5])}">
                                                    ${DisplayUtil.getTrangThaiDatLichText(d[5])}
                                                </span>
                                            </td>
                                            <td class="text-center">
                                                <c:choose>
                                                    <c:when test="${d[8] == true}">
                                                        <form action="${pageContext.request.contextPath}/cudan/tien-ich/huy?id=${d[0]}" method="post" class="d-inline"
                                                              onsubmit="return confirm('Bạn có chắc chắn muốn hủy lượt đặt tiện ích này?');">
                                                            <button type="submit" class="btn btn-sm btn-outline-danger">
                                                                ❌ Hủy Lịch
                                                            </button>
                                                        </form>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted small">—</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="7" class="text-center text-muted py-4">Bạn chưa có lượt đặt tiện ích nào.</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                            </tbody>
                        </table>
                    </div>
                </c:catch>
                <c:if test="${not empty loiKhoiB}">
                    <div class="alert alert-danger">Không tải được danh sách lịch đã đặt.</div>
                </c:if>
            </div>
        </div>
    </div>
</div>

<!-- MODAL ĐẶT LỊCH TIỆN ÍCH -->
<div class="modal fade" id="modalBooking" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/cudan/tien-ich/dat" method="post">
                <div class="modal-header text-white" style="background-color: var(--cd-sidebar);">
                    <h5 class="modal-title fw-bold text-white">➕ Đặt Lịch Tiện Ích</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" name="maTienIch" id="bookMaTienIch">

                    <div class="mb-3 p-3 bg-light rounded border">
                        <div class="row">
                            <div class="col-7">
                                <small class="text-muted d-block">Tiện ích chọn:</small>
                                <strong class="fs-5 text-primary" id="bookTenTienIch">—</strong>
                            </div>
                            <div class="col-5 text-end">
                                <small class="text-muted d-block">Giá / lượt (1h):</small>
                                <strong class="fs-5 text-success" id="bookGiaTien">—</strong>
                            </div>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Ngày sử dụng:</label>
                        <input type="date" name="ngayDat" id="bookNgayDat" class="form-control"
                               min="${today}" max="${maxDate}" value="${today}" required>
                        <small class="text-muted">Chỉ cho phép đặt tối đa 30 ngày kể từ hôm nay</small>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Khung giờ đặt (1 tiếng / lượt):</label>
                        <select name="khungGio" id="bookKhungGio" class="form-select" required>
                            <option value="">-- Chọn khung giờ --</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-primary fw-bold">💾 Xác Nhận Đặt Lịch</button>
                </div>
            </form>
        </div>
    </div>
</div>

</body>
</html>
