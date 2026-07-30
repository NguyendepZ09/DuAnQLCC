<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="util.DisplayUtil" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/WEB-INF/views/common/head.jsp" %>
    <title>Tra Cứu Xe & Thẻ Từ — PolyBuilding Bảo Vệ</title>

    <style>
:root {
            --bv-bg: #F4EFE4;
            --bv-primary: #1E3B34;
            --bv-gold: #B98A46;
            --bv-card-bg: #FFFFFF;
            --bv-text: #2D3748;
            --bv-border: #EAE3D2;
        }

        body {
            background-color: var(--bv-bg);
            color: var(--bv-text);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            display: flex;
            min-height: 100vh;
        }

















        .card-custom {
            background: var(--bv-card-bg);
            border-radius: 12px;
            border: 1px solid var(--bv-border);
            box-shadow: 0 2px 8px rgba(0,0,0,0.04);
            margin-bottom: 20px;
        }

        .card-custom .card-header-custom {
            padding: 15px 20px;
            border-bottom: 1px solid var(--bv-border);
            font-weight: 700;
            color: var(--bv-primary);
            background: rgba(30, 59, 52, 0.02);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .vehicle-card {
            background: #FFFFFF;
            border-radius: 12px;
            border: 2px solid var(--bv-border);
            padding: 20px;
            margin-bottom: 15px;
            transition: box-shadow 0.2s;
        }

        .vehicle-card:hover {
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        }

        .vehicle-card.alert-active {
            border-color: #DC3545;
            background: #FFF8F8;
        }
    </style>
</head>
<body>

    <!-- SIDEBAR -->
    <jsp:include page="/WEB-INF/views/baove/common/sidebar.jsp" />

    <!-- MAIN CONTENT -->
    <div class="main-content">
        <jsp:include page="/WEB-INF/views/baove/common/header.jsp" />

        <div class="content-body">
            
            <!-- Ô TÌM KIẾM LỚN -->
            <div class="card-custom">
                <div class="card-header-custom">
                    <span>🔍 TRA CỨU NHANH BÃI XE / CỔNG AN NINH / CĂN HỘ</span>
                </div>
                <div class="card-body p-4">
                    <form action="${pageContext.request.contextPath}/baove/tra-cuu" method="get">
                        <div class="input-group input-group-lg">
                            <span class="input-group-text bg-white border-end-0">🔍</span>
                            <input type="text" name="tuKhoa" class="form-control border-start-0 ps-0" placeholder="Nhập biển số xe (VD: 30A-123.45), số thẻ (VD: THE-0101-01) hoặc số phòng..." value="${tuKhoa}" autofocus required>
                            <button type="submit" class="btn btn-success px-4 fw-bold">Tra Cứu Thông Tin</button>
                        </div>
                        <div class="form-text mt-2 text-muted">
                            💡 <i>Gợi ý: Tìm theo biển số xe, số thẻ từ hoặc số phòng (VD: 30A-123.45, THE-0101-01, hoặc 101).</i>
                        </div>
                    </form>
                </div>
            </div>

            <!-- KẾT QUẢ TRA CỨU -->
            <c:if test="${not empty tuKhoa}">
                <div class="mb-3">
                    <h5 class="fw-bold text-primary">
                        📌 Kết quả tra cứu cho từ khóa: "<span class="text-danger"><c:out value="${tuKhoa}"/></span>"
                    </h5>
                </div>

                <!-- 1. CARD THÔNG TIN CĂN HỘ (NẾU TÌM THEO SỐ PHÒNG) -->
                <c:if test="${not empty canHoInfo}">
                    <div class="card-custom border-primary mb-4 shadow-sm">
                        <div class="card-header-custom bg-primary text-white d-flex justify-content-between align-items-center" style="background-color: #1E3B34 !important;">
                            <span class="fs-5 fw-bold text-white">🏢 THÔNG TIN CĂN HỘ P.<c:out value="${canHoInfo.soPhong}"/></span>
                            <span class="badge bg-warning text-dark fs-6">Tầng <c:out value="${canHoInfo.tang}"/></span>
                        </div>
                        <div class="card-body p-4">
                            <div class="row g-3 mb-3">
                                <div class="col-md-3"><strong>Mã số phòng:</strong> <span class="fw-bold text-primary fs-5">P.<c:out value="${canHoInfo.soPhong}"/></span></div>
                                <div class="col-md-3"><strong>Vị trí tầng:</strong> Tầng <c:out value="${canHoInfo.tang}"/></div>
                                <div class="col-md-3"><strong>Diện tích:</strong> <c:out value="${canHoInfo.dienTich}"/> m²</div>
                                <div class="col-md-3"><strong>Trạng thái căn:</strong> <span class="badge bg-info text-dark">${DisplayUtil.getTrangThaiCanHoText(canHoInfo.trangThai)}</span></div>
                            </div>

                            <div class="row g-3 mb-3">
                                <div class="col-md-6">
                                    <div class="p-3 bg-light rounded border">
                                        <span class="fw-bold text-dark d-block mb-1">🚗 Số xe đăng ký:</span>
                                        <span class="fs-5 fw-bold text-success"><c:out value="${canHoInfo.soXeDangKy}"/> xe</span>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="p-3 bg-light rounded border">
                                        <span class="fw-bold text-dark d-block mb-1">🪪 Thẻ từ đang hoạt động:</span>
                                        <span class="fs-5 fw-bold text-primary"><c:out value="${canHoInfo.soTheDangHoatDong}"/> thẻ</span>
                                    </div>
                                </div>
                            </div>

                            <!-- PRIVACY COMPLIANT RESIDENT LIST (NO CCCD, NO PHONE NUMBERS) -->
                            <div class="p-3 bg-light rounded border">
                                <h6 class="fw-bold text-dark mb-2">👥 Danh Sách Cư Dân Đang Ở (Kiểm Soát Ra Vào Cổng)</h6>
                                <c:choose>
                                    <c:when test="${not empty canHoInfo.dsCuDan}">
                                        <div class="table-responsive">
                                            <table class="table table-sm table-bordered align-middle m-0 bg-white">
                                                <thead class="table-secondary">
                                                    <tr>
                                                        <th>Họ & Tên Cư Dân</th>
                                                        <th>Tư Cách / Loại Cư Dân</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach var="cd" items="${canHoInfo.dsCuDan}">
                                                        <tr>
                                                            <td class="fw-bold text-dark">👤 <c:out value="${cd[0]}"/></td>
                                                            <td>
                                                                <span class="badge ${DisplayUtil.getLoaiCuDanBadgeClass(cd[1])}">
                                                                    ${DisplayUtil.getLoaiCuDanText(cd[1])}
                                                                </span>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </tbody>
                                            </table>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted italic">Căn hộ hiện chưa có cư dân đăng ký ở.</span>
                                    </c:otherwise>
                                </c:choose>
                                <small class="text-muted d-block mt-2">🔒 <i>Bảo vệ chỉ được phép tra cứu tên và tư cách ở (Chủ hộ/Khách thuê) để phục vụ kiểm soát ra vào. CCCD & SĐT đã được ẩn theo chính sách bảo mật thông tin cư dân.</i></small>
                            </div>
                        </div>
                    </div>
                </c:if>

                <!-- 2. KẾT QUẢ XE VÀ THẺ TỪ -->
                <c:choose>
                    <c:when test="${not empty ketQuaList}">
                        <div class="row">
                            <c:forEach var="v" items="${ketQuaList}">
                                <div class="col-md-6">
                                    <c:choose>
                                        <c:when test="${v[7] == 'ChuaGanThe'}">
                                            <!-- TRẠNG THÁI 1: CHƯA GẮN THẺ TỪ (maThe IS NULL) -->
                                            <div class="vehicle-card border-warning bg-warning bg-opacity-10">
                                                <div class="d-flex justify-content-between align-items-start mb-3">
                                                    <div>
                                                        <h3 class="fw-bold mb-1 text-dark">
                                                            ${DisplayUtil.getLoaiXeIcon(v[2])} <c:out value="${v[1]}"/>
                                                        </h3>
                                                        <span class="badge bg-secondary me-1">Căn <c:out value="${v[3]}"/></span>
                                                        <span class="badge bg-light text-dark border">${DisplayUtil.getLoaiXeText(v[2])}</span>
                                                    </div>
                                                    <div>
                                                        <span class="badge bg-warning text-dark fs-6">🟡 Chưa gắn thẻ từ</span>
                                                    </div>
                                                </div>

                                                <div class="row g-2 text-muted small">
                                                    <div class="col-6">
                                                        👤 <b>Chủ hộ:</b> <c:out value="${v[4]}" default="—"/>
                                                    </div>
                                                    <div class="col-6">
                                                        🪪 <b>Mã thẻ gắn:</b> <span class="text-muted">— (Chưa đăng ký thẻ)</span>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:when>

                                        <c:when test="${v[7] == 'TheKhongHieuLuc'}">
                                            <!-- TRẠNG THÁI 2: THẺ KHÔNG CÒN HIỆU LỰC (tạm khóa, thu hồi hoặc hết hạn) -->
                                            <div class="vehicle-card alert-active">
                                                <div class="d-flex justify-content-between align-items-start mb-3">
                                                    <div>
                                                        <h3 class="fw-bold mb-1 text-dark">
                                                            ${DisplayUtil.getLoaiXeIcon(v[2])} <c:out value="${v[1]}"/>
                                                        </h3>
                                                        <span class="badge bg-secondary me-1">Căn <c:out value="${v[3]}"/></span>
                                                        <span class="badge bg-light text-dark border">${DisplayUtil.getLoaiXeText(v[2])}</span>
                                                    </div>
                                                    <div>
                                                        <span class="badge bg-danger fs-6">🔴 Thẻ không hiệu lực</span>
                                                    </div>
                                                </div>

                                                <div class="row g-2 mb-3 text-muted small">
                                                    <div class="col-6">
                                                        👤 <b>Chủ hộ:</b> <c:out value="${v[4]}" default="—"/>
                                                    </div>
                                                    <div class="col-6">
                                                        🪪 <b>Mã thẻ gắn:</b> <span class="fw-bold text-dark"><c:out value="${v[5]}"/></span>
                                                    </div>
                                                    <div class="col-6">
                                                        📅 <b>Hạn thẻ:</b> <c:out value="${v[8]}"/>
                                                    </div>
                                                    <div class="col-6">
                                                        ⌛ <b>Tình trạng:</b> <span class="text-danger fw-bold"><c:out value="${v[9]}"/></span>
                                                    </div>
                                                </div>

                                                <div class="alert alert-danger mb-0 py-2 fw-bold text-center border-2" role="alert">
                                                    🚨 CẢNH BÁO: THẺ KHÔNG CÒN HIỆU LỰC — LIÊN HỆ LỄ TÂN!
                                                    <div class="small fw-normal mt-1">(Lý do: <c:out value="${v[9]}"/>)</div>
                                                </div>
                                            </div>
                                        </c:when>

                                        <c:otherwise>
                                            <!-- TRẠNG THÁI 3: THẺ HỢP LỆ (ĐangSuDung, ngayHetHan >= hôm nay hoặc NULL) -->
                                            <div class="vehicle-card border-success">
                                                <div class="d-flex justify-content-between align-items-start mb-3">
                                                    <div>
                                                        <h3 class="fw-bold mb-1 text-dark">
                                                            ${DisplayUtil.getLoaiXeIcon(v[2])} <c:out value="${v[1]}"/>
                                                        </h3>
                                                        <span class="badge bg-secondary me-1">Căn <c:out value="${v[3]}"/></span>
                                                        <span class="badge bg-light text-dark border">${DisplayUtil.getLoaiXeText(v[2])}</span>
                                                    </div>
                                                    <div>
                                                        <span class="badge bg-success fs-6">🟢 Thẻ hợp lệ</span>
                                                    </div>
                                                </div>

                                                <div class="row g-2 text-muted small">
                                                    <div class="col-6">
                                                        👤 <b>Chủ hộ:</b> <c:out value="${v[4]}" default="—"/>
                                                    </div>
                                                    <div class="col-6">
                                                        🪪 <b>Mã thẻ gắn:</b> <span class="fw-bold text-primary"><c:out value="${v[5]}"/></span>
                                                    </div>
                                                    <div class="col-6">
                                                        📅 <b>Hạn thẻ:</b> <c:out value="${v[8]}"/>
                                                    </div>
                                                    <div class="col-6">
                                                        ⌛ <b>Tình trạng hạn:</b> <span class="text-success fw-bold">🟢 Còn hạn</span>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:if test="${empty canHoInfo}">
                            <div class="alert alert-warning py-4 text-center fs-5" role="alert">
                                ⚠️ Không tìm thấy phương tiện, thẻ hoặc số phòng nào khớp với từ khóa "<c:out value="${tuKhoa}"/>".
                            </div>
                        </c:if>
                    </c:otherwise>
                </c:choose>
            </c:if>

        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            // Read-only screen for Security Guard
        });
    </script>
</body>
</html>
