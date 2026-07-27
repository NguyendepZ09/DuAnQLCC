<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Tạo & Quản Lý Bình Chọn — Ban Quản Lý</title>
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
            <h4 class="text-dark fw-bold mb-4">🗳️ Quản Lý Bình Chọn & Khảo Sát Ý Kiến Cư Dân</h4>

            <!-- Alert messages -->
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger alert-dismissible fade show mb-4" role="alert">
                    <strong>⚠️ Lỗi:</strong> ${errorMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            <c:if test="${not empty successMessage}">
                <div class="alert alert-success alert-dismissible fade show mb-4" role="alert">
                    <strong>✅ Thành công:</strong> ${successMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <div class="row g-4">
                <!-- Create Poll Form -->
                <div class="col-lg-4">
                    <div class="card-custom">
                        <h5 class="fw-bold mb-3 text-dark">✍️ Tạo Cuộc Bình Chọn Mới</h5>
                        <form action="${pageContext.request.contextPath}/banquanly/binh-chon" method="post">
                            <div class="mb-3">
                                <label class="form-label font-semibold">Câu Hỏi Bình Chọn / Khảo Sát</label>
                                <input type="text" name="cauHoi" class="form-control" placeholder="vd: Bạn đồng ý mở rộng sân Pickleball không?" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label font-semibold">Thông Báo Đính Kèm (Liên Quan)</label>
                                <select name="maThongBao" class="form-select" required>
                                    <c:choose>
                                        <c:when test="${not empty danhSachThongBao}">
                                            <c:forEach var="tb" items="${danhSachThongBao}">
                                                <option value="${tb.id}">[TB-${tb.id}] ${tb.tieuDe}</option>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <option value="">-- Chưa có thông báo trong hệ thống --</option>
                                        </c:otherwise>
                                    </c:choose>
                                </select>
                            </div>

                            <div class="row g-2 mb-3">
                                <div class="col-12 mb-2">
                                    <label class="form-label font-semibold" for="hanChot">Hạn Chót Bỏ Phiếu <span class="text-danger">*</span></label>
                                    <input type="datetime-local" id="hanChot" name="hanChot" class="form-control" required>
                                    <div class="form-text text-muted">Phải sau thời điểm hiện tại.</div>
                                </div>
                                <div class="col-12">
                                    <label class="form-label font-semibold" for="tyLeTucSo">Tỷ Lệ Túc Số (%) <span class="text-danger">*</span></label>
                                    <input type="number" id="tyLeTucSo" name="tyLeTucSo" class="form-control" value="50" min="1" max="100" step="0.1" required>
                                    <div class="form-text text-muted">% căn hộ cần tham gia để hợp lệ.</div>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label font-semibold d-flex justify-content-between">
                                    <span>Danh Sách Phương Án Lựa Chọn</span>
                                    <button type="button" class="btn btn-sm btn-outline-success py-0" onclick="addOption()">+ Thêm</button>
                                </label>
                                <div id="optionsContainer">
                                    <input type="text" name="phuongAn" class="form-control mb-2" placeholder="Phương án 1 (vd: Đồng ý)" required>
                                    <input type="text" name="phuongAn" class="form-control mb-2" placeholder="Phương án 2 (vd: Không đồng ý)" required>
                                </div>
                            </div>
                            
                            <button type="submit" class="btn btn-warning w-100 fw-bold py-2 text-dark">🚀 Mở Bình Chọn Trực Tuyến</button>
                        </form>
                    </div>
                </div>

                <!-- Existing Polls List -->
                <div class="col-lg-8">
                    <div class="card-custom">
                        <h5 class="fw-bold mb-3 text-dark">📊 Danh Sách Các Cuộc Bình Chọn</h5>
                        <c:choose>
                            <c:when test="${not empty pollViews}">
                                <div class="table-responsive">
                                    <table class="table table-hover align-middle">
                                        <thead class="table-light">
                                            <tr>
                                                <th style="width: 50px;">ID</th>
                                                <th>Câu Hỏi Khảo Sát</th>
                                                <th class="text-center" style="width: 120px;">Túc Số Yêu Cầu</th>
                                                <th class="text-center" style="width: 150px;">Đã Tham Gia</th>
                                                <th class="text-center" style="width: 130px;">Trạng Thái</th>
                                                <th class="text-center" style="width: 140px;">Thao Tác / Kết Quả</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="item" items="${pollViews}">
                                                <c:set var="bc" value="${item.binhChon}" />
                                                <c:set var="st" value="${item.stats}" />
                                                <c:set var="isClosed" value="${bc.trangThai == 'DaDong' || bc.trangThai == 'KhongDuTucSo'}" />

                                                <tr>
                                                    <td><strong>${bc.id}</strong></td>
                                                    <td>
                                                        <div><strong>${bc.cauHoi}</strong></div>
                                                        <small class="text-muted">⏳ Hạn chót: ${item.hanChotFormatted}</small>
                                                    </td>
                                                    <td class="text-center">
                                                        <span class="badge bg-secondary">${bc.tyLeTucSo}%</span>
                                                    </td>
                                                    <td class="text-center">
                                                        <span class="badge ${st.tyLeThamGia >= bc.tyLeTucSo ? 'bg-success' : 'bg-warning text-dark'}">
                                                            ${st.canDaBau}/${st.tongCan} căn (${st.tyLeThamGiaFormatted}%)
                                                        </span>
                                                    </td>
                                                    <td class="text-center">
                                                        <c:choose>
                                                            <c:when test="${bc.trangThai == 'DangMo'}">
                                                                <span class="badge bg-success">🟢 Đang mở</span>
                                                            </c:when>
                                                            <c:when test="${bc.trangThai == 'DaDong'}">
                                                                <span class="badge bg-secondary">⚫ Đã đóng</span>
                                                            </c:when>
                                                            <c:when test="${bc.trangThai == 'KhongDuTucSo'}">
                                                                <span class="badge bg-danger">❌ Không đủ túc số</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-secondary">${bc.trangThai}</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td class="text-center">
                                                        <c:choose>
                                                            <c:when test="${!isClosed}">
                                                                <!-- E4: Nut Dong Binh Chon -->
                                                                <form action="${pageContext.request.contextPath}/banquanly/dong-binh-chon" method="post" onsubmit="return confirm('Bạn có chắc chắn muốn ĐÓNG cuộc bình chọn này và tổng kết kết quả?');">
                                                                    <input type="hidden" name="maBinhChon" value="${bc.id}">
                                                                    <button type="submit" class="btn btn-sm btn-outline-danger fw-bold">🛑 Đóng BQL</button>
                                                                </form>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <!-- E5: Nut Xem Ket Qua Chi Tiet -->
                                                                <button class="btn btn-sm btn-primary fw-bold" type="button" data-bs-toggle="collapse" data-bs-target="#ketqua_${bc.id}">
                                                                    📊 Xem Kết Quả
                                                                </button>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                </tr>

                                                <!-- E5: Detail Accordion for Closed Poll Results -->
                                                <c:if test="${isClosed}">
                                                    <tr class="collapse" id="ketqua_${bc.id}">
                                                        <td colspan="6" class="p-0">
                                                            <div class="p-3 bg-light border-start border-4 border-primary m-2 rounded">
                                                                <h6 class="fw-bold text-primary mb-2">📊 Kết Quả Chi Tiết (Cuộc #${bc.id})</h6>
                                                                <p class="mb-2"><strong>Kết luận:</strong> ${bc.ketQua}</p>
                                                                
                                                                <table class="table table-sm table-bordered bg-white align-middle mb-0 mt-2">
                                                                    <thead class="table-secondary">
                                                                        <tr>
                                                                            <th>Phương Án Lựa Chọn</th>
                                                                            <th class="text-center" style="width: 140px;">Số Phiếu Bầu</th>
                                                                        </tr>
                                                                    </thead>
                                                                    <tbody>
                                                                        <c:forEach var="kq" items="${item.ketQuaViewList}">
                                                                            <tr>
                                                                                <td>${kq.phuongAn}</td>
                                                                                <td class="text-center fw-bold text-primary">${kq.soPhieu} phiếu</td>
                                                                            </tr>
                                                                        </c:forEach>
                                                                    </tbody>
                                                                </table>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </c:if>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center py-5 text-muted">
                                    📭 Chưa có cuộc bình chọn nào trong hệ thống.
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>

<script>
    function addOption() {
        const container = document.getElementById('optionsContainer');
        const count = container.children.length + 1;
        const input = document.createElement('input');
        input.type = 'text';
        input.name = 'phuongAn';
        input.className = 'form-control mb-2';
        input.placeholder = `Phương án ${count}`;
        container.appendChild(input);
    }
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
