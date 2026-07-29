<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="util.DisplayUtil" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Giám Sát Nhân Sự & Lịch Trực — Ban Quản Lý</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        body { background-color: #F4EFE4; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        .app-layout { display: flex; min-height: 100vh; }
        .sidebar { width: 260px; background: #1E3B34; color: #FFF; padding: 24px; flex-shrink: 0; }
        .sidebar-brand { font-size: 1.15rem; font-weight: 700; color: #B98A46; margin-bottom: 30px; display: flex; align-items: center; gap: 8px; }
        .sidebar-brand .mark { width: 10px; height: 10px; background: #B98A46; transform: rotate(45deg); display: inline-block; }
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
        .top-header h2 { font-size: 1.4rem; color: #1E3B34; margin: 0; font-weight: 700; }
        .top-header .sub { font-size: 0.82rem; color: #6C757D; }
        .content-body { padding: 32px; }
        .stat-card { background: #FFF; border-radius: 12px; padding: 20px; border: 1px solid #DCE6E0; box-shadow: 0 4px 12px rgba(0,0,0,0.03); height: 100%; }
        .stat-card .title { font-size: 0.8rem; font-weight: 700; text-transform: uppercase; color: #6C757D; margin-bottom: 8px; }
        .stat-card .value { font-size: 1.6rem; color: #1E3B34; font-weight: 700; }
        .card-custom { background: #FFF; border-radius: 12px; border: 1px solid #DCE6E0; padding: 24px; box-shadow: 0 4px 12px rgba(0,0,0,0.03); margin-bottom: 24px; }
    </style>
</head>
<body>

<div class="app-layout">
    <jsp:include page="/WEB-INF/views/banquanly/common/sidebar.jsp" />

    <div class="main-wrapper">
        <jsp:include page="/WEB-INF/views/banquanly/common/header.jsp" />

        <div class="content-body">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h4 class="text-dark fw-bold m-0">👮 Giám Sát Chấm Công & Nhật Ký Ca Trực Nhân Sự</h4>
                    <small class="text-muted">Theo dõi giờ vào/ra, số giờ công và tình trạng bàn giao ca trực các bộ phận</small>
                </div>
            </div>

            <!-- Filter Form -->
            <div class="card-custom mb-4">
                <form action="${pageContext.request.contextPath}/banquanly/nhan-su" method="get" class="row g-3 align-items-end">
                    <div class="col-md-3">
                        <label class="form-label fw-semibold">Bộ phận nhân viên:</label>
                        <select name="boPhan" class="form-select">
                            <option value="">-- Tất cả bộ phận --</option>
                            <option value="LeTan" ${boPhanChon == 'LeTan' ? 'selected' : ''}>Lễ tân</option>
                            <option value="KeToan" ${boPhanChon == 'KeToan' ? 'selected' : ''}>Kế toán</option>
                            <option value="KyThuat" ${boPhanChon == 'KyThuat' ? 'selected' : ''}>Kỹ thuật</option>
                            <option value="BaoVe" ${boPhanChon == 'BaoVe' ? 'selected' : ''}>Bảo vệ</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label fw-semibold">Từ ngày:</label>
                        <input type="date" name="tuNgay" value="${tuNgayChon}" class="form-control">
                    </div>
                    <div class="col-md-3">
                        <label class="form-label fw-semibold">Đến ngày:</label>
                        <input type="date" name="denNgay" value="${denNgayChon}" class="form-control">
                    </div>
                    <div class="col-md-3">
                        <button type="submit" class="btn btn-primary w-100 fw-semibold">🔍 Lọc Dữ Liệu</button>
                    </div>
                </form>
            </div>

            <!-- Stat Cards Row -->
            <div class="row g-4 mb-4">
                <div class="col-md-3">
                    <div class="stat-card">
                        <div class="title">Tổng Số Ca Làm / Trực</div>
                        <div class="value text-primary">${thongKe.tongSoCa} ca</div>
                        <span class="badge bg-primary">Trong khoảng thời gian</span>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card">
                        <div class="title">Đang Trực Ca Hiện Tại</div>
                        <div class="value text-success">${thongKe.soCaDangTruc} nhân viên</div>
                        <span class="badge bg-success">Chưa quét giờ ra</span>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card">
                        <div class="title">Giờ Công Kỹ Thuật & Bảo Vệ</div>
                        <div class="value text-dark">
                            <c:set var="hKT" value="${thongKe.tongGioBoPhan['KyThuat'] != null ? thongKe.tongGioBoPhan['KyThuat'] : 0.0}" />
                            <c:set var="hBV" value="${thongKe.tongGioBoPhan['BaoVe'] != null ? thongKe.tongGioBoPhan['BaoVe'] : 0.0}" />
                            ${hKT + hBV} giờ
                        </div>
                        <span class="badge bg-secondary">Kỹ thuật & Bảo vệ</span>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card">
                        <div class="title">Giờ Công Lễ Tân & Kế Toán</div>
                        <div class="value text-dark">
                            <c:set var="hLT" value="${thongKe.tongGioBoPhan['LeTan'] != null ? thongKe.tongGioBoPhan['LeTan'] : 0.0}" />
                            <c:set var="hKT2" value="${thongKe.tongGioBoPhan['KeToan'] != null ? thongKe.tongGioBoPhan['KeToan'] : 0.0}" />
                            ${hLT + hKT2} giờ
                        </div>
                        <span class="badge bg-secondary">Văn phòng & Lễ tân</span>
                    </div>
                </div>
            </div>

            <!-- KHỐI A: BẢNG CHẤM CÔNG NHÂN SỰ -->
            <div class="card-custom">
                <h5 class="fw-bold text-dark mb-3">📅 Khối A: Bảng Chấm Công Giờ Vào / Giờ Ra Nhân Sự</h5>
                
                <%-- Bọc an toàn Khối A trong c:catch --%>
                <c:catch var="loiKhoiA">
                    <div class="table-responsive">
                        <table class="table table-hover table-bordered align-middle m-0">
                            <thead class="table-dark" style="background-color: #1E3B34;">
                                <tr>
                                    <th>#Mã NV</th>
                                    <th>Họ & Tên</th>
                                    <th>Bộ Phận</th>
                                    <th class="text-center">Ngày Làm</th>
                                    <th class="text-center">Ca Làm</th>
                                    <th class="text-center">Giờ Vào</th>
                                    <th class="text-center">Giờ Ra</th>
                                    <th class="text-center">Số Giờ Làm</th>
                                    <th class="text-center">Trạng Thái</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty dsChamCong}">
                                        <c:forEach var="row" items="${dsChamCong}">
                                            <tr>
                                                <td class="fw-bold text-muted">#NV${row[0]}</td>
                                                <td class="fw-bold text-dark">${row[1]}</td>
                                                <td>
                                                    <span class="badge bg-secondary">${DisplayUtil.getBoPhanText(row[2])}</span>
                                                </td>
                                                <td class="text-center font-monospace">${row[3]}</td>
                                                <td class="text-center font-monospace fw-semibold">${DisplayUtil.getCaTrucText(row[4])}</td>
                                                <td class="text-center text-primary font-monospace">${row[5]}</td>
                                                <td class="text-center font-monospace">
                                                    <%-- In gioRaText đã định dạng ở Java --%>
                                                    <c:choose>
                                                        <c:when test="${not empty row[6]}">${row[6]}</c:when>
                                                        <c:otherwise><span class="badge bg-success">Đang trực</span></c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="text-center fw-bold text-dark">
                                                    <%-- In soGioLamText đã tính sẵn ở Java --%>
                                                    <c:choose>
                                                        <c:when test="${row[8] == 'DangTruc'}">
                                                            <span class="text-muted">—</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            ${row[7]} giờ
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="text-center">
                                                    <%-- Kiểm tra trangThaiCa đã tính ở Java --%>
                                                    <c:choose>
                                                        <c:when test="${row[8] == 'DangTruc'}">
                                                            <span class="badge bg-success">🟢 Đang trực</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-secondary">⚪ Hoàn thành</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="9" class="text-center text-muted py-4">Không tìm thấy dữ liệu chấm công phù hợp.</td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </c:catch>

                <c:if test="${not empty loiKhoiA}">
                    <div class="alert alert-danger mt-3 mb-0" role="alert">
                        ⚠️ Không tải được dữ liệu khối A: <c:out value="${loiKhoiA}" />
                    </div>
                </c:if>
            </div>

            <!-- KHỐI B: NHẬT KÝ CA TRỰC & BÀN GIAO BẢO VỆ -->
            <c:choose>
                <c:when test="${boPhanChon == null or boPhanChon == '' or boPhanChon == 'BaoVe'}">
                    <div class="card-custom">
                        <h5 class="fw-bold text-dark mb-3">📝 Khối B: Nhật Ký Ca Trực & Bàn Giao (Bộ Phận Bảo Vệ)</h5>
                        
                        <%-- Bọc an toàn Khối B trong c:catch --%>
                        <c:catch var="loiKhoiB">
                            <div class="table-responsive">
                                <table class="table table-hover table-bordered align-middle m-0">
                                    <thead class="table-light">
                                        <tr>
                                            <th>#ID</th>
                                            <th class="text-center">Ngày Trực</th>
                                            <th class="text-center">Ca Trực</th>
                                            <th>Người Trực</th>
                                            <th>Nội Dung Ca Trực</th>
                                            <th>Lưu Ý Bàn Giao</th>
                                            <th>Người Nhận Ca</th>
                                            <th class="text-center">Thời Gian Bàn Giao</th>
                                            <th class="text-center">Trạng Thái</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:choose>
                                            <c:when test="${not empty dsCaTruc}">
                                                <c:forEach var="row" items="${dsCaTruc}">
                                                    <tr>
                                                        <td class="fw-bold text-muted">#${row[0]}</td>
                                                        <td class="text-center font-monospace">${row[1]}</td>
                                                        <td class="text-center font-monospace fw-semibold">${DisplayUtil.getCaTrucText(row[2])}</td>
                                                        <td class="fw-bold text-dark">👮 ${row[3]}</td>
                                                        <td><small class="text-dark"><c:out value="${row[4]}" default="—" /></small></td>
                                                        <td><small class="text-danger fw-semibold"><c:out value="${row[5]}" default="—" /></small></td>
                                                        <td class="fw-semibold text-primary">${row[6]}</td>
                                                        <td class="text-center font-monospace small">${row[7]}</td>
                                                        <td class="text-center">
                                                            <c:choose>
                                                                <c:when test="${row[8] == true}">
                                                                    <span class="badge bg-success">✅ Đã bàn giao</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge bg-danger">⏳ Chưa bàn giao</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <tr>
                                                    <td colspan="9" class="text-center text-muted py-4">Chưa có nhật ký ca trực bảo vệ.</td>
                                                </tr>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                </table>
                            </div>
                        </c:catch>

                        <c:if test="${not empty loiKhoiB}">
                            <div class="alert alert-danger mt-3 mb-0" role="alert">
                                ⚠️ Không tải được dữ liệu khối B: <c:out value="${loiKhoiB}" />
                            </div>
                        </c:if>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="card-custom text-center py-4">
                        <span class="text-muted">Nhật ký ca trực chỉ áp dụng cho bộ phận Bảo vệ.</span>
                    </div>
                </c:otherwise>
            </c:choose>

        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
