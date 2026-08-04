<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="util.DisplayUtil" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/WEB-INF/views/common/head.jsp" %>
    <title>Sơ Đồ 200 Căn Hộ — Ban Quản Lý</title>

    <style>
body { background-color: #F4EFE4; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        
        /* Layout Hàng Tầng (Row-by-Row: Tầng 25 trên cùng, Tầng 1 dưới cùng) */
        .building-container {
            background: #FFF;
            padding: 24px;
            border-radius: 12px;
            border: 1px solid #EAE3D2;
            box-shadow: 0 4px 12px rgba(0,0,0,0.03);
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .floor-row {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .floor-label {
            width: 75px;
            background: #1E3B34;
            color: #FFF;
            font-weight: 700;
            font-size: 0.85rem;
            text-align: center;
            padding: 8px 4px;
            border-radius: 6px;
            flex-shrink: 0;
        }

        .apts-row {
            display: grid;
            grid-template-columns: repeat(8, 1fr);
            gap: 8px;
            flex-grow: 1;
        }

        .apt-cell {
            padding: 10px 4px;
            border-radius: 6px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.8rem;
            font-weight: 700;
            color: #FFF;
            cursor: pointer;
            transition: transform 0.15s, box-shadow 0.15s;
            text-align: center;
        }

        .apt-cell:hover {
            transform: translateY(-3px);
            z-index: 10;
            box-shadow: 0 4px 12px rgba(0,0,0,0.25);
        }
        
        /* 4 Màu phân biệt theo đúng đề tài */
        .apt-cell.chu-ho { background: #1E3B34; color: #FFF; } /* Chủ hộ ở - Xanh rêu */
        .apt-cell.khach-thue { background: #0D6EFD; color: #FFF; } /* Khách thuê ở - Xanh dương */
        .apt-cell.trong { background: #ADB5BD; color: #212529; border: 1px solid #999; } /* Trống - Xám */
        .apt-cell.bao-tri { background: #B98A46; color: #FFF; } /* Đang sửa chữa/Bảo trì - Nâu đồng */
        
        .legend-box { display: flex; gap: 20px; align-items: center; flex-wrap: wrap; margin-bottom: 20px; }
        .legend-item { display: flex; align-items: center; gap: 8px; font-size: 0.88rem; font-weight: 600; }
        .legend-dot { width: 16px; height: 16px; border-radius: 4px; }
    </style>
</head>
<body>

<div class="app-layout">
    <jsp:include page="/WEB-INF/views/banquanly/common/sidebar.jsp" />

    <div class="main-wrapper">
        <jsp:include page="/WEB-INF/views/banquanly/common/header.jsp" />

        <div class="content-body">
            <c:if test="${not empty param.msg || not empty msg}">
                <div class="alert alert-success alert-dismissible fade show mb-3" role="alert">
                    ✅ <c:out value="${not empty param.msg ? param.msg : msg}" />
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <c:if test="${not empty param.error || not empty error}">
                <div class="alert alert-danger alert-dismissible fade show mb-3" role="alert">
                    ❌ <strong>Lỗi:</strong> <c:out value="${not empty param.error ? param.error : error}" />
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <div class="d-flex justify-content-between align-items-center mb-3">
                <h4 class="text-dark fw-bold m-0">🏢 Sơ Đồ Trực Quan Tòa Nhà 200 Căn Hộ (Tầng 25 ➔ Tầng 1)</h4>
                <span class="text-muted small">* Di chuột xem thông tin nhanh, Nhấp để xem danh sách cư dân & công nợ</span>
            </div>

            <!-- Legend Bar -->
            <div class="legend-box p-3 bg-white rounded border shadow-sm">
                <div class="legend-item">
                    <span class="legend-dot" style="background:#1E3B34;"></span>
                    <span>Chủ hộ đang ở</span>
                </div>
                <div class="legend-item">
                    <span class="legend-dot" style="background:#0D6EFD;"></span>
                    <span>Khách thuê đang ở</span>
                </div>
                <div class="legend-item">
                    <span class="legend-dot" style="background:#ADB5BD;"></span>
                    <span>Căn hộ trống</span>
                </div>
                <div class="legend-item">
                    <span class="legend-dot" style="background:#B98A46;"></span>
                    <span>Đang bảo trì / sửa chữa</span>
                </div>
            </div>

            <!-- Building Layout (Row by Row: Floor 25 at Top down to Floor 1) -->
            <div class="table-responsive">
                <div class="building-container">
                    <c:forEach var="entry" items="${mapTangCanHo}">
                        <div class="floor-row">
                            <div class="floor-label">Tầng ${entry.key}</div>
                            <div class="apts-row">
                                <c:forEach var="ch" items="${entry.value}">
                                    <c:set var="tt" value="${tinhTrangMap[ch.id]}" />
                                    <c:set var="cellClass" value="${tt == 'KhachThueO' ? 'khach-thue' : (tt == 'ChuHoO' ? 'chu-ho' : (tt == 'BaoTri' ? 'bao-tri' : 'trong'))}" />
                                    <c:set var="statusText" value="${tt == 'KhachThueO' ? 'Có khách thuê đang ở' : (tt == 'ChuHoO' ? 'Chủ hộ đang ở' : (tt == 'BaoTri' ? 'Đang bảo trì' : 'Căn hộ trống'))}" />

                                    <div class="apt-cell ${cellClass}"
                                         data-bs-toggle="tooltip"
                                         data-bs-html="true"
                                         title="<strong>Căn ${ch.soPhong}</strong><br>Diện tích: ${ch.dienTich}m²<br>Trạng thái: ${statusText}"
                                         data-id="${ch.id}">
                                        Căn ${ch.soPhong}
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Modal Chi Tiết Căn Hộ & Danh Sách Cư Dân -->
<div class="modal fade" id="canHoDetailModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content">
            <div class="modal-header bg-emerald text-white" style="background-color: #1E3B34;">
                <h5 class="modal-title fw-bold text-white" id="modalSoCanHo">Chi Tiết Căn Hộ</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form action="${pageContext.request.contextPath}/banquanly/can-ho/cap-nhat" method="post" id="formCapNhatCanHo">
                    <input type="hidden" name="id" id="modalCanHoId">
                    <div class="p-3 bg-light rounded border mb-3">
                        <h6 class="fw-bold text-primary mb-3">🏢 Thông Tin & Chỉnh Sửa Căn Hộ</h6>
                        <div class="row g-3 align-items-center">
                            <div class="col-md-3">
                                <label class="form-label fw-bold small text-muted mb-1">Số phòng:</label>
                                <div><span id="detailSoCanHo" class="fw-bold text-primary fs-6">---</span></div>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label fw-bold small text-muted mb-1">Số tầng:</label>
                                <div><span id="detailTang" class="fw-semibold">---</span></div>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label fw-bold small text-dark mb-1">Diện tích (m²):</label>
                                <input type="number" step="0.01" min="1" name="dienTich" id="modalDienTich" class="form-control form-control-sm" required>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label fw-bold small text-dark mb-1">Trạng thái:</label>
                                <select name="trangThai" id="modalTrangThai" class="form-select form-select-sm">
                                    <option value="DangO">Đang ở</option>
                                    <option value="TrongChoThue">Trống chờ thuê</option>
                                    <option value="BaoTri">Bảo trì</option>
                                </select>
                            </div>
                        </div>
                    </div>
                </form>

                <div class="p-3 bg-light rounded border mb-3">
                    <h6 class="fw-bold text-success mb-2">👥 Danh Sách Cư Dân Đang Ở (Chủ Hộ & Khách Thuê)</h6>
                    <div id="detailDsCuDan">
                        <span class="text-muted">Đang tải dữ liệu...</span>
                    </div>
                </div>

                <div class="p-3 bg-light rounded border">
                    <h6 class="fw-bold text-danger mb-2">💰 Công Nợ Hóa Đơn Tòa Nhà</h6>
                    <div class="mb-1"><strong>Tổng hóa đơn chưa tất toán:</strong> <span id="detailTongPhaiThu" class="fw-bold text-dark">0 VNĐ</span></div>
                    <div class="mb-1"><strong>Đã thanh toán:</strong> <span id="detailTongDaThu" class="fw-bold text-success">0 VNĐ</span></div>
                    <div class="mb-1"><strong>CÒN NỢ:</strong> <span id="detailCongNoTien" class="fw-bold text-danger fs-5">0 VNĐ</span></div>
                    <div><strong>Trạng thái:</strong> <span id="detailCongNoTrangThai" class="badge bg-secondary">---</span></div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                <button type="submit" form="formCapNhatCanHo" class="btn btn-primary fw-semibold" style="background-color: var(--pb-sidebar, #1E3B34); border-color: var(--pb-sidebar, #1E3B34);">
                    💾 Lưu Thay Đổi
                </button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener("DOMContentLoaded", function () {
        var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
        tooltipTriggerList.map(function (tooltipTriggerEl) {
            return new bootstrap.Tooltip(tooltipTriggerEl);
        });

        document.addEventListener("click", function(e) {
            const cell = e.target.closest(".apt-cell");
            if (cell && cell.dataset.id) {
                openDetailModal(cell.dataset.id);
            }
        });
    });

    function openDetailModal(canHoId) {
        fetch('can-ho-detail?id=' + canHoId)
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    document.getElementById('modalSoCanHo').textContent = 'Chi Tiết Căn Hộ ' + data.soCanHo;
                    document.getElementById('detailSoCanHo').textContent = data.soCanHo;
                    document.getElementById('detailTang').textContent = 'Tầng ' + data.tang;

                    document.getElementById('modalCanHoId').value = data.id;
                    document.getElementById('modalDienTich').value = data.dienTich;
                    document.getElementById('modalTrangThai').value = data.trangThai;

                    // Render Resident List
                    const containerCd = document.getElementById('detailDsCuDan');
                    if (data.dsCuDan && data.dsCuDan.length > 0) {
                        let html = '<table class="table table-sm table-bordered m-0 align-middle"><thead class="table-secondary"><tr><th>Họ & Tên</th><th>Loại Cư Dân</th><th>Số Điện Thoại</th></tr></thead><tbody>';
                        data.dsCuDan.forEach(c => {
                            html += '<tr>' +
                                    '<td class="fw-bold">👤 ' + escapeHtml(c.hoTen) + '</td>' +
                                    '<td><span class="badge ' + escapeHtml(c.loaiCuDanBadgeClass) + '">' + escapeHtml(c.loaiCuDanText) + '</span></td>' +
                                    '<td>' + (c.soDienThoai ? escapeHtml(c.soDienThoai) : '—') + '</td>' +
                                    '</tr>';
                        });
                        html += '</tbody></table>';
                        containerCd.innerHTML = html;
                    } else {
                        containerCd.innerHTML = '<span class="text-muted italic">Căn hộ hiện chưa có cư dân đăng ký ở.</span>';
                    }

                    const phaiThuFmt = new Intl.NumberFormat('vi-VN').format(data.tongPhaiThu) + ' VNĐ';
                    const daThuFmt = new Intl.NumberFormat('vi-VN').format(data.tongDaThu) + ' VNĐ';
                    const conNoFmt = new Intl.NumberFormat('vi-VN').format(data.congNoTien) + ' VNĐ';

                    document.getElementById('detailTongPhaiThu').textContent = phaiThuFmt;
                    document.getElementById('detailTongDaThu').textContent = daThuFmt;
                    document.getElementById('detailCongNoTien').textContent = conNoFmt;
                    
                    const badgeElem = document.getElementById('detailCongNoTrangThai');
                    badgeElem.textContent = data.congNoTrangThai;
                    badgeElem.className = 'badge ' + (data.congNoTien <= 0.01 ? 'bg-success' : 'bg-danger');

                    var myModal = new bootstrap.Modal(document.getElementById('canHoDetailModal'));
                    myModal.show();
                } else {
                    alert(data.message || 'Không tìm thấy thông tin căn hộ.');
                }
            })
            .catch(err => {
                console.error(err);
                alert('Lỗi kết nối khi lấy thông tin chi tiết.');
            });
    }

    function escapeHtml(text) {
        if (!text) return '';
        return text.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/"/g, "&quot;").replace(/'/g, "&#039;");
    }
</script>
</body>
</html>
