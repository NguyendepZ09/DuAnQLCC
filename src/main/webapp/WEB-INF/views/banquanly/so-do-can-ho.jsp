<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="util.DisplayUtil" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Sơ Đồ 200 Căn Hộ — Ban Quản Lý</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        body { background-color: #F4EFE4; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        .app-layout { display: flex; min-height: 100vh; }
        .sidebar { width: 260px; background: #1E3B34; color: #FFF; padding: 24px; flex-shrink: 0; }
        .sidebar-brand { font-size: 1.15rem; font-weight: 700; color: #B98A46; margin-bottom: 30px; display: flex; align-items: center; gap: 8px; }
        .sidebar-brand .mark { width: 10px; height: 10px; background: #B98A46; transform: rotate(45deg); display: inline-block; }
        .sidebar-user { display: flex; align-items: center; gap: 12px; padding: 12px; background: rgba(255,255,255,0.08); border-radius: 8px; margin-bottom: 24px; }
        .sidebar-user .avatar { width: 38px; height: 38px; background: #B98A46; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 0.8rem; }
        .sidebar-user .name { font-size: 0.9rem; font-weight: 600; display: block; }
        .sidebar-user .role { font-size: 0.75rem; color: rgba(255,255,255,0.6); }
        .sidebar-nav { display: flex; flex-direction: column; gap: 6px; }
        .nav-item { display: flex; align-items: center; gap: 12px; padding: 12px 16px; color: rgba(255,255,255,0.75); text-decoration: none; border-radius: 6px; font-size: 0.9rem; font-weight: 500; transition: all 0.2s; }
        .nav-item:hover, .nav-item.active { background: #B98A46; color: #FFF; }
        .nav-divider { height: 1px; background: rgba(255,255,255,0.1); margin: 12px 0; }
        .main-wrapper { flex-grow: 1; display: flex; flex-direction: column; overflow-x: hidden; }
        .top-header { background: #FFF; padding: 18px 32px; border-bottom: 1px solid #EAE3D2; display: flex; justify-content: space-between; align-items: center; }
        .top-header h2 { font-size: 1.4rem; color: #1E3B34; margin: 0; font-weight: 700; }
        .top-header .sub { font-size: 0.82rem; color: #6C757D; }
        .content-body { padding: 32px; }
        
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
                                     onclick="openDetailModal(${ch.id})">
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

<!-- Modal Chi Tiết Căn Hộ & Danh Sách Cư Dân -->
<div class="modal fade" id="canHoDetailModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content">
            <div class="modal-header bg-emerald text-white" style="background-color: #1E3B34;">
                <h5 class="modal-title fw-bold text-white" id="modalSoCanHo">Chi Tiết Căn Hộ</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="p-3 bg-light rounded border mb-3">
                    <h6 class="fw-bold text-primary mb-2">🏢 Thông Tin Căn Hộ</h6>
                    <div class="row">
                        <div class="col-md-3"><strong>Số phòng:</strong> <span id="detailSoCanHo" class="fw-bold text-primary">---</span></div>
                        <div class="col-md-3"><strong>Số tầng:</strong> <span id="detailTang">---</span></div>
                        <div class="col-md-3"><strong>Diện tích:</strong> <span id="detailDienTich">---</span> m²</div>
                        <div class="col-md-3"><strong>Trạng thái:</strong> <span id="detailTrangThai">---</span></div>
                    </div>
                </div>

                <div class="p-3 bg-light rounded border mb-3">
                    <h6 class="fw-bold text-success mb-2">👥 Danh Sách Cư Dân Đang Ở (Chủ Hộ & Khách Thuê)</h6>
                    <div id="detailDsCuDan">
                        <span class="text-muted">Đang tải dữ liệu...</span>
                    </div>
                </div>

                <div class="p-3 bg-light rounded border">
                    <h6 class="fw-bold text-danger mb-2">💰 Công Nợ Hóa Đơn Mới Nhất</h6>
                    <div><strong>Số tiền:</strong> <span id="detailCongNoTien" class="fw-bold text-danger fs-5">0 VNĐ</span></div>
                    <div><strong>Trạng thái:</strong> <span id="detailCongNoTrangThai" class="badge bg-secondary">---</span></div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
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
    });

    function openDetailModal(canHoId) {
        fetch('can-ho-detail?id=' + canHoId)
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    document.getElementById('modalSoCanHo').textContent = 'Chi Tiết Căn Hộ ' + data.soCanHo;
                    document.getElementById('detailSoCanHo').textContent = data.soCanHo;
                    document.getElementById('detailTang').textContent = 'Tầng ' + data.tang;
                    document.getElementById('detailDienTich').textContent = data.dienTich;
                    document.getElementById('detailTrangThai').textContent = data.trangThai;

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

                    const moneyFormatted = new Intl.NumberFormat('vi-VN').format(data.congNoTien) + ' VNĐ';
                    document.getElementById('detailCongNoTien').textContent = moneyFormatted;
                    
                    const badgeElem = document.getElementById('detailCongNoTrangThai');
                    badgeElem.textContent = data.congNoTrangThai;
                    badgeElem.className = 'badge ' + (data.congNoTrangThai === 'Đã thanh toán' ? 'bg-success' : 'bg-danger');

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
