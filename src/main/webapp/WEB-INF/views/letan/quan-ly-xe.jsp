<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="util.DisplayUtil" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/WEB-INF/views/common/head.jsp" %>
    <title>Quản Lý Phương Tiện & Xe — PolyBuilding Lễ Tân</title>

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
                <h2>Quản Lý Phương Tiện & Xe Cư Dân</h2>
                <span class="sub">Đăng ký biển số xe, phân loại phương tiện và liên kết thẻ từ gửi xe</span>
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

            <!-- SEARCH & ACTIONS -->
            <div class="card-custom">
                <div class="card-header-custom">
                    <form action="${pageContext.request.contextPath}/letan/quan-ly-xe" method="get" class="d-flex gap-2 align-items-center flex-grow-1 me-3">
                        <input type="text" name="tuKhoa" class="form-control form-control-sm" placeholder="Tìm theo biển số xe, số phòng..." value="${tuKhoa}" style="max-width: 300px;">
                        <select name="loaiXe" class="form-select form-select-sm" style="max-width: 180px;">
                            <option value="">-- Tất cả loại xe --</option>
                            <option value="OTo" ${loaiXeChon == 'OTo' ? 'selected' : ''}>Ô tô</option>
                            <option value="XeMay" ${loaiXeChon == 'XeMay' ? 'selected' : ''}>Xe máy</option>
                            <option value="XeDap" ${loaiXeChon == 'XeDap' ? 'selected' : ''}>Xe đạp</option>
                        </select>
                        <button type="submit" class="btn btn-sm btn-secondary">🔍 Tìm kiếm</button>
                    </form>

                    <button type="button" class="btn btn-sm btn-success" data-bs-toggle="modal" data-bs-target="#modalThemXe">
                        ➕ Đăng Ký Xe Mới
                    </button>
                </div>

                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle m-0">
                            <thead class="table-light">
                                <tr>
                                    <th class="ps-3">Biển Số Xe</th>
                                    <th>Loại Xe</th>
                                    <th>Căn Hộ</th>
                                    <th>Chủ Hộ</th>
                                    <th>Thẻ Từ Gắn Kèm</th>
                                    <th>Trạng Thái Thẻ</th>
                                    <th class="pe-3">Thao Tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty xeList}">
                                        <c:forEach var="row" items="${xeList}">
                                            <tr>
                                                <td class="ps-3 fw-bold text-dark fs-6">
                                                    ${DisplayUtil.getLoaiXeIcon(row[2])} <c:out value="${row[1]}"/>
                                                </td>
                                                <td><span class="badge bg-light text-dark border">${DisplayUtil.getLoaiXeText(row[2])}</span></td>
                                                <td><span class="badge bg-secondary">Căn <c:out value="${row[3]}"/></span></td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty row[5]}">👤 <c:out value="${row[5]}"/></c:when>
                                                        <c:otherwise><span class="text-muted">—</span></c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty row[4]}">
                                                            <span class="fw-semibold text-primary">🪪 <c:out value="${row[4]}"/></span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-muted small">Chưa gắn thẻ</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty row[6]}">
                                                            <span class="badge ${DisplayUtil.getTrangThaiTheBadgeClass(row[6])}">
                                                                ${DisplayUtil.getTrangThaiTheText(row[6])}
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise><span class="text-muted">—</span></c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="pe-3">
                                                    <div class="btn-group btn-group-sm">
                                                        <button type="button" class="btn btn-outline-primary btn-edit-xe"
                                                                data-id="${row[0]}"
                                                                data-bienso="${row[1]}"
                                                                data-loaixe="${row[2]}"
                                                                data-canho="${row[7]}"
                                                                data-sophong="${row[3]}"
                                                                data-mathe="${row[8]}">
                                                            ✏️ Sửa
                                                        </button>
                                                        <form action="${pageContext.request.contextPath}/letan/quan-ly-xe/xoa" method="post" class="d-inline form-delete-xe">
                                                            <input type="hidden" name="id" value="${row[0]}">
                                                            <button type="submit" class="btn btn-outline-danger">🗑️ Xóa</button>
                                                        </form>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="7" class="text-center text-muted py-4">Không tìm thấy phương tiện nào.</td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

        </div>
    </div>

    <!-- MODAL ĐĂNG KÝ XE MỚI -->
    <div class="modal fade" id="modalThemXe" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <form action="${pageContext.request.contextPath}/letan/quan-ly-xe/them" method="post">
                    <div class="modal-header">
                        <h5 class="modal-title fw-bold text-success">➕ Đăng Ký Phương Tiện Mới</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label fw-bold">Chọn Căn Hộ (*):</label>
                            <select name="maCanHo" id="selectCanHoXeThem" class="form-select" required>
                                <option value="">-- Chọn Căn Hộ --</option>
                                <c:forEach var="c" items="${dsCanHo}">
                                    <option value="${c[0]}">Căn ${c[1]}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold">Biển Số Xe (*):</label>
                            <input type="text" name="bienSoXe" class="form-control" placeholder="Ví dụ: 30A-123.45 hoặc 29H1-678.90" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold">Loại Phương Tiện (*):</label>
                            <select name="loaiXe" class="form-select" required>
                                <option value="OTo">🚗 Ô tô</option>
                                <option value="XeMay" selected>🏍️ Xe máy</option>
                                <option value="XeDap">🚲 Xe đạp</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold">Gắn Thẻ Từ (Tùy chọn):</label>
                            <select name="maThe" id="selectTheTuThem" class="form-select">
                                <option value="">-- Chưa gắn thẻ --</option>
                            </select>
                            <small class="text-muted">Chỉ hiển thị các thẻ từ đang ở trạng thái 'Đang sử dụng' của căn hộ đó.</small>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                        <button type="submit" class="btn btn-success">💾 Đăng Ký Xe</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- MODAL SỬA THÔNG TIN XE -->
    <div class="modal fade" id="modalSuaXe" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <form action="${pageContext.request.contextPath}/letan/quan-ly-xe/sua" method="post">
                    <input type="hidden" name="id" id="editXeId">
                    <div class="modal-header">
                        <h5 class="modal-title fw-bold text-primary">✏️ Cập Nhật Thông Tin Xe</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div class="alert alert-light border py-2 mb-3">
                            📌 <b>Căn hộ:</b> <span id="editSoPhongXeText" class="fw-bold text-primary"></span>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold">Biển Số Xe (*):</label>
                            <input type="text" name="bienSoXe" id="editBienSoXe" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold">Loại Phương Tiện (*):</label>
                            <select name="loaiXe" id="editLoaiXe" class="form-select" required>
                                <option value="OTo">🚗 Ô tô</option>
                                <option value="XeMay">🏍️ Xe máy</option>
                                <option value="XeDap">🚲 Xe đạp</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold">Gắn Thẻ Từ (Tùy chọn):</label>
                            <select name="maThe" id="selectTheTuSua" class="form-select">
                                <option value="">-- Chưa gắn thẻ --</option>
                            </select>
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

            // Delete vehicle confirmation
            const deleteForms = document.querySelectorAll('.form-delete-xe');
            deleteForms.forEach(form => {
                form.addEventListener('submit', function (e) {
                    if (!confirm('Bạn có chắc chắn muốn xóa thông tin phương tiện này khỏi hệ thống không?')) {
                        e.preventDefault();
                    }
                });
            });

            // Load cards for apartment helper
            function loadCardsForCanHo(canHoId, selectEl, selectedTheId) {
                if (!canHoId) {
                    selectEl.innerHTML = '<option value="">-- Chưa gắn thẻ --</option>';
                    return;
                }

                fetch(contextPath + '/letan/quan-ly-xe/the-tu?maCanHo=' + canHoId)
                    .then(res => res.json())
                    .then(data => {
                        let html = '<option value="">-- Chưa gắn thẻ --</option>';
                        if (data && data.length > 0) {
                            data.forEach(c => {
                                const isSel = (selectedTheId && parseInt(selectedTheId) === c.id) ? ' selected' : '';
                                html += '<option value="' + c.id + '"' + isSel + '>🪪 ' + c.soThe + '</option>';
                            });
                        }
                        selectEl.innerHTML = html;
                    })
                    .catch(err => console.error('Lỗi khi tải danh sách thẻ:', err));
            }

            // On change selectCanHoXeThem
            const selectCanHoXeThem = document.getElementById('selectCanHoXeThem');
            const selectTheTuThem = document.getElementById('selectTheTuThem');
            if (selectCanHoXeThem && selectTheTuThem) {
                selectCanHoXeThem.addEventListener('change', function () {
                    loadCardsForCanHo(this.value, selectTheTuThem, null);
                });
            }

            // Edit vehicle modal
            const editButtons = document.querySelectorAll('.btn-edit-xe');
            const editModalEl = document.getElementById('modalSuaXe');
            const editXeId = document.getElementById('editXeId');
            const editSoPhongXeText = document.getElementById('editSoPhongXeText');
            const editBienSoXe = document.getElementById('editBienSoXe');
            const editLoaiXe = document.getElementById('editLoaiXe');
            const selectTheTuSua = document.getElementById('selectTheTuSua');

            if (editButtons && editModalEl && editXeId && editBienSoXe && editLoaiXe && selectTheTuSua) {
                const editModal = new bootstrap.Modal(editModalEl);
                editButtons.forEach(btn => {
                    btn.addEventListener('click', function () {
                        const id = this.getAttribute('data-id');
                        const bienSo = this.getAttribute('data-bienso');
                        const loaiXe = this.getAttribute('data-loaixe');
                        const canHoId = this.getAttribute('data-canho');
                        const soPhong = this.getAttribute('data-sophong');
                        const maThe = this.getAttribute('data-mathe');

                        editXeId.value = id;
                        editBienSoXe.value = bienSo || '';
                        editLoaiXe.value = loaiXe || 'XeMay';
                        editSoPhongXeText.innerText = 'Căn ' + (soPhong || '');

                        loadCardsForCanHo(canHoId, selectTheTuSua, maThe);
                        editModal.show();
                    });
                });
            }
        });
    </script>
</body>
</html>
