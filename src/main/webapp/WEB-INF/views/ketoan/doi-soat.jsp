<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="util.DisplayUtil" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đối Soát Sao Kê Ngân Hàng — PolyBuilding Kế Toán</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
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
        .layout-wrapper {
            display: flex;
            min-height: 100vh;
        }
        .sidebar {
            width: 260px;
            background-color: var(--bg-primary);
            color: white;
            padding: 20px 0;
            flex-shrink: 0;
        }
        .sidebar-brand {
            padding: 0 20px 20px 20px;
            font-size: 1.1rem;
            font-weight: 700;
            color: var(--bg-accent);
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }
        .sidebar-brand .mark {
            display: inline-block;
            width: 10px;
            height: 10px;
            background-color: var(--bg-accent);
            border-radius: 50%;
            margin-right: 8px;
        }
        .sidebar-user {
            padding: 15px 20px;
            display: flex;
            align-items: center;
            gap: 12px;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }
        .sidebar-user .avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background-color: var(--bg-accent);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
        }
        .sidebar-user .name {
            font-weight: 600;
            font-size: 0.95rem;
            display: block;
        }
        .sidebar-user .role {
            font-size: 0.8rem;
            color: rgba(255,255,255,0.7);
        }
        .sidebar-nav {
            padding: 15px 0;
        }
        .nav-item {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px 20px;
            color: rgba(255,255,255,0.8);
            text-decoration: none;
            transition: all 0.2s;
        }
        .nav-item:hover, .nav-item.active {
            background-color: rgba(255,255,255,0.1);
            color: white;
            border-left: 4px solid var(--bg-accent);
        }
        .nav-divider {
            height: 1px;
            background-color: rgba(255,255,255,0.1);
            margin: 15px 0;
        }
        .main-content {
            flex-grow: 1;
            padding: 25px;
        }
        .top-header {
            background-color: white;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            margin-bottom: 25px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .top-header h2 {
            margin: 0;
            font-size: 1.4rem;
            color: var(--bg-primary);
            font-weight: 700;
        }
        .top-header .sub {
            font-size: 0.85rem;
            color: #6c757d;
        }
        .card-custom {
            background-color: white;
            border-radius: 12px;
            border: none;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            padding: 20px;
            margin-bottom: 25px;
        }
        .btn-accent {
            background-color: var(--bg-accent);
            color: white;
            font-weight: 600;
            border: none;
        }
        .btn-accent:hover {
            background-color: #A07436;
            color: white;
        }
        .row-khop { background-color: #E6F4EF !important; }
        .row-lech { background-color: #FFF9E6 !important; }
        .row-daxuly { background-color: #F0F0F0 !important; color: #6C757D; }
        .row-loi { background-color: #FDF2F2 !important; }
    </style>
</head>
<body>

<div class="layout-wrapper">
    <jsp:include page="/WEB-INF/views/ketoan/common/sidebar.jsp" />

    <div class="main-content">
        <jsp:include page="/WEB-INF/views/ketoan/common/header.jsp" />

        <!-- THÔNG BÁO ALERT -->
        <c:if test="${not empty sessionScope.msgSuccess}">
            <div class="alert alert-success alert-dismissible fade show fw-semibold" role="alert">
                ✅ <c:out value="${sessionScope.msgSuccess}" />
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <% session.removeAttribute("msgSuccess"); %>
        </c:if>

        <c:if test="${not empty sessionScope.msgError}">
            <div class="alert alert-danger alert-dismissible fade show fw-semibold" role="alert">
                ⚠️ <c:out value="${sessionScope.msgError}" />
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <% session.removeAttribute("msgError"); %>
        </c:if>

        <c:if test="${not empty msgError}">
            <div class="alert alert-danger alert-dismissible fade show fw-semibold" role="alert">
                ⚠️ <c:out value="${msgError}" />
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- TOP HEADER KHUNG TIÊU ĐỀ -->
        <div class="top-header">
            <div>
                <h2>📊 Đối Soát Sao Kê Ngân Hàng Hàng Loạt</h2>
                <div class="sub">Tải file sao kê CSV từ ngân hàng để đối chiếu tự động với 200 căn hộ tòa nhà.</div>
            </div>
            <div>
                <a href="${pageContext.request.contextPath}/assets/mau-sao-ke.csv" class="btn btn-outline-secondary btn-sm" download>
                    📥 Tải File CSV Mẫu
                </a>
            </div>
        </div>

        <!-- UPLOAD FORM -->
        <div class="card-custom">
            <h5 class="fw-bold mb-3" style="color: var(--bg-primary);">📁 Tải Lên File Sao Kê Ngân Hàng (.csv)</h5>
            <form action="${pageContext.request.contextPath}/ketoan/doi-soat/tai-len" method="post" enctype="multipart/form-data" class="row g-3 align-items-center">
                <div class="col-md-7">
                    <input type="file" name="file" accept=".csv" class="form-control form-control-lg" required>
                    <div class="form-text small">Hệ thống hỗ trợ file CSV từ các ngân hàng (Vietcombank, MB, Techcombank...). Tự nhận biết mã GD `PB...T...`.</div>
                </div>
                <div class="col-md-5 d-flex gap-2">
                    <button type="submit" class="btn btn-accent btn-lg px-4 flex-grow-1">
                        🔍 Tải Lên & Đối Chiếu Tự Động
                    </button>
                </div>
            </form>
        </div>

        <!-- PREVIEW TABLE -->
        <%-- Comment NGOÀI c:choose --%>
        <c:choose>
            <c:when test="${parsedData == true}">
                <div class="card-custom border-primary">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <div>
                            <h5 class="fw-bold text-primary mb-1">
                                📋 Kết Quả Đối Chiếu File: <c:out value="${fileName}" default="sao-ke.csv" />
                            </h5>
                            <div class="small fw-semibold text-dark">
                                Đọc được <strong>${summaryInfo.tongDong}</strong> dòng — 
                                <span class="text-success">Khớp: ${summaryInfo.soKhop}</span> | 
                                <span class="text-warning">Lệch tiền: ${summaryInfo.soLechTien}</span> | 
                                <span class="text-secondary">Đã xử lý trước: ${summaryInfo.soDaXuLy}</span> | 
                                <span class="text-danger">Không khớp mã: ${summaryInfo.soKhongMa}</span>
                            </div>
                        </div>
                    </div>

                    <form id="formConfirmBatch" action="${pageContext.request.contextPath}/ketoan/doi-soat/xac-nhan" method="post">
                        <div class="table-responsive">
                            <table class="table table-hover table-bordered align-middle">
                                <thead class="table-dark">
                                <tr>
                                    <th class="text-center" style="width: 40px;">
                                        <input type="checkbox" id="checkAll" class="form-check-input" checked>
                                    </th>
                                    <th>Căn Hộ</th>
                                    <th>Kỳ HĐ</th>
                                    <th>Mã GD Hệ Thống</th>
                                    <th class="text-end">Số Tiền (DB)</th>
                                    <th class="text-end">Số Tiền (Sao Kê)</th>
                                    <th>Mã Ref Ngân Hàng</th>
                                    <th class="text-center">Kết Quả</th>
                                    <th>Ghi Chú Chi Tiết</th>
                                </tr>
                                </thead>
                                <tbody>
                                <%-- Comment NGOÀI c:choose --%>
                                <c:choose>
                                    <c:when test="${not empty ketQuaDoiChieu}">
                                        <c:forEach var="r" items="${ketQuaDoiChieu}">
                                            <tr class="${r.ketQua == 'Khop' ? 'row-khop' : (r.ketQua == 'LechTien' ? 'row-lech' : (r.ketQua == 'DaXuLy' || r.ketQua == 'DaDoiSoatTruocDo' ? 'row-daxuly' : 'row-loi'))}">
                                                <td class="text-center">
                                                    <c:choose>
                                                        <c:when test="${r.ketQua == 'Khop'}">
                                                            <input type="checkbox" name="selectedGdId" value="${r.idGiaoDich}" class="form-check-input item-check" checked>
                                                            <input type="hidden" name="ref_${r.idGiaoDich}" value="${r.soThamChieuSaoKe}">
                                                        </c:when>
                                                        <c:when test="${r.ketQua == 'LechTien'}">
                                                            <input type="checkbox" name="selectedGdId" value="${r.idGiaoDich}" class="form-check-input item-check">
                                                            <input type="hidden" name="ref_${r.idGiaoDich}" value="${r.soThamChieuSaoKe}">
                                                        </c:when>
                                                        <c:otherwise>
                                                            <input type="checkbox" disabled class="form-check-input">
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="fw-bold"><c:out value="${r.soPhong}" default="—" /></td>
                                                <td><c:out value="${r.kyHoaDon}" default="—" /></td>
                                                <td class="font-monospace fw-semibold"><c:out value="${r.maThamChieu}" /></td>
                                                <td class="text-end fw-bold text-dark"><c:out value="${r.soTienGiaoDichFmt}" default="—" /></td>
                                                <td class="text-end fw-bold text-success"><c:out value="${r.soTienSaoKeFmt}" default="—" /></td>
                                                <td class="font-monospace small text-primary"><c:out value="${r.soThamChieuSaoKe}" default="—" /></td>
                                                <td class="text-center">
                                                    <c:choose>
                                                        <c:when test="${r.ketQua == 'Khop'}">
                                                            <span class="badge bg-success">Khớp hoàn toàn</span>
                                                        </c:when>
                                                        <c:when test="${r.ketQua == 'LechTien'}">
                                                            <span class="badge bg-warning text-dark">Lệch số tiền</span>
                                                        </c:when>
                                                        <c:when test="${r.ketQua == 'DaXuLy'}">
                                                            <span class="badge bg-secondary">Đã xử lý</span>
                                                        </c:when>
                                                        <c:when test="${r.ketQua == 'DaDoiSoatTruocDo'}">
                                                            <span class="badge bg-secondary">Đã đối soát</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-danger">Lỗi mã / Rỗng</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="small"><c:out value="${r.messageDetail}" /></td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="9" class="text-center text-muted py-3">File sao kê không chứa dòng dữ liệu khả thi nào.</td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                                </tbody>
                            </table>
                        </div>

                        <div class="d-flex justify-content-between align-items-center mt-3 pt-3 border-top">
                            <a href="${pageContext.request.contextPath}/ketoan/doi-soat" class="btn btn-outline-secondary">
                                ↩️ Hủy Xem Trước & Chọn File Khác
                            </a>
                            <button type="submit" id="btnSubmitBatch" class="btn btn-success btn-lg px-4 fw-bold">
                                ✅ Xác Nhận Các Giao Dịch Đã Chọn
                            </button>
                        </div>
                    </form>
                </div>
            </c:when>
            <c:otherwise>
                <!-- PENDING TRANSACTIONS TABLE (Mapped List) -->
                <div class="card-custom">
                    <h5 class="fw-bold mb-3" style="color: var(--bg-primary);">
                        ⏳ Danh Sách Giao Dịch Đang Chờ Xác Nhận (ChoXacNhan)
                    </h5>
                    <div class="table-responsive">
                        <table class="table table-hover table-bordered align-middle">
                            <thead class="table-light">
                            <tr>
                                <th class="text-center" style="width: 50px;">STT</th>
                                <th>Căn Hộ</th>
                                <th>Cư Dân Nộp</th>
                                <th class="text-center">Kỳ Hóa Đơn</th>
                                <th class="text-center">Phương Thức</th>
                                <th>Mã GD Nộp Tiền</th>
                                <th class="text-end">Số Tiền</th>
                                <th class="text-center">Thời Gian Tạo</th>
                                <th class="text-center">Trạng Thái</th>
                            </tr>
                            </thead>
                            <tbody>
                            <%-- Comment NGOÀI c:choose --%>
                            <c:choose>
                                <c:when test="${not empty pendingList}">
                                    <c:forEach var="row" items="${pendingList}" varStatus="loop">
                                        <tr>
                                            <td class="text-center fw-bold">${loop.index + 1}</td>
                                            <td class="fw-bold text-primary"><c:out value="${row.soPhong}" /></td>
                                            <td class="fw-semibold"><c:out value="${row.tenCuDan}" default="—" /></td>
                                            <td class="text-center"><c:out value="${row.kyHoaDon}" /></td>
                                            <td class="text-center">
                                                <span class="badge bg-light text-dark border"><c:out value="${row.phuongThucText}" /></span>
                                            </td>
                                            <td class="font-monospace fw-bold text-dark"><c:out value="${row.maGiaoDichNganHang}" default="—" /></td>
                                            <td class="text-end fw-bold text-success"><c:out value="${row.soTienText}" /></td>
                                            <td class="text-center small"><c:out value="${row.thoiGianTaoText}" default="—" /></td>
                                            <td class="text-center">
                                                <span class="badge bg-warning text-dark">Chờ xác nhận</span>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="9" class="text-center text-muted py-4">Hiện không có giao dịch thanh toán nào đang chờ xác nhận.</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>

    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        const checkAll = document.getElementById('checkAll');
        const itemChecks = document.querySelectorAll('.item-check');
        const formConfirmBatch = document.getElementById('formConfirmBatch');

        if (checkAll && itemChecks.length > 0) {
            checkAll.addEventListener('change', function () {
                itemChecks.forEach(cb => {
                    cb.checked = checkAll.checked;
                });
            });
        }

        if (formConfirmBatch) {
            formConfirmBatch.addEventListener('submit', function (e) {
                const checkedCount = document.querySelectorAll('.item-check:checked').length;
                if (checkedCount === 0) {
                    e.preventDefault();
                    alert('Vui lòng tích chọn ít nhất một giao dịch để xác nhận.');
                    return false;
                }

                if (!confirm('Bạn có chắc chắn muốn xác nhận ' + checkedCount + ' giao dịch đã chọn không?')) {
                    e.preventDefault();
                    return false;
                }
            });
        }
    });
</script>
</body>
</html>
