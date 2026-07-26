<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Sơ Đồ 200 Căn Hộ — Ban Quản Lý</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        body { background-color: #F4EFE4; font-family: 'Be Vietnam Pro', sans-serif; }
        .app-layout { display: flex; min-height: 100vh; }
        .sidebar { width: 260px; background: #1E3B34; color: #FFF; padding: 24px; flex-shrink: 0; }
        .sidebar-brand { font-family: 'Fraunces', serif; font-size: 1.15rem; font-weight: 700; color: #D9AE72; margin-bottom: 30px; display: flex; align-items: center; gap: 8px; }
        .sidebar-brand .mark { width: 10px; height: 10px; background: #D9AE72; transform: rotate(45deg); display: inline-block; }
        .sidebar-user { display: flex; align-items: center; gap: 12px; padding: 12px; background: rgba(255,255,255,0.08); border-radius: 8px; margin-bottom: 24px; }
        .sidebar-user .avatar { width: 38px; height: 38px; background: #B98A46; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 0.8rem; }
        .sidebar-user .name { font-size: 0.9rem; font-weight: 600; display: block; }
        .sidebar-user .role { font-size: 0.75rem; color: rgba(255,255,255,0.6); }
        .sidebar-nav { display: flex; flex-direction: column; gap: 6px; }
        .nav-item { display: flex; align-items: center; gap: 12px; padding: 12px 16px; color: rgba(255,255,255,0.75); text-decoration: none; border-radius: 6px; font-size: 0.9rem; font-weight: 500; transition: all 0.2s; }
        .nav-item:hover, .nav-item.active { background: #B98A46; color: #FFF; }
        .nav-divider { height: 1px; background: rgba(255,255,255,0.1); margin: 12px 0; }
        .main-wrapper { flex-grow: 1; display: flex; flex-direction: column; overflow-x: hidden; }
        .top-header { background: #FFF; padding: 18px 32px; border-bottom: 1px solid #DCE6E0; display: flex; justify-content: space-between; align-items: center; }
        .top-header h2 { font-family: 'Fraunces', serif; font-size: 1.4rem; color: #1E3B34; margin: 0; }
        .top-header .sub { font-size: 0.82rem; color: #6C757D; }
        .content-body { padding: 32px; }
        
        /* CSS Grid 25 Floors x 8 Apartments */
        .building-grid {
            display: grid;
            grid-template-columns: repeat(25, 1fr);
            gap: 8px;
            background: #FFF;
            padding: 24px;
            border-radius: 12px;
            border: 1px solid #DCE6E0;
            overflow-x: auto;
        }
        .floor-col {
            display: flex;
            flex-direction: column;
            gap: 6px;
        }
        .floor-head {
            font-size: 0.75rem;
            font-weight: 700;
            text-align: center;
            color: #1E3B34;
            margin-bottom: 4px;
            padding: 4px;
            background: #EAE3D2;
            border-radius: 4px;
        }
        .apt-cell {
            aspect-ratio: 1/1;
            border-radius: 4px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.65rem;
            font-weight: 700;
            color: #FFF;
            cursor: pointer;
            transition: transform 0.2s, box-shadow 0.2s;
            position: relative;
        }
        .apt-cell:hover {
            transform: scale(1.35);
            z-index: 10;
            box-shadow: 0 6px 16px rgba(0,0,0,0.3);
        }
        
        /* State Colors */
        .apt-cell.o { background: #1E3B34; color: #FFF; } /* DangO - Xanh dam */
        .apt-cell.t { background: #ADB5BD; color: #212529; border: 1px solid #999; } /* Trong - Xam */
        .apt-cell.b { background: #B98A46; color: #FFF; } /* BaoTri - Cam/Nau */
        
        .legend-box { display: flex; gap: 20px; align-items: center; margin-bottom: 20px; }
        .legend-item { display: flex; align-items: center; gap: 8px; font-size: 0.85rem; font-weight: 600; }
        .legend-dot { width: 14px; height: 14px; border-radius: 3px; }
    </style>
</head>
<body>

<div class="app-layout">
    <%@ include file="/banquanly/common/sidebar.jsp" %>

    <div class="main-wrapper">
        <%@ include file="/banquanly/common/header.jsp" %>

        <div class="content-body">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h4 class="text-dark fw-bold m-0">🏢 Trực Quan Sơ Đồ 200 Căn Hộ (25 Tầng x 8 Căn)</h4>
                <span class="text-muted small">* Di chuột để xem thông tin nhanh, Nhấp để xem chi tiết căn hộ</span>
            </div>

            <!-- Legend Bar -->
            <div class="legend-box p-3 bg-white rounded border">
                <div class="legend-item">
                    <span class="legend-dot" style="background:#1E3B34;"></span>
                    <span>Đang ở (DangO - Xanh tháp)</span>
                </div>
                <div class="legend-item">
                    <span class="legend-dot" style="background:#ADB5BD;"></span>
                    <span>Căn hộ trống (Trong / TrongChoThue - Xám)</span>
                </div>
                <div class="legend-item">
                    <span class="legend-dot" style="background:#B98A46;"></span>
                    <span>Đang bảo trì (BaoTri - Cam/Nâu)</span>
                </div>
            </div>

            <!-- 25 Floors Grid Dynamic from Map<Integer, List<CanHo>> -->
            <div class="building-grid">
                <c:forEach var="entry" items="${mapTangCanHo}">
                    <div class="floor-col">
                        <div class="floor-head">T${entry.key}</div>
                        <c:forEach var="ch" items="${entry.value}">
                            <c:set var="st" value="${ch.trangThai}" />
                            <c:set var="statusClass" value="${st == 'Trong' || st == 'Trống' || st == 'TrongChoThue' ? 't' : (st == 'BaoTri' || st == 'Bảo trì' ? 'b' : 'o')}" />
                            <c:set var="statusText" value="${st == 'Trong' || st == 'Trống' || st == 'TrongChoThue' ? 'Trống cho thuê' : (st == 'BaoTri' || st == 'Bảo trì' ? 'Đang bảo trì' : 'Đang ở')}" />
                            
                            <div class="apt-cell ${statusClass}" 
                                 data-bs-toggle="tooltip" 
                                 data-bs-html="true"
                                 title="<strong>Căn ${ch.soPhong}</strong><br>Diện tích: ${ch.dienTich}m²<br>Trạng thái: ${statusText}"
                                 onclick="openDetailModal(${ch.id})">
                                ${ch.soPhong}
                            </div>
                        </c:forEach>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>
</div>

<!-- Modal Xem Chi Tiết Căn Hộ (AJAX Bootstrap Modal) -->
<div class="modal fade" id="canHoDetailModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header bg-dark text-white">
                <h5 class="modal-title fw-bold" id="modalSoCanHo">Thông Tin Căn Hộ</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="p-3 bg-light rounded border mb-3">
                    <h6 class="fw-bold text-primary mb-2">🏢 Thông Tin Tòa Nhà</h6>
                    <div class="row">
                        <div class="col-6"><strong>Mã căn:</strong> <span id="detailSoCanHo">---</span></div>
                        <div class="col-6"><strong>Số tầng:</strong> <span id="detailTang">---</span></div>
                        <div class="col-6 mt-1"><strong>Diện tích:</strong> <span id="detailDienTich">---</span> m²</div>
                        <div class="col-6 mt-1"><strong>Trạng thái:</strong> <span id="detailTrangThai">---</span></div>
                    </div>
                </div>

                <div class="p-3 bg-light rounded border mb-3">
                    <h6 class="fw-bold text-success mb-2">👤 Thông Tin Chủ Hộ / Cư Dân</h6>
                    <div><strong>Họ và tên:</strong> <span id="detailChuHoTen">---</span></div>
                    <div><strong>Số điện thoại:</strong> <span id="detailChuHoSdt">---</span></div>
                    <div><strong>Email:</strong> <span id="detailChuHoEmail">---</span></div>
                </div>

                <div class="p-3 bg-light rounded border">
                    <h6 class="fw-bold text-danger mb-2">💰 Công Nợ Hóa Đơn Mới Nhất</h6>
                    <div><strong>Số tiền:</strong> <span id="detailCongNoTien" class="fw-bold text-danger">0 VNĐ</span></div>
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
    // Khoi tao Bootstrap Tooltips cho 200 o can ho
    document.addEventListener("DOMContentLoaded", function () {
        var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
        tooltipTriggerList.map(function (tooltipTriggerEl) {
            return new bootstrap.Tooltip(tooltipTriggerEl);
        });
    });

    // Hàm gọi AJAX fetch lay chi tiet can ho va hien Modal
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

                    document.getElementById('detailChuHoTen').textContent = data.chuHoTen;
                    document.getElementById('detailChuHoSdt').textContent = data.chuHoSdt;
                    document.getElementById('detailChuHoEmail').textContent = data.chuHoEmail;

                    const moneyFormatted = new Intl.NumberFormat('vi-VN').format(data.congNoTien) + ' VNĐ';
                    document.getElementById('detailCongNoTien').textContent = moneyFormatted;
                    
                    const badgeElem = document.getElementById('detailCongNoTrangThai');
                    badgeElem.textContent = data.congNoTrangThai;
                    badgeElem.className = 'badge ' + (data.congNoTrangThai === 'Đã thanh toán' ? 'bg-success' : 'bg-danger');

                    // Show Bootstrap Modal
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
</script>
</body>
</html>
