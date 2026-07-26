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
        .form-switch .form-check-input { width: 3em; height: 1.5em; cursor: pointer; }
    </style>
</head>
<body>

<div class="app-layout">
    <%@ include file="/WEB-INF/views/banquanly/common/sidebar.jsp" %>

    <div class="main-wrapper">
        <%@ include file="/WEB-INF/views/banquanly/common/header.jsp" %>

        <div class="content-body">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h4 class="text-dark fw-bold m-0">👥 Quản Lý Tài Khoản Cư Dân & Nhân Viên</h4>
                <button type="button" class="btn btn-warning text-dark fw-bold" data-bs-toggle="modal" data-bs-target="#createAccountModal">
                    ➕ Cấp Tài Khoản Mới
                </button>
            </div>

            <!-- Table Accounts List -->
            <div class="card-custom">
                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead class="table-light">
                            <tr>
                                <th>ID</th>
                                <th>Mã TK</th>
                                <th>Tên Đăng Nhập</th>
                                <th>Vai Trò</th>
                                <th>Bộ Phận</th>
                                <th>Trạng Thái</th>
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
                                        <span class="badge ${tk.vaiTro == 'BQL' ? 'bg-danger' : (tk.vaiTro == 'NV' ? 'bg-primary' : 'bg-success')}">
                                            ${tk.vaiTro == 'BQL' ? 'Ban Quản Lý' : (tk.vaiTro == 'NV' ? 'Nhân Viên' : 'Cư Dân')}
                                        </span>
                                    </td>
                                    <td>
                                        <span class="badge bg-secondary">
                                            ${tk.boPhanCode != null ? tk.boPhanCode : 'N/A'}
                                        </span>
                                    </td>
                                    <td>
                                        <!-- AJAX Toggle Switch -->
                                        <div class="form-check form-switch d-inline-block">
                                            <input class="form-check-input" type="checkbox" role="switch" 
                                                   id="switch_${tk.tenDangNhap}"
                                                   ${tk.trangThaiHoatDong == 'HoatDong' ? 'checked' : ''}
                                                   onchange="toggleStatus('${tk.tenDangNhap}')">
                                            <label class="form-check-label text-muted small ms-1" id="lbl_${tk.tenDangNhap}">
                                                ${tk.trangThaiHoatDong == 'HoatDong' ? 'Hoạt động' : 'Đã khóa'}
                                            </label>
                                        </div>
                                    </td>
                                    <td>
                                        <button type="button" class="btn btn-sm btn-outline-danger" onclick="resetPassword('${tk.tenDangNhap}')">
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
</div>

<!-- Modal Tạo Tài Khoản Mới -->
<div class="modal fade" id="createAccountModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <form id="createAccountForm" onsubmit="submitCreateAccount(event)">
                <div class="modal-header bg-warning text-dark">
                    <h5 class="modal-title fw-bold">➕ Cấp Tài Khoản Mới</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label font-semibold">Tên Đăng Nhập</label>
                        <input type="text" name="tenDangNhap" id="newTenDangNhap" class="form-control" placeholder="vd: cudan.p102 hoặc nv.letan02" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label font-semibold">Mật Khẩu</label>
                        <input type="password" name="matKhau" id="newMatKhau" class="form-control" value="123456" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label font-semibold">Vai Trò Hệ Thống</label>
                        <select name="vaiTro" id="newVaiTro" class="form-select" onchange="onRoleChange(this.value)" required>
                            <option value="CD">Cư Dân (CD)</option>
                            <option value="NV">Nhân Viên Vận Hành (NV)</option>
                            <option value="BQL">Ban Quản Lý (BQL)</option>
                        </select>
                    </div>
                    <div class="mb-3" id="boPhanGroup" style="display:none;">
                        <label class="form-label font-semibold">Bộ Phận Làm Việc</label>
                        <select name="boPhanCode" id="newBoPhanCode" class="form-select">
                            <option value="LT">Lễ Tân (LT)</option>
                            <option value="KT">Kế Toán (KT)</option>
                            <option value="NVKT">Kỹ Thuật (NVKT)</option>
                            <option value="BV">Bảo Vệ (BV)</option>
                            <option value="MAIN">BQL Trung Tâm (MAIN)</option>
                        </select>
                    </div>
                    
                    <!-- Unassigned Resident Dropdown -->
                    <div class="mb-3" id="cuDanGroup">
                        <label class="form-label font-semibold">Chọn Cư Dân Chưa Có Tài Khoản</label>
                        <select name="maCuDan" id="newMaCuDan" class="form-select">
                            <option value="">-- Không gán / Chọn sau --</option>
                            <c:forEach var="cd" items="${danhSachCuDanChuaCoTK}">
                                <option value="${cd.id}">${cd.hoTen} (SDT: ${cd.soDienThoai})</option>
                            </c:forEach>
                        </select>
                    </div>

                    <!-- Unassigned Staff Dropdown -->
                    <div class="mb-3" id="nhanVienGroup" style="display:none;">
                        <label class="form-label font-semibold">Chọn Nhân Viên Chưa Có Tài Khoản</label>
                        <select name="maNhanVien" id="newMaNhanVien" class="form-select">
                            <option value="">-- Không gán / Chọn sau --</option>
                            <c:forEach var="nv" items="${danhSachNhanVienChuaCoTK}">
                                <option value="${nv.id}">${nv.hoTen} (Bộ phận: ${nv.boPhan})</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-warning fw-bold">Xác Nhận Tạo</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function onRoleChange(role) {
        const boPhanGroup = document.getElementById('boPhanGroup');
        const cuDanGroup = document.getElementById('cuDanGroup');
        const nhanVienGroup = document.getElementById('nhanVienGroup');
        const boPhanSelect = document.getElementById('newBoPhanCode');

        if (role === 'NV') {
            boPhanGroup.style.display = 'block';
            boPhanSelect.disabled = false;
            cuDanGroup.style.display = 'none';
            nhanVienGroup.style.display = 'block';
        } else if (role === 'BQL') {
            boPhanGroup.style.display = 'block';
            boPhanSelect.value = 'MAIN';
            boPhanSelect.disabled = true; // Auto MAIN for BQL
            cuDanGroup.style.display = 'none';
            nhanVienGroup.style.display = 'block';
        } else {
            // CD
            boPhanGroup.style.display = 'none';
            boPhanSelect.disabled = true; // Clear for CD
            cuDanGroup.style.display = 'block';
            nhanVienGroup.style.display = 'none';
        }
    }

    function toggleStatus(username) {
        const params = new URLSearchParams();
        params.append('action', 'toggle');
        params.append('tenDangNhap', username);

        fetch('tai-khoan', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' },
            body: params.toString()
        })
        .then(res => res.json())
        .then(data => {
            if (!data.success) {
                alert(data.message);
                const chk = document.getElementById('switch_' + username);
                if (chk) chk.checked = !chk.checked;
            } else {
                const lbl = document.getElementById('lbl_' + username);
                const chk = document.getElementById('switch_' + username);
                if (lbl && chk) {
                    lbl.textContent = chk.checked ? 'Hoạt động' : 'Đã khóa';
                }
            }
        })
        .catch(err => {
            console.error(err);
            alert('Lỗi khi đổi trạng thái tài khoản.');
        });
    }

    function resetPassword(username) {
        if (!confirm('Bạn có chắc chắn muốn reset mật khẩu cho tài khoản "' + username + '" về 123456 không?')) return;

        const params = new URLSearchParams();
        params.append('action', 'resetPassword');
        params.append('tenDangNhap', username);
        params.append('newPassword', '123456');

        fetch('tai-khoan', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' },
            body: params.toString()
        })
        .then(res => res.json())
        .then(data => {
            alert(data.message);
        })
        .catch(err => console.error(err));
    }

    function submitCreateAccount(e) {
        e.preventDefault();
        const form = e.target;
        const params = new URLSearchParams(new FormData(form));
        params.append('action', 'create');

        fetch('tai-khoan', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' },
            body: params.toString()
        })
        .then(res => res.json())
        .then(data => {
            alert(data.message);
            if (data.success) {
                location.reload();
            }
        })
        .catch(err => console.error(err));
    }
</script>
</body>
</html>
