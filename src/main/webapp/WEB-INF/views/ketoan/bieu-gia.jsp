<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="util.DisplayUtil" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/WEB-INF/views/common/head.jsp" %>
    <title>Quản Lý Biểu Giá Dịch Vụ - PolyBuilding Kế Toán</title>

    <style>
:root {
            --bg-primary: #1E3B34;
            --bg-accent: #B98A46;
            --bg-cream: #F4EFE4;
            --text-dark: #2C3E50;
        }
        body {
            background-color: var(--bg-cream);
            color: var(--text-dark);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .card-custom {
            background-color: white;
            border-radius: 12px;
            border: none;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            padding: 25px;
            margin-bottom: 25px;
        }
        .table-custom th {
            background-color: #f8f9fa;
            color: var(--bg-primary);
            font-weight: 600;
        }
        .btn-gold {
            background-color: var(--bg-accent);
            color: white;
            border: none;
            font-weight: 600;
        }
        .btn-gold:hover {
            background-color: #a07639;
            color: white;
        }
        .btn-success {
            background-color: var(--bg-primary);
            color: white;
            border: none;
            font-weight: 600;
        }
        .btn-success:hover {
            background-color: #152b26;
            color: white;
        }
    </style>
</head>
<body>

<div class="layout-wrapper">
    <jsp:include page="/WEB-INF/views/ketoan/common/sidebar.jsp" />

    <div class="main-content">
        <jsp:include page="/WEB-INF/views/ketoan/common/header.jsp" />

        <c:if test="${not empty param.msg}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                ✅ <c:out value="${param.msg}" />
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <c:if test="${not empty param.error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                ❌ <strong>Lỗi:</strong> <c:out value="${param.error}" />
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Banner Cảnh Báo Hở Bậc -->
        <c:if test="${not empty warnings}">
            <div class="alert alert-warning border-start border-4 border-warning shadow-sm mb-4">
                <h6 class="fw-bold text-dark mb-2">⚠️ Cảnh Báo Hở Bậc Cần Kiểm Tra:</h6>
                <ul class="mb-0 ps-3">
                    <c:forEach var="w" items="${warnings}">
                        <li><c:out value="${w}" /></li>
                    </c:forEach>
                </ul>
            </div>
        </c:if>

        <!-- Header Card -->
        <div class="card-custom">
            <div class="d-flex justify-content-between align-items-center flex-wrap gap-3">
                <div>
                    <h5 class="fw-bold m-0" style="color: var(--bg-primary);">
                        🏷️ Quan Lý Biểu Giá Dịch Vụ Căn Hộ
                    </h5>
                    <small class="text-muted">Biểu giá theo bậc thang và lịch sử áp dụng theo ngày hiệu lực</small>
                </div>
                <button type="button" class="btn btn-gold px-3 py-2" onclick="openAddModal()">
                    ➕ Thêm Biểu Giá Mới
                </button>
            </div>
        </div>

        <!-- Bảng Danh Sách Biểu Giá -->
        <div class="card-custom">
            <div class="table-responsive">
                <table class="table table-hover table-bordered table-custom align-middle">
                    <thead>
                    <tr>
                        <th>Loại Dịch Vụ</th>
                        <th class="text-center">Bậc Từ</th>
                        <th class="text-center">Bậc Đến</th>
                        <th class="text-end">Đơn Giá</th>
                        <th class="text-center">Đơn Vị</th>
                        <th class="text-center">Ngày Hiệu Lực</th>
                        <th class="text-center">Trạng Thái</th>
                        <th>Nguồn Giá / Ghi Chú</th>
                        <th class="text-center">Thao Tác</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${not empty allPrices}">
                            <c:set var="prevLoai" value="" />
                            <c:forEach var="b" items="${allPrices}">
                                <c:if test="${b.loaiDichVu != prevLoai}">
                                    <c:set var="prevLoai" value="${b.loaiDichVu}" />
                                    <tr style="background-color: #EAE3D2;">
                                        <td colspan="9" class="fw-bold py-2 px-3 text-dark fs-6">
                                            📌 Biểu Giá: ${DisplayUtil.getLoaiDichVuText(b.loaiDichVu)}
                                        </td>
                                    </tr>
                                </c:if>
                                <tr>
                                    <td class="fw-bold text-primary ps-4">
                                        ${DisplayUtil.getLoaiDichVuText(b.loaiDichVu)}
                                    </td>
                                    <td class="text-center fw-semibold">${b.bacTu}</td>
                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${not empty b.bacDen}">${b.bacDen}</c:when>
                                            <c:otherwise><span class="badge bg-secondary">trở lên</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-end fw-bold text-success">
                                        ${DisplayUtil.formatTien(b.donGia)}
                                    </td>
                                    <td class="text-center text-muted small">
                                        ${DisplayUtil.getDonViGiaText(b.loaiDichVu)}
                                    </td>
                                    <td class="text-center fw-semibold">${b.hieuLucTu}</td>
                                    <td class="text-center">
                                        <c:set var="activeDate" value="${activeDates[b.loaiDichVu]}" />
                                        <c:choose>
                                            <c:when test="${not empty activeDate && b.hieuLucTu.equals(activeDate)}">
                                                <span class="badge bg-success">Đang áp dụng</span>
                                            </c:when>
                                            <c:when test="${b.hieuLucTu.isAfter(today)}">
                                                <span class="badge bg-warning text-dark">Sẽ áp dụng từ ${b.hieuLucTu}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary">Hết hiệu lực</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <small class="text-muted"><c:out value="${b.nguonGia}" default="—" /></small>
                                    </td>
                                    <td class="text-center text-nowrap">
                                        <button class="btn btn-sm btn-outline-primary me-1"
                                                onclick="openEditModal(${b.id}, '${b.loaiDichVu}', '${b.bacTu}', '${b.bacDen != null ? b.bacDen : ''}', '${b.donGia}', '${b.hieuLucTu}', '${b.nguonGia != null ? b.nguonGia : ''}')">
                                            ✏️ Sửa
                                        </button>
                                        <form action="${pageContext.request.contextPath}/ketoan/bieu-gia/xoa" method="post" class="d-inline"
                                              onsubmit="return confirm('Bạn có chắc chắn muốn xóa dòng biểu giá này?');">
                                            <input type="hidden" name="id" value="${b.id}">
                                            <button type="submit" class="btn btn-sm btn-outline-danger">
                                                🗑️ Xóa
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="9" class="text-center text-muted py-4">Chưa có biểu giá nào.</td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<!-- Modal Thêm / Sửa Biểu Giá -->
<div class="modal fade" id="modalBieuGia" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/ketoan/bieu-gia/them" method="post" id="formBieuGia">
                <div class="modal-header bg-emerald text-white" style="background-color: var(--bg-primary);">
                    <h5 class="modal-title fw-bold text-white" id="modalTitle">➕ Thêm Biểu Giá Mới</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" name="id" id="bgId">

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Loại dịch vụ:</label>
                        <select name="loaiDichVu" id="bgLoai" class="form-select" onchange="onLoaiChanged()">
                            <option value="Dien">Điện (đ/kWh)</option>
                            <option value="Nuoc">Nước (đ/m³)</option>
                            <option value="PhiQuanLy">Phí quản lý (đ/m²/tháng)</option>
                            <option value="GuiXeOTo">Gửi xe ô tô (đ/xe/tháng)</option>
                            <option value="GuiXeMay">Gửi xe máy (đ/xe/tháng)</option>
                        </select>
                    </div>

                    <div class="row g-3 mb-3">
                        <div class="col-6">
                            <label class="form-label fw-semibold">Bậc từ:</label>
                            <input type="number" step="0.01" min="0" name="bacTu" id="bgBacTu" class="form-control" value="0" required>
                        </div>
                        <div class="col-6">
                            <label class="form-label fw-semibold">Bậc đến (để trống = Trở lên):</label>
                            <input type="number" step="0.01" min="0" name="bacDen" id="bgBacDen" class="form-control" placeholder="Trở lên (NULL)">
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Đơn giá (VNĐ):</label>
                        <input type="number" step="0.01" min="1" name="donGia" id="bgDonGia" class="form-control" placeholder="Ví dụ: 8000" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Ngày bắt đầu hiệu lực:</label>
                        <input type="date" name="hieuLucTu" id="bgHieuLuc" class="form-control" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Nguồn giá / Ghi chú:</label>
                        <textarea name="nguonGia" id="bgNguonGia" class="form-control" rows="2" placeholder="Ví dụ: Quy định BQL số 12/QĐ..."></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-gold">💾 Lưu Biểu Giá</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    let bieuGiaModal;

    document.addEventListener('DOMContentLoaded', function() {
        bieuGiaModal = new bootstrap.Modal(document.getElementById('modalBieuGia'));
    });

    function onLoaiChanged() {
        const loai = document.getElementById('bgLoai').value;
        const isFlat = (loai === 'PhiQuanLy' || loai === 'GuiXeOTo' || loai === 'GuiXeMay');
        const inputTu = document.getElementById('bgBacTu');
        const inputDen = document.getElementById('bgBacDen');

        if (isFlat) {
            inputTu.value = "0";
            inputTu.readOnly = true;
            inputDen.value = "";
            inputDen.readOnly = true;
            inputDen.placeholder = "NULL (Không dùng bậc)";
        } else {
            inputTu.readOnly = false;
            inputDen.readOnly = false;
            inputDen.placeholder = "Trở lên (NULL)";
        }
    }

    function openAddModal() {
        document.getElementById('formBieuGia').action = "${pageContext.request.contextPath}/ketoan/bieu-gia/them";
        document.getElementById('modalTitle').innerText = "➕ Thêm Biểu Giá Mới";
        document.getElementById('bgId').value = "";
        document.getElementById('bgLoai').value = "Dien";
        document.getElementById('bgBacTu').value = "0";
        document.getElementById('bgBacDen').value = "";
        document.getElementById('bgDonGia').value = "";
        document.getElementById('bgHieuLuc').valueAsDate = new Date();
        document.getElementById('bgNguonGia').value = "";
        onLoaiChanged();
        bieuGiaModal.show();
    }

    function openEditModal(id, loai, bacTu, bacDen, donGia, hieuLuc, nguonGia) {
        document.getElementById('formBieuGia').action = "${pageContext.request.contextPath}/ketoan/bieu-gia/sua";
        document.getElementById('modalTitle').innerText = "✏️ Chỉnh Sửa Biểu Giá #" + id;
        document.getElementById('bgId').value = id;
        document.getElementById('bgLoai').value = loai;
        document.getElementById('bgBacTu').value = bacTu;
        document.getElementById('bgBacDen').value = bacDen;
        document.getElementById('bgDonGia').value = donGia;
        document.getElementById('bgHieuLuc').value = hieuLuc;
        document.getElementById('bgNguonGia').value = nguonGia;
        onLoaiChanged();
        bieuGiaModal.show();
    }
</script>
</body>
</html>
