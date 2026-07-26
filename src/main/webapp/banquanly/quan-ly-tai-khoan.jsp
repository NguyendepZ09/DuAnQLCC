<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Tài Khoản — Ban Quản Lý</title>
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
        .card-custom { background: #FFF; border-radius: 12px; padding: 24px; border: 1px solid #DCE6E0; box-shadow: 0 4px 12px rgba(0,0,0,0.03); }
        .form-switch .form-check-input { width: 3.2em; height: 1.6em; cursor: pointer; }
    </style>
</head>
<body>

<div class="app-layout">
    <%@ include file="/banquanly/common/sidebar.jsp" %>

    <div class="main-wrapper">
        <%@ include file="/banquanly/common/header.jsp" %>

        <div class="content-body">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h4 class="text-dark fw-bold m-0">👥 Quản Lý Tài Khoản Hệ Thống & Phân Quyền</h4>
                <button class="btn btn-success fw-semibold" data-bs-toggle="modal" data-bs-target="#addAccountModal">
                    ➕ Tạo Tài Khoản Mới
                </button>
            </div>

            <!-- Toast / Alert Notification Container -->
            <div id="alertContainer" class="mb-3" style="display:none;">
                <div id="alertBox" class="alert alert-dismissible fade show" role="alert">
                    <span id="alertMessage"></span>
                    <button type="button" class="btn-close" onclick="document.getElementById('alertContainer').style.display='none'"></button>
                </div>
            </div>

            <div class="card-custom">
                <table class="table table-hover align-middle">
                    <thead class="table-light">
                        <tr>
                            <th>ID</th>
                            <th>Mã Tài Khoản</th>
                            <th>Tên Đăng Nhập</th>
                            <th>Vai Trò</th>
                            <th>Bộ Phận</th>
                            <th>Trạng Thái</th>
                            <th>Khóa / Mở Khóa (AJAX)</th>
                            <th>Thao Tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="tk" items="${danhSachTaiKhoan}">
                            <tr>
                                <td>${tk.id}</td>
                                <td><code>${tk.maTaiKhoan}</code></td>
                                <td><strong>${tk.tenDangNhap}</strong></td>
                                <td>
                                    <span class="badge ${tk.vaiTro == 'CD' ? 'bg-primary' : (tk.vaiTro == 'BQL' ? 'bg-danger' : 'bg-secondary')}">
                                        ${tk.vaiTro == 'CD' ? 'Cư dân' : (tk.vaiTro == 'BQL' ? 'Ban quản lý' : 'Nhân viên')}
                                    </span>
                                </td>
                                <td><span class="text-muted small">${tk.boPhanCode != null ? tk.boPhanCode : 'N/A'}</span></td>
                                <td>
                                    <span id="statusBadge_${tk.tenDangNhap}" class="badge ${tk.trangThaiHoatDong == 'HoatDong' ? 'bg-success' : 'bg-danger'}">
                                        ${tk.trangThaiHoatDong == 'HoatDong' ? 'Đang hoạt động' : 'Bị khóa'}
                                    </span>
                                </td>
                                <td>
                                    <!-- AJAX Toggle Switch -->
                                    <div class="form-check form-switch m-0">
                                        <input class="form-check-input" type="checkbox" 
                                               id="switch_${tk.tenDangNhap}"
                                               onchange="toggleAccountStatus('${tk.tenDangNhap}', this)"
                                               ${tk.trangThaiHoatDong == 'HoatDong' ? 'checked' : ''}>
                                    </div>
                                </td>
                                <td>
                                    <!-- Reset Password Button -->
                                    <button type="button" class="btn btn-outline-warning btn-sm me-1" 
                                            onclick="confirmResetPassword('${tk.tenDangNhap}')">
                                        🔑 Reset Pass
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<!-- Modal 1: Tạo Tài Khoản Mới -->
<div class="modal fade" id="addAccountModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form id="createAccountForm">
                <div class="modal-header bg-dark text-white">
                    <h5 class="modal-title fw-bold">Cấp Tài Khoản Mới</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label font-semibold">Tên Đăng Nhập (*)</label>
                        <input type="text" id="createUsername" name="tenDangNhap" class="form-control" placeholder="vd: cudan.p106 hoặc nv_letan02" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label font-semibold">Mật Khẩu Khởi Tạo (*)</label>
                        <input type="password" id="createPassword" name="matKhau" class="form-control" placeholder="Nhập mật khẩu" required value="123456">
                    </div>
                    <div class="mb-3">
                        <label class="form-label font-semibold">Vai Trò (*)</label>
                        <select id="createRole" name="vaiTro" class="form-select" onchange="onRoleChange(this.value)" required>
                            <option value="CD">Cư dân (CD)</option>
                            <option value="NV">Nhân viên (NV)</option>
                            <option value="BQL">Ban quản lý (BQL)</option>
                        </select>
                    </div>
                    
                    <div class="mb-3" id="boPhanGroup" style="display:none;">
                        <label class="form-label font-semibold">Mã Bộ Phận Nhân Viên</label>
                        <select id="boPhanSelect" name="boPhanCode" class="form-select" disabled>
                            <option value="LT">Lễ tân (LT)</option>
                            <option value="KT">Kế toán (KT)</option>
                            <option value="NVKT">Kỹ thuật (NVKT)</option>
                            <option value="BV">Bảo vệ (BV)</option>
                            <option value="MAIN">Quản trị (MAIN)</option>
                        </select>
                    </div>

                    <!-- Dropdown Cư Dân Chưa Có Tài Khoản -->
                    <div class="mb-3" id="cuDanGroup">
                        <label class="form-label font-semibold">Gắn Cho Cư Dân Chưa Có Tài Khoản</label>
                        <select name="maCuDan" class="form-select">
                            <option value="">-- Không liên kết (Tạo độc lập) --</option>
                            <c:forEach var="cd" items="${danhSachCuDanChuaCoTK}">
                                <option value="${cd.id}">${cd.hoTen} - SĐT: ${cd.soDienThoai}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <!-- Dropdown Nhân Viên Chưa Có Tài Khoản -->
                    <div class="mb-3" id="nhanVienGroup" style="display:none;">
                        <label class="form-label font-semibold">Gắn Cho Nhân Viên Chưa Có Tài Khoản</label>
                        <select name="maNhanVien" class="form-select">
                            <option value="">-- Không liên kết (Tạo độc lập) --</option>
                            <c:forEach var="nv" items="${danhSachNhanVienChuaCoTK}">
                                <option value="${nv.id}">${nv.hoTen} - Bộ phận: ${nv.boPhan}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-success fw-bold">🚀 Lưu Tài Khoản</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function onRoleChange(role) {
        const boPhanSelect = document.getElementById('boPhanSelect');
        const boPhanGroup = document.getElementById('boPhanGroup');

        if (role === 'NV') {
            boPhanGroup.style.display = 'block';
            boPhanSelect.disabled = false;
        } else {
            boPhanGroup.style.display = 'none';
            boPhanSelect.disabled = true;
        }

        document.getElementById('cuDanGroup').style.display = (role === 'CD') ? 'block' : 'none';
        document.getElementById('nhanVienGroup').style.display = (role === 'NV' || role === 'BQL') ? 'block' : 'none';
    }

    function showAlert(msg, isSuccess) {
        const container = document.getElementById('alertContainer');
        const box = document.getElementById('alertBox');
        const text = document.getElementById('alertMessage');
        
        container.style.display = 'block';
        box.className = 'alert alert-dismissible fade show ' + (isSuccess ? 'alert-success' : 'alert-danger');
        text.textContent = msg;
    }

    function toggleAccountStatus(tenDangNhap, checkboxEl) {
        const params = new URLSearchParams();
        params.append('action', 'toggle');
        params.append('tenDangNhap', tenDangNhap);

        fetch('tai-khoan', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' },
            body: params.toString()
        })
        .then(res => res.json())
        .then(data => {
            showAlert(data.message, data.success);
            if (data.success) {
                const badge = document.getElementById('statusBadge_' + tenDangNhap);
                if (badge) {
                    const isChecked = checkboxEl.checked;
                    badge.textContent = isChecked ? 'Đang hoạt động' : 'Bị khóa';
                    badge.className = 'badge ' + (isChecked ? 'bg-success' : 'bg-danger');
                }
            } else {
                checkboxEl.checked = !checkboxEl.checked;
            }
        })
        .catch(err => {
            console.error(err);
            showAlert('Lỗi kết nối khi thay đổi trạng thái tài khoản.', false);
            checkboxEl.checked = !checkboxEl.checked;
        });
    }

    function confirmResetPassword(tenDangNhap) {
        if (!confirm('Bạn có chắc chắn muốn reset mật khẩu tài khoản "' + tenDangNhap + '" về 123456 không?')) {
            return;
        }

        const params = new URLSearchParams();
        params.append('action', 'resetPassword');
        params.append('tenDangNhap', tenDangNhap);
        params.append('newPassword', '123456');

        fetch('tai-khoan', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' },
            body: params.toString()
        })
        .then(res => res.json())
        .then(data => {
            showAlert(data.message, data.success);
        })
        .catch(err => {
            console.error(err);
            showAlert('Lỗi kết nối khi reset mật khẩu.', false);
        });
    }

    document.getElementById('createAccountForm').addEventListener('submit', function(e) {
        e.preventDefault();

        const formData = new FormData(this);
        const params = new URLSearchParams();
        params.append('action', 'create');
        for (const pair of formData.entries()) {
            params.append(pair[0], pair[1]);
        }

        fetch('tai-khoan', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' },
            body: params.toString()
        })
        .then(res => res.json())
        .then(data => {
            if (data.success) {
                alert(data.message);
                window.location.reload();
            } else {
                alert(data.message);
            }
        })
        .catch(err => {
            console.error(err);
            alert('Lỗi kết nối khi tạo tài khoản.');
        });
    });
</script>
</body>
</html>
