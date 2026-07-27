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
    </style>
</head>
<body>

<div class="app-layout">
    <%@ include file="/WEB-INF/views/banquanly/common/sidebar.jsp" %>

    <div class="main-wrapper">
        <%@ include file="/WEB-INF/views/banquanly/common/header.jsp" %>

        <div class="content-body">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h4 class="text-dark fw-bold m-0">👥 Quản Lý Tài Khoản Hệ Thống</h4>
                <button class="btn btn-warning fw-bold px-3 py-2 text-dark" data-bs-toggle="modal" data-bs-target="#createAccountModal">
                    ➕ Cấp Tài Khoản Mới
                </button>
            </div>

            <div class="card-custom">
                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead class="table-light">
                            <tr>
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
                                    <td><code>${tk.maTaiKhoan}</code></td>
                                    <td><strong>${tk.tenDangNhap}</strong></td>
                                    <td>
                                        <span class="badge ${tk.vaiTro == 'BQL' ? 'bg-danger' : (tk.vaiTro == 'NV' ? 'bg-info text-dark' : 'bg-primary')}">
                                            ${tk.vaiTro}
                                        </span>
                                    </td>
                                    <td>${not empty tk.boPhanCode ? tk.boPhanCode : '—'}</td>
                                    <td>
                                        <div class="form-check form-switch">
                                            <input class="form-check-input" type="checkbox" role="switch" 
                                                   id="switch_${tk.tenDangNhap}"
                                                   ${tk.trangThaiHoatDong == 'HoatDong' ? 'checked' : ''} 
                                                   onchange="toggleAccountStatus('${tk.tenDangNhap}', this)">
                                            <label class="form-check-label small" id="lbl_${tk.tenDangNhap}">
                                                ${tk.trangThaiHoatDong == 'HoatDong' ? 'Hoạt động' : 'Khoá'}
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
                        <input type="text" name="tenDangNhap" id="newTenDangNhap" class="form-control" placeholder="vd: cudan.p102 hoặc letan.nam" required>
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

                    <!-- Fields for Resident CD -->
                    <div id="residentFields">
                        <div class="mb-3">
                            <label class="form-label font-semibold">Căn Hộ Gán Cư Dân</label>
                            <select name="maCanHo" id="newMaCanHo" class="form-select">
                                <option value="">-- Chọn Căn Hộ --</option>
                                <c:forEach var="ch" items="${danhSachCanHo}">
                                    <option value="${ch.id}">[Tầng ${ch.soTang}] Phòng ${ch.soPhong} (${ch.trangThai})</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label font-semibold">Loại Cư Dân</label>
                            <select name="loaiCuDan" id="newLoaiCuDan" class="form-select">
                                <option value="ChuHo">Chủ Hộ</option>
                                <option value="KhachThue">Khách Thụe / Thành Viên</option>
                            </select>
                        </div>
                    </div>

                    <!-- Fields for Staff NV / BQL -->
                    <div id="boPhanGroup" style="display:none;">
                        <div class="mb-3">
                            <label class="form-label font-semibold">Bộ Phận Làm Việc</label>
                            <select name="boPhanCode" id="newBoPhanCode" class="form-select">
                                <option value="LeTan">Lễ Tân (LeTan)</option>
                                <option value="KeToan">Kế Toán (KeToan)</option>
                                <option value="KyThuat">Kỹ Thuật (KyThuat)</option>
                                <option value="BaoVe">Bảo Vệ (BaoVe)</option>
                                <option value="BanQuanLy">Ban Quản Lý (BanQuanLy)</option>
                            </select>
                        </div>
                    </div>

                    <!-- Common Personal Details -->
                    <div class="mb-3">
                        <label class="form-label font-semibold">Họ và Tên</label>
                        <input type="text" name="hoTen" id="newHoTen" class="form-control" placeholder="vd: Nguyễn Văn A" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label font-semibold">Số Điện Thoại</label>
                        <input type="text" name="soDienThoai" id="newSoDienThoai" class="form-control" placeholder="vd: 0901234567">
                    </div>
                    <div class="mb-3">
                        <label class="form-label font-semibold">Email Liên Hệ</label>
                        <input type="email" name="email" id="newEmail" class="form-control" placeholder="vd: nguyenvana@gmail.com">
                    </div>

                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-warning fw-bold text-dark">🚀 Xác Nhận Tạo Tài Khoản</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    function onRoleChange(role) {
        const residentFields = document.getElementById('residentFields');
        const boPhanGroup = document.getElementById('boPhanGroup');

        if (role === 'CD') {
            residentFields.style.display = 'block';
            boPhanGroup.style.display = 'none';
        } else {
            residentFields.style.display = 'none';
            boPhanGroup.style.display = 'block';
        }
    }

    function toggleAccountStatus(tenDangNhap, checkbox) {
        const label = document.getElementById('lbl_' + tenDangNhap);
        const originalState = !checkbox.checked;

        fetch('${pageContext.request.contextPath}/banquanly/tai-khoan', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8' },
            body: new URLSearchParams({
                'action': 'toggle',
                'tenDangNhap': tenDangNhap
            })
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                label.innerText = checkbox.checked ? 'Hoạt động' : 'Khoá';
            } else {
                alert('⚠️ ' + data.message);
                checkbox.checked = originalState;
            }
        })
        .catch(err => {
            alert('⚠️ Lỗi kết nối máy chủ!');
            checkbox.checked = originalState;
        });
    }

    function resetPassword(tenDangNhap) {
        if (!confirm('Bạn có chắc chắn muốn Reset mật khẩu tài khoản ' + tenDangNhap + ' về mặc định "123456"?')) {
            return;
        }

        fetch('${pageContext.request.contextPath}/banquanly/tai-khoan', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8' },
            body: new URLSearchParams({
                'action': 'resetPassword',
                'tenDangNhap': tenDangNhap,
                'newPassword': '123456'
            })
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                alert('✅ ' + data.message);
            } else {
                alert('⚠️ ' + data.message);
            }
        })
        .catch(err => alert('⚠️ Lỗi kết nối máy chủ!'));
    }

    function submitCreateAccount(event) {
        event.preventDefault();
        const form = document.getElementById('createAccountForm');
        const formData = new FormData(form);
        const params = new URLSearchParams();
        params.append('action', 'create');

        for (const [key, value] of formData.entries()) {
            params.append(key, value);
        }

        fetch('${pageContext.request.contextPath}/banquanly/tai-khoan', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8' },
            body: params
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                alert('✅ ' + data.message);
                location.reload();
            } else {
                alert('⚠️ ' + data.message);
            }
        })
        .catch(err => alert('⚠️ Lỗi kết nối máy chủ!'));
    }
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
