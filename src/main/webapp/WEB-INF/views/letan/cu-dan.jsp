<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="util.DisplayUtil" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Cư Dân & Khách Thuê — PolyBuilding Lễ Tân</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/role-letan.css">
    <style>
        :root {
            --lt-bg: #F4EFE4;
            --lt-primary: #1E3B34;
            --lt-gold: #B98A46;
            --lt-card-bg: #FFFFFF;
            --lt-text: #2D3748;
            --lt-border: #EAE3D2;
        }

        body {
            background-color: var(--lt-bg);
            color: var(--lt-text);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            display: flex;
            min-height: 100vh;
        }

        .sidebar {
            width: 260px;
            background-color: var(--lt-primary);
            color: #FFFFFF;
            flex-shrink: 0;
            display: flex;
            flex-direction: column;
        }

        .sidebar-brand {
            padding: 20px;
            font-size: 1.2rem;
            font-weight: 700;
            color: var(--lt-gold);
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
            background-color: var(--lt-gold);
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
            color: #E2E8F0;
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
            background-color: var(--lt-gold);
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
            border-bottom: 1px solid var(--lt-border);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .top-header h2 {
            margin: 0;
            font-size: 1.3rem;
            color: var(--lt-primary);
            font-weight: 700;
        }

        .top-header .sub {
            font-size: 0.85rem;
            color: #718096;
        }

        .content-body {
            padding: 25px 30px;
        }

        .stat-card {
            background: var(--lt-card-bg);
            border-radius: 12px;
            padding: 20px;
            border: 1px solid var(--lt-border);
            box-shadow: 0 2px 8px rgba(0,0,0,0.04);
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .stat-card .val {
            font-size: 1.8rem;
            font-weight: 700;
            color: var(--lt-primary);
        }

        .stat-card .lbl {
            font-size: 0.85rem;
            color: #718096;
            font-weight: 500;
        }

        .stat-card .icon {
            width: 50px;
            height: 50px;
            border-radius: 10px;
            background: rgba(30, 59, 52, 0.08);
            color: var(--lt-primary);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.4rem;
        }

        .card-custom {
            background: var(--lt-card-bg);
            border-radius: 12px;
            border: 1px solid var(--lt-border);
            box-shadow: 0 2px 8px rgba(0,0,0,0.04);
            margin-bottom: 20px;
        }

        .card-custom .card-header-custom {
            padding: 15px 20px;
            border-bottom: 1px solid var(--lt-border);
            font-weight: 700;
            color: var(--lt-primary);
            background: rgba(30, 59, 52, 0.02);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .row-chuyen-di {
            opacity: 0.6;
            background-color: #F8FAFC;
        }
    </style>
</head>
<body>

    <!-- SIDEBAR -->
    <jsp:include page="/WEB-INF/views/letan/common/sidebar.jsp" />

    <!-- MAIN CONTENT -->
    <div class="main-content">
        <!-- HEADER -->
        <div class="top-header">
            <div>
                <h2>Quản Lý Cư Dân & Khách Thuê</h2>
                <span class="sub">Hồ sơ thông tin cư dân, chủ hộ, khách thuê và xử lý chuyển đi</span>
            </div>
            <div class="d-flex align-items-center gap-3">
                <span class="badge bg-light text-dark border py-2 px-3">
                    📅 <span id="currentClock"></span>
                </span>
            </div>
        </div>

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

            <!-- STATS CARDS -->
            <div class="row g-3 mb-4">
                <div class="col-md-3">
                    <div class="stat-card">
                        <div>
                            <div class="val">${stats.tongCuDanDangO}</div>
                            <div class="lbl">Cư dân đang ở</div>
                        </div>
                        <div class="icon">👥</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card">
                        <div>
                            <div class="val text-primary">${stats.soChuHo}</div>
                            <div class="lbl">Số lượng Chủ hộ</div>
                        </div>
                        <div class="icon bg-primary bg-opacity-10 text-primary">👑</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card">
                        <div>
                            <div class="val text-info">${stats.soKhachThue}</div>
                            <div class="lbl">Số lượng Khách thuê</div>
                        </div>
                        <div class="icon bg-info bg-opacity-10 text-info">🧳</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card">
                        <div>
                            <div class="val text-warning">${stats.soCanHoTrong}</div>
                            <div class="lbl">Căn hộ trống</div>
                        </div>
                        <div class="icon bg-warning bg-opacity-10 text-warning">🔑</div>
                    </div>
                </div>
            </div>

            <!-- SEARCH & ACTIONS -->
            <div class="card-custom">
                <div class="card-header-custom">
                    <form action="${pageContext.request.contextPath}/letan/cu-dan" method="get" class="d-flex gap-2 align-items-center flex-grow-1 me-3">
                        <input type="text" name="tuKhoa" class="form-control form-control-sm" placeholder="Tìm theo tên, SĐT, CCCD, số phòng..." value="${tuKhoa}" style="max-width: 300px;">
                        <select name="loaiCuDan" class="form-select form-select-sm" style="max-width: 180px;">
                            <option value="">-- Tất cả loại cư dân --</option>
                            <option value="ChuHo" ${loaiCuDanChon == 'ChuHo' ? 'selected' : ''}>Chủ hộ</option>
                            <option value="KhachThue" ${loaiCuDanChon == 'KhachThue' ? 'selected' : ''}>Khách thuê</option>
                        </select>
                        <select name="trangThai" class="form-select form-select-sm" style="max-width: 180px;">
                            <option value="">-- Tất cả trạng thái --</option>
                            <option value="DangO" ${trangThaiChon == 'DangO' ? 'selected' : ''}>Đang ở</option>
                            <option value="DaChuyenDi" ${trangThaiChon == 'DaChuyenDi' ? 'selected' : ''}>Đã chuyển đi</option>
                        </select>
                        <button type="submit" class="btn btn-sm btn-secondary">🔍 Tìm kiếm</button>
                    </form>

                    <button type="button" class="btn btn-sm btn-success" data-bs-toggle="modal" data-bs-target="#modalThemCuDan">
                        ➕ Thêm Cư Dân Mới
                    </button>
                </div>

                <div class="card-body p-0">
                    <table class="table table-hover align-middle m-0">
                        <thead class="table-light">
                            <tr>
                                <th class="ps-3">Họ và Tên</th>
                                <th>Căn Hộ</th>
                                <th>Loại Cư Dân</th>
                                <th>Số Điện Thoại</th>
                                <th>CCCD / Định danh</th>
                                <th>Ngày Chuyển Đến</th>
                                <th>Tài Khoản App</th>
                                <th>Thẻ Từ</th>
                                <th>Trạng Thái</th>
                                <th class="pe-3">Thao Tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty cuDanList}">
                                    <c:forEach var="row" items="${cuDanList}">
                                        <tr class="${row[7] == 'DaChuyenDi' ? 'row-chuyen-di' : ''}">
                                            <td class="ps-3 fw-bold text-dark">
                                                👤 <c:out value="${row[1]}"/>
                                            </td>
                                            <td><span class="badge bg-secondary">Căn <c:out value="${row[4]}"/></span></td>
                                            <td>
                                                <span class="badge ${DisplayUtil.getLoaiCuDanBadgeClass(row[6])}">
                                                    ${DisplayUtil.getLoaiCuDanText(row[6])}
                                                </span>
                                            </td>
                                            <td><c:out value="${row[2]}" default="—"/></td>
                                            <td><code><c:out value="${row[3]}" default="—"/></code></td>
                                            <td><c:out value="${row[8]}"/></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${row[9] == true}">
                                                        <span class="badge bg-success">Đã cấp</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-light text-muted border">Chưa cấp</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${row[10] > 0}">
                                                        <span class="badge bg-primary">🪪 ${row[10]} thẻ</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-light text-muted border">Chưa có thẻ</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${row[7] == 'DangO'}">
                                                        <span class="badge bg-success">🟢 Đang ở</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-danger">🔴 Đã chuyển đi</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="pe-3">
                                                <c:choose>
                                                    <c:when test="${row[7] == 'DaChuyenDi'}">
                                                        <span class="text-muted small">🔒 Đã chuyển đi</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="btn-group btn-group-sm">
                                                            <button type="button" class="btn btn-outline-primary btn-edit-cudan"
                                                                    data-id="${row[0]}"
                                                                    data-hoten="${row[1]}"
                                                                    data-sdt="${row[2]}"
                                                                    data-cccd="${row[3]}"
                                                                    data-sophong="${row[4]}"
                                                                    data-canho="${row[5]}"
                                                                    data-loai="${row[6]}"
                                                                    data-ngaychuyenden="${row[8]}">
                                                                ✏️ Sửa
                                                            </button>

                                                            <form action="${pageContext.request.contextPath}/letan/cu-dan/chuyen-di" method="post" class="d-inline form-chuyen-di">
                                                                <input type="hidden" name="id" value="${row[0]}">
                                                                <button type="submit" class="btn btn-outline-danger">🚪 Chuyển đi</button>
                                                            </form>
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="10" class="text-center text-muted py-4">Không tìm thấy cư dân nào.</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>

        </div>
    </div>

    <!-- MODAL THÊM CƯ DÂN MỚI -->
    <div class="modal fade" id="modalThemCuDan" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <form action="${pageContext.request.contextPath}/letan/cu-dan/them" method="post">
                    <div class="modal-header">
                        <h5 class="modal-title fw-bold text-success">➕ Thêm Cư Dân Mới</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label fw-bold">Chọn Căn Hộ (*):</label>
                            <select name="maCanHo" class="form-select" required>
                                <option value="">-- Chọn Căn Hộ --</option>
                                <c:forEach var="c" items="${dsCanHo}">
                                    <option value="${c[0]}">Căn ${c[1]} (${DisplayUtil.getTrangThaiCanHoText(c[2])})</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold">Họ và Tên (*):</label>
                            <input type="text" name="hoTen" class="form-control" placeholder="Ví dụ: Nguyễn Văn A" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold">Số Điện Thoại:</label>
                            <input type="text" name="soDienThoai" class="form-control" placeholder="Ví dụ: 0987654321">
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold">Số CCCD / Định Danh (12 chữ số):</label>
                            <input type="text" name="cccd" class="form-control" placeholder="Ví dụ: 012345678901" maxlength="12" pattern="\d{12}" title="Vui lòng nhập đúng 12 chữ số">
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold">Loại Cư Dân (*):</label>
                            <select name="loaiCuDan" class="form-select" required>
                                <option value="ChuHo">Chủ hộ (Mỗi căn chỉ 1 chủ hộ)</option>
                                <option value="KhachThue">Khách thuê</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold">Ngày Chuyển Đến:</label>
                            <input type="date" name="ngayChuyenDen" class="form-control">
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                        <button type="submit" class="btn btn-success">💾 Thêm Cư Dân</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- MODAL SỬA CƯ DÂN -->
    <div class="modal fade" id="modalSuaCuDan" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <form action="${pageContext.request.contextPath}/letan/cu-dan/sua" method="post">
                    <input type="hidden" name="id" id="editCuDanId">
                    <div class="modal-header">
                        <h5 class="modal-title fw-bold text-primary">✏️ Cập Nhật Thông Tin Cư Dân</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div class="alert alert-light border py-2 mb-3">
                            📌 <b>Căn hộ:</b> <span id="editSoPhongText" class="fw-bold text-primary"></span>
                            <small class="text-muted ms-2">(Không thể thay đổi căn hộ trực tiếp)</small>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold">Họ và Tên (*):</label>
                            <input type="text" name="hoTen" id="editHoTen" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold">Số Điện Thoại:</label>
                            <input type="text" name="soDienThoai" id="editSoDienThoai" class="form-control">
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold">Số CCCD / Định Danh (12 chữ số):</label>
                            <input type="text" name="cccd" id="editCccd" class="form-control" maxlength="12" pattern="\d{12}" title="Vui lòng nhập đúng 12 chữ số">
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold">Loại Cư Dân (*):</label>
                            <select name="loaiCuDan" id="editLoaiCuDan" class="form-select" required>
                                <option value="ChuHo">Chủ hộ (Mỗi căn chỉ 1 chủ hộ)</option>
                                <option value="KhachThue">Khách thuê</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold">Ngày Chuyển Đến:</label>
                            <input type="date" name="ngayChuyenDen" id="editNgayChuyenDen" class="form-control">
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                        <button type="submit" class="btn btn-primary">💾 Lưu Thay Đổi</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            // Confirm resident move out
            const chuyenDiForms = document.querySelectorAll('.form-chuyen-di');
            chuyenDiForms.forEach(form => {
                form.addEventListener('submit', function (e) {
                    const ok = confirm('⚠️ CẢNH BÁO XỬ LÝ CHUYỂN ĐI!\nThao tác chuyển đi sẽ TỰ ĐỘNG THU HỒI toàn bộ thẻ từ của cư dân này và GỠ LIÊN KẾT tất cả xe đang gắn thẻ.\n\nBạn có chắc chắn muốn xử lý chuyển đi cho cư dân này không?');
                    if (!ok) {
                        e.preventDefault();
                    }
                });
            });

            // Edit modal handling
            const editButtons = document.querySelectorAll('.btn-edit-cudan');
            const editModalEl = document.getElementById('modalSuaCuDan');
            const editCuDanId = document.getElementById('editCuDanId');
            const editSoPhongText = document.getElementById('editSoPhongText');
            const editHoTen = document.getElementById('editHoTen');
            const editSoDienThoai = document.getElementById('editSoDienThoai');
            const editCccd = document.getElementById('editCccd');
            const editLoaiCuDan = document.getElementById('editLoaiCuDan');
            const editNgayChuyenDen = document.getElementById('editNgayChuyenDen');

            if (editButtons && editModalEl && editCuDanId && editHoTen) {
                const editModal = new bootstrap.Modal(editModalEl);
                editButtons.forEach(btn => {
                    btn.addEventListener('click', function () {
                        const id = this.getAttribute('data-id');
                        const hoTen = this.getAttribute('data-hoten');
                        const sdt = this.getAttribute('data-sdt');
                        const cccd = this.getAttribute('data-cccd');
                        const soPhong = this.getAttribute('data-sophong');
                        const loai = this.getAttribute('data-loai');
                        const ngayChuyenDenFmt = this.getAttribute('data-ngaychuyenden');

                        editCuDanId.value = id;
                        editSoPhongText.innerText = 'Căn ' + (soPhong || '');
                        editHoTen.value = hoTen || '';
                        editSoDienThoai.value = (sdt && sdt !== '—') ? sdt : '';
                        editCccd.value = (cccd && cccd !== '—') ? cccd : '';
                        editLoaiCuDan.value = loai || 'KhachThue';

                        // Parse dd/MM/yyyy to yyyy-MM-dd for date input
                        if (ngayChuyenDenFmt && ngayChuyenDenFmt.includes('/')) {
                            const parts = ngayChuyenDenFmt.split('/');
                            if (parts.length === 3) {
                                editNgayChuyenDen.value = parts[2] + '-' + parts[1].padStart(2, '0') + '-' + parts[0].padStart(2, '0');
                            } else {
                                editNgayChuyenDen.value = '';
                            }
                        } else {
                            editNgayChuyenDen.value = '';
                        }

                        editModal.show();
                    });
                });
            }
        });
    </script>
</body>
</html>
