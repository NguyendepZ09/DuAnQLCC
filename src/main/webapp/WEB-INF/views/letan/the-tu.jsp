<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="util.DisplayUtil" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/WEB-INF/views/common/head.jsp" %>
    <title>Quản Lý Thẻ Từ Cư Dân — PolyBuilding Lễ Tân</title>

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
            background: rgba(13, 148, 136, 0.08);
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
            background: rgba(13, 148, 136, 0.02);
            display: flex;
            justify-content: space-between;
            align-items: center;
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
                <h2>Quản Lý Thẻ Từ Cư Dân</h2>
                <span class="sub">Cấp mới, điều chỉnh chức năng, tạm khóa và thu hồi thẻ từ chung cư</span>
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
                            <div class="val">${stats.tongSoThe}</div>
                            <div class="lbl">Tổng số thẻ từ</div>
                        </div>
                        <div class="icon">🪪</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card">
                        <div>
                            <div class="val text-success">${stats.dangSuDung}</div>
                            <div class="lbl">Đang sử dụng</div>
                        </div>
                        <div class="icon bg-success bg-opacity-10 text-success">🟢</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card">
                        <div>
                            <div class="val text-warning">${stats.tamKhoa}</div>
                            <div class="lbl">Tạm khóa</div>
                        </div>
                        <div class="icon bg-warning bg-opacity-10 text-warning">🟡</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card">
                        <div>
                            <div class="val text-secondary">${stats.daThuHoi}</div>
                            <div class="lbl">Đã thu hồi</div>
                        </div>
                        <div class="icon bg-secondary bg-opacity-10 text-secondary">🔴</div>
                    </div>
                </div>
            </div>

            <!-- SEARCH & ACTIONS -->
            <div class="card-custom">
                <div class="card-header-custom">
                    <form action="${pageContext.request.contextPath}/letan/the-tu" method="get" class="d-flex gap-2 align-items-center flex-grow-1 me-3">
                        <input type="text" name="tuKhoa" class="form-control form-control-sm" placeholder="Tìm theo số thẻ, căn hộ, tên cư dân..." value="${tuKhoa}" style="max-width: 300px;">
                        <select name="trangThai" class="form-select form-select-sm" style="max-width: 180px;">
                            <option value="">-- Tất cả trạng thái --</option>
                            <option value="DangSuDung" ${trangThaiChon == 'DangSuDung' ? 'selected' : ''}>Đang sử dụng</option>
                            <option value="TamKhoa" ${trangThaiChon == 'TamKhoa' ? 'selected' : ''}>Tạm khóa</option>
                            <option value="DaThuHoi" ${trangThaiChon == 'DaThuHoi' ? 'selected' : ''}>Đã thu hồi</option>
                        </select>
                        <button type="submit" class="btn btn-sm btn-secondary">🔍 Tìm kiếm</button>
                    </form>

                    <button type="button" class="btn btn-sm btn-success" data-bs-toggle="modal" data-bs-target="#modalCapThe">
                        ➕ Cấp Thẻ Từ Mới
                    </button>
                </div>

                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle m-0">
                            <thead class="table-light">
                                <tr>
                                    <th class="ps-3">Số Thẻ</th>
                                    <th>Căn Hộ</th>
                                    <th>Người Sử Dụng</th>
                                    <th>Chức Năng Thẻ</th>
                                    <th>Ngày Cấp</th>
                                    <th>Hết Hạn</th>
                                    <th>Số Xe</th>
                                    <th>Trạng Thái</th>
                                    <th class="pe-3">Thao Tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty theTuList}">
                                        <c:forEach var="row" items="${theTuList}">
                                            <tr>
                                                <td class="ps-3 fw-bold text-primary">🪪 <c:out value="${row[1]}"/></td>
                                                <td><span class="badge bg-secondary">Căn <c:out value="${row[2]}"/></span></td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty row[14]}">
                                                            👤 <c:out value="${row[3]}"/> 
                                                            <c:if test="${not empty row[4]}">
                                                                <small class="text-muted">(<c:out value="${row[4] == 'ChuHo' ? 'Chủ hộ' : 'Khách thuê'}"/>)</small>
                                                            </c:if>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-light text-dark border">🏠 Thẻ dùng chung của căn hộ</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty row[8]}">
                                                            <c:forEach var="cn" items="${row[8].split(',')}">
                                                                <span class="badge bg-info text-dark mb-1 me-1">${DisplayUtil.getChucNangTheText(cn)}</span>
                                                            </c:forEach>
                                                        </c:when>
                                                        <c:otherwise><span class="text-muted">—</span></c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td><c:out value="${row[11]}"/></td>
                                                <td>
                                                    <c:out value="${row[12]}"/>
                                                </td>
                                                <td>
                                                    <span class="badge bg-light text-dark border">🚗 <c:out value="${row[9]}"/> xe</span>
                                                </td>
                                                <td>
                                                    <span class="badge ${DisplayUtil.getTrangThaiTheBadgeClass(row[7])}">
                                                        ${DisplayUtil.getTrangThaiTheText(row[7])}
                                                    </span>
                                                    <c:if test="${row[10] == true && row[7] == 'DangSuDung'}">
                                                        <span class="badge bg-danger ms-1">Hết hạn</span>
                                                    </c:if>
                                                </td>
                                                <td class="pe-3">
                                                    <c:choose>
                                                        <c:when test="${row[7] == 'DaThuHoi'}">
                                                            <span class="text-muted small">🔒 Đã thu hồi</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="btn-group btn-group-sm">
                                                                <!-- EDIT BUTTON -->
                                                                <button type="button" class="btn btn-outline-primary btn-edit-card"
                                                                        data-id="${row[0]}"
                                                                        data-sothe="${row[1]}"
                                                                        data-canho="${row[13]}"
                                                                        data-sophong="${row[2]}"
                                                                        data-cudan="${row[14]}"
                                                                        data-hethan="${row[6]}"
                                                                        data-chucnang="${row[8]}">
                                                                    ✏️ Sửa
                                                                </button>

                                                                <!-- TOGGLE LOCK BUTTON -->
                                                                <c:choose>
                                                                    <c:when test="${row[7] == 'DangSuDung'}">
                                                                        <form action="${pageContext.request.contextPath}/letan/the-tu/doi-trang-thai" method="post" class="d-inline">
                                                                            <input type="hidden" name="id" value="${row[0]}">
                                                                            <input type="hidden" name="trangThaiMoi" value="TamKhoa">
                                                                            <button type="submit" class="btn btn-outline-warning">🟡 Khoá</button>
                                                                        </form>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <form action="${pageContext.request.contextPath}/letan/the-tu/doi-trang-thai" method="post" class="d-inline">
                                                                            <input type="hidden" name="id" value="${row[0]}">
                                                                            <input type="hidden" name="trangThaiMoi" value="DangSuDung">
                                                                            <button type="submit" class="btn btn-outline-success">🟢 Mở</button>
                                                                        </form>
                                                                    </c:otherwise>
                                                                </c:choose>

                                                                <!-- REVOKE BUTTON -->
                                                                <form action="${pageContext.request.contextPath}/letan/the-tu/doi-trang-thai" method="post" class="d-inline form-revoke-card">
                                                                    <input type="hidden" name="id" value="${row[0]}">
                                                                    <input type="hidden" name="trangThaiMoi" value="DaThuHoi">
                                                                    <button type="submit" class="btn btn-outline-danger">🔴 Thu hồi</button>
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
                                        <td colspan="9" class="text-center text-muted py-4">Không tìm thấy thẻ từ nào.</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>

        </div>
    </div>

    <!-- MODAL CẤP THẺ TỪ MỚI -->
    <div class="modal fade" id="modalCapThe" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <form action="${pageContext.request.contextPath}/letan/the-tu/cap" method="post">
                    <div class="modal-header">
                        <h5 class="modal-title fw-bold text-success">➕ Cấp Thẻ Từ Mới</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label fw-bold">Chọn Căn Hộ (*):</label>
                            <select name="maCanHo" id="selectCanHoCap" class="form-select" required>
                                <option value="">-- Chọn Căn Hộ --</option>
                                <c:forEach var="c" items="${dsCanHo}">
                                    <option value="${c[0]}">Căn ${c[1]}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold">Người Sử Dụng Thẻ (Cư Dân):</label>
                            <select name="maCuDan" id="selectCuDanCap" class="form-select">
                                <option value="">-- Thẻ dùng chung của căn hộ --</option>
                            </select>
                            <small class="text-muted">Chọn cư dân cụ thể hoặc để trống nếu là thẻ dùng chung của căn hộ.</small>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold">Số Thẻ Từ (*):</label>
                            <input type="text" name="soThe" class="form-control" placeholder="Ví dụ: THE-0101-03" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold">Ngày Hết Hạn (Để trống nếu Vô hạn):</label>
                            <input type="date" name="ngayHetHan" class="form-control">
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold">Phân Quyền Chức Năng Thẻ:</label>
                            <div class="row g-2">
                                <div class="col-6"><div class="form-check"><input class="form-check-input" type="checkbox" name="chucNang" value="CuaChinh" checked id="cnCap1"><label class="form-check-label" for="cnCap1">Cửa chính</label></div></div>
                                <div class="col-6"><div class="form-check"><input class="form-check-input" type="checkbox" name="chucNang" value="ThangMay" checked id="cnCap2"><label class="form-check-label" for="cnCap2">Thang máy</label></div></div>
                                <div class="col-6"><div class="form-check"><input class="form-check-input" type="checkbox" name="chucNang" value="BaiXeOTo" id="cnCap3"><label class="form-check-label" for="cnCap3">Bãi xe ô tô</label></div></div>
                                <div class="col-6"><div class="form-check"><input class="form-check-input" type="checkbox" name="chucNang" value="BaiXeMay" id="cnCap4"><label class="form-check-label" for="cnCap4">Bãi xe máy</label></div></div>
                                <div class="col-6"><div class="form-check"><input class="form-check-input" type="checkbox" name="chucNang" value="HoBoi" id="cnCap5"><label class="form-check-label" for="cnCap5">Hồ bơi</label></div></div>
                                <div class="col-6"><div class="form-check"><input class="form-check-input" type="checkbox" name="chucNang" value="PhongGym" id="cnCap6"><label class="form-check-label" for="cnCap6">Phòng Gym</label></div></div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                        <button type="submit" class="btn btn-success">💾 Cấp Thẻ Từ</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- MODAL SỬA THẺ TỪ -->
    <div class="modal fade" id="modalSuaThe" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <form action="${pageContext.request.contextPath}/letan/the-tu/sua" method="post">
                    <input type="hidden" name="id" id="editTheId">
                    <div class="modal-header">
                        <h5 class="modal-title fw-bold text-primary">✏️ Cập Nhật Thông Tin Thẻ Từ</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div class="alert alert-light border py-2 mb-3">
                            📌 <b>Số thẻ:</b> <span id="editSoTheText" class="text-primary fw-bold"></span> 
                            | <b>Căn hộ:</b> <span id="editSoPhongText" class="fw-bold"></span>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold">Người Sử Dụng Thẻ (Cư Dân):</label>
                            <select name="maCuDan" id="selectCuDanSua" class="form-select">
                                <option value="">-- Thẻ dùng chung của căn hộ --</option>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold">Ngày Hết Hạn (Để trống nếu Vô hạn):</label>
                            <input type="date" name="ngayHetHan" id="editNgayHetHan" class="form-control">
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold">Phân Quyền Chức Năng Thẻ:</label>
                            <div class="row g-2">
                                <div class="col-6"><div class="form-check"><input class="form-check-input cn-edit-check" type="checkbox" name="chucNang" value="CuaChinh" id="cnSua1"><label class="form-check-label" for="cnSua1">Cửa chính</label></div></div>
                                <div class="col-6"><div class="form-check"><input class="form-check-input cn-edit-check" type="checkbox" name="chucNang" value="ThangMay" id="cnSua2"><label class="form-check-label" for="cnSua2">Thang máy</label></div></div>
                                <div class="col-6"><div class="form-check"><input class="form-check-input cn-edit-check" type="checkbox" name="chucNang" value="BaiXeOTo" id="cnSua3"><label class="form-check-label" for="cnSua3">Bãi xe ô tô</label></div></div>
                                <div class="col-6"><div class="form-check"><input class="form-check-input cn-edit-check" type="checkbox" name="chucNang" value="BaiXeMay" id="cnSua4"><label class="form-check-label" for="cnSua4">Bãi xe máy</label></div></div>
                                <div class="col-6"><div class="form-check"><input class="form-check-input cn-edit-check" type="checkbox" name="chucNang" value="HoBoi" id="cnSua5"><label class="form-check-label" for="cnSua5">Hồ bơi</label></div></div>
                                <div class="col-6"><div class="form-check"><input class="form-check-input cn-edit-check" type="checkbox" name="chucNang" value="PhongGym" id="cnSua6"><label class="form-check-label" for="cnSua6">Phòng Gym</label></div></div>
                            </div>
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
            const contextPath = '${pageContext.request.contextPath}';

            // Helper to load resident dropdown dynamically
            function loadCuDanForCanHo(canHoId, selectEl, selectedCuDanId) {
                if (!canHoId) {
                    selectEl.innerHTML = '<option value="">-- Thẻ dùng chung của căn hộ --</option>';
                    return;
                }

                fetch(contextPath + '/letan/the-tu/cu-dan?maCanHo=' + canHoId)
                    .then(res => res.json())
                    .then(data => {
                        let html = '<option value="">-- Thẻ dùng chung của căn hộ --</option>';
                        if (data && data.length > 0) {
                            data.forEach(cd => {
                                const roleLabel = cd.loaiCuDan === 'ChuHo' ? 'Chủ hộ' : 'Khách thuê';
                                const isSel = (selectedCuDanId && parseInt(selectedCuDanId) === cd.id) ? ' selected' : '';
                                html += '<option value="' + cd.id + '"' + isSel + '>👤 ' + cd.hoTen + ' (' + roleLabel + ')</option>';
                            });
                        }
                        selectEl.innerHTML = html;
                    })
                    .catch(err => console.error('Lỗi khi tải danh sách cư dân:', err));
            }

            // On change apartment in new card modal
            const selectCanHoCap = document.getElementById('selectCanHoCap');
            const selectCuDanCap = document.getElementById('selectCuDanCap');
            if (selectCanHoCap && selectCuDanCap) {
                selectCanHoCap.addEventListener('change', function () {
                    loadCuDanForCanHo(this.value, selectCuDanCap, null);
                });
            }

            // Revoke card confirmation
            const revokeForms = document.querySelectorAll('.form-revoke-card');
            revokeForms.forEach(form => {
                form.addEventListener('submit', function (e) {
                    const ok = confirm('⚠️ THAO TÁC CỰC KỲ QUAN TRỌNG!\nThu hồi thẻ từ là KHÔNG THỂ HOÀN TÁC và sẽ tự động gỡ liên kết tất cả xe đang gắn thẻ này.\n\nBạn có chắc chắn muốn thu hồi thẻ này không?');
                    if (!ok) {
                        e.preventDefault();
                    }
                });
            });

            // Edit modal handling
            const editButtons = document.querySelectorAll('.btn-edit-card');
            const editModalEl = document.getElementById('modalSuaThe');
            const editTheId = document.getElementById('editTheId');
            const editSoTheText = document.getElementById('editSoTheText');
            const editSoPhongText = document.getElementById('editSoPhongText');
            const editNgayHetHan = document.getElementById('editNgayHetHan');
            const selectCuDanSua = document.getElementById('selectCuDanSua');

            if (editButtons && editModalEl && editTheId && editSoTheText && editSoPhongText && selectCuDanSua) {
                const editModal = new bootstrap.Modal(editModalEl);
                editButtons.forEach(btn => {
                    btn.addEventListener('click', function () {
                        const id = this.getAttribute('data-id');
                        const soThe = this.getAttribute('data-sothe');
                        const canHoId = this.getAttribute('data-canho');
                        const soPhong = this.getAttribute('data-sophong');
                        const cuDanId = this.getAttribute('data-cudan');
                        const hetHan = this.getAttribute('data-hethan');
                        const chucNangStr = this.getAttribute('data-chucnang') || '';

                        editTheId.value = id;
                        editSoTheText.innerText = soThe || '';
                        editSoPhongText.innerText = 'Căn ' + (soPhong || '');
                        editNgayHetHan.value = hetHan || '';

                        loadCuDanForCanHo(canHoId, selectCuDanSua, cuDanId);

                        // Set checkboxes
                        const cnList = chucNangStr.split(',');
                        document.querySelectorAll('.cn-edit-check').forEach(chk => {
                            chk.checked = cnList.includes(chk.value);
                        });

                        editModal.show();
                    });
                });
            }
        });
    </script>
</body>
</html>
