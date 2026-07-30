<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/WEB-INF/views/common/head.jsp" %>
    <title>Thông Báo & Bình Chọn — Cư Dân Polybuilding</title>

    <style>
.notice-unread { border-left: 4px solid #B98A46; background-color: #F4EFE4; }
        .notice-khancap { border-left: 5px solid #DC2626 !important; background-color: #FEF2F2 !important; }
    </style>
</head>
<body>

<div class="app-layout">
    <%@ include file="/WEB-INF/views/cudan/common/sidebar.jsp" %>

    <div class="main-wrapper">
        <%@ include file="/WEB-INF/views/cudan/common/header.jsp" %>

        <div class="content-body">
            <h4 class="text-dark fw-bold mb-4">📢 Thông Báo & 🗳️ Khảo Sát Ý Kiến Cư Dân</h4>

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

            <!-- Navigation Tabs -->
            <ul class="nav nav-pills mb-4" id="mainTab" role="tablist">
                <li class="nav-item" role="presentation">
                    <button class="nav-link active fw-bold px-4 me-2" id="thongbao-tab" data-bs-toggle="pill" data-bs-target="#thongbao-pane" type="button" role="tab">
                        📢 Thông Báo Tòa Nhà 
                        <c:if test="${unreadCount > 0}">
                            <span class="badge bg-danger ms-1">${unreadCount}</span>
                        </c:if>
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link fw-bold px-4" id="binhchon-tab" data-bs-toggle="pill" data-bs-target="#binhchon-pane" type="button" role="tab">
                        🗳️ Bình Chọn & Khảo Sát
                    </button>
                </li>
            </ul>

            <div class="tab-content" id="mainTabContent">
                
                <!-- TAB 1: THÔNG BÁO -->
                <div class="tab-pane fade show active" id="thongbao-pane" role="tabpanel">
                    <c:choose>
                        <c:when test="${not empty danhSachThongBao}">
                            <c:forEach var="tb" items="${danhSachThongBao}">
                                <c:set var="isRead" value="${readNoticeIds.contains(tb.id)}" />
                                <c:set var="isKhanCap" value="${tb.loaiThongBao == 'KhanCap'}" />
                                <c:set var="isNhacPhi" value="${tb.loaiThongBao == 'NhacPhi'}" />

                                <div class="card-custom ${!isRead ? 'notice-unread' : ''} ${isKhanCap ? 'notice-khancap' : ''} ${isNhacPhi ? 'border-danger border-start border-4' : ''}">
                                    <div class="d-flex justify-content-between align-items-start mb-2">
                                        <h5 class="fw-bold m-0 ${isKhanCap || isNhacPhi ? 'text-danger' : 'text-dark'}">
                                            <c:if test="${isKhanCap}">🚨 [KHẨN CẤP] </c:if>
                                            <c:if test="${isNhacPhi}"><span class="badge bg-danger me-1">📩 THÔNG BÁO NHẮC PHÍ</span> </c:if>
                                            <c:if test="${tb.loaiThongBao == 'BaoTri'}">🔧 [BẢO TRÌ] </c:if>
                                            ${tb.tieuDe}
                                        </h5>
                                        <div>
                                            <c:choose>
                                                <c:when test="${isRead}">
                                                    <span class="badge bg-secondary">Đã đọc</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-primary">Mới</span>
                                                    <button class="btn btn-sm btn-outline-primary ms-2 py-0" onclick="markRead(${tb.id}, this)">Đánh dấu đã đọc</button>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                    <p class="text-secondary mb-3">${tb.noiDung}</p>
                                    <div class="text-muted small d-flex gap-3">
                                        <span>📅 Ngày đăng: ${tb.ngayTaoFormatted}</span>
                                        <span>👥 Gửi tới: ${tb.doiTuong == 'CuDan' ? 'Cư dân' : 'Toàn bộ cư dân & nhân viên'}</span>
                                    </div>
                                </div>
                            </c:forEach>

                            <!-- Pagination -->
                            <c:if test="${totalPages > 1}">
                                <nav>
                                    <ul class="pagination justify-content-center">
                                        <c:forEach var="p" begin="1" end="${totalPages}">
                                            <li class="page-item ${p == currentPage ? 'active' : ''}">
                                                <a class="page-link" href="${pageContext.request.contextPath}/cudan/thong-bao?page=${p}">${p}</a>
                                            </li>
                                        </c:forEach>
                                    </ul>
                                </nav>
                            </c:if>
                        </c:when>
                        <c:otherwise>
                            <div class="card-custom text-center py-5">
                                <h5 class="text-muted m-0">📭 Chưa có thông báo nào dành cho bạn.</h5>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- TAB 2: BÌNH CHỌN & KHẢO SÁT -->
                <div class="tab-pane fade" id="binhchon-pane" role="tabpanel">
                    <c:choose>
                        <c:when test="${not empty pollViews}">
                            <c:forEach var="item" items="${pollViews}">
                                <c:set var="bc" value="${item.binhChon}" />
                                <c:set var="phuongAnList" value="${item.phuongAnList}" />
                                <c:set var="votedDetail" value="${item.votedDetail}" />
                                <c:set var="isClosed" value="${bc.trangThai == 'DaDong' || bc.trangThai == 'KhongDuTucSo'}" />

                                <div class="card-custom">
                                    <div class="d-flex justify-content-between align-items-center mb-3">
                                        <h5 class="fw-bold text-dark m-0">🗳️ ${bc.cauHoi}</h5>
                                        <span class="badge ${bc.trangThai == 'DangMo' ? 'bg-success' : (bc.trangThai == 'DaDong' ? 'bg-secondary' : 'bg-warning text-dark')}">
                                            <c:choose>
                                                <c:when test="${bc.trangThai == 'DangMo'}">🟢 Đang Mở</c:when>
                                                <c:when test="${bc.trangThai == 'DaDong'}">🔴 Đã Đóng</c:when>
                                                <c:when test="${bc.trangThai == 'KhongDuTucSo'}">⚠️ Không Đủ Túc Số</c:when>
                                                <c:otherwise>${bc.trangThai}</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>

                                    <%-- CASE 1: BÌNH CHỌN ĐANG MỞ --%>
                                    <c:if test="${!isClosed}">
                                        <c:choose>
                                            <c:when test="${not empty votedDetail}">
                                                <%-- Sub-case 1.1: Căn hộ ĐÃ BỎ PHIẾU -> Khóa form --%>
                                                <div class="alert alert-info border-info mb-3">
                                                    <strong>🔒 Căn hộ của bạn đã bỏ phiếu</strong> 
                                                    (do <strong>${votedDetail.nguoiBauHoTen}</strong> thực hiện lúc <em>${votedDetail.thoiGianBau}</em>).
                                                </div>
                                                <div class="list-group mb-3">
                                                    <c:forEach var="pa" items="${phuongAnList}">
                                                        <div class="list-group-item d-flex justify-content-between align-items-center ${pa.id == votedDetail.maPhuongAn ? 'list-group-item-success fw-bold' : ''}">
                                                            <span>${pa.noiDung}</span>
                                                            <c:if test="${pa.id == votedDetail.maPhuongAn}">
                                                                <span class="badge bg-success">Lựa chọn của căn hộ</span>
                                                            </c:if>
                                                        </div>
                                                    </c:forEach>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <%-- Sub-case 1.2: Căn hộ CHƯA BỎ PHIẾU -> Form bỏ phiếu --%>
                                                <form action="${pageContext.request.contextPath}/cudan/bo-phieu" method="post">
                                                    <input type="hidden" name="maBinhChon" value="${bc.id}">
                                                    
                                                    <div class="mb-3">
                                                        <label class="form-label font-semibold text-secondary mb-2">Vui lòng chọn 1 phương án:</label>
                                                        <c:forEach var="pa" items="${phuongAnList}">
                                                            <div class="form-check mb-2">
                                                                <input class="form-check-input" type="radio" name="maPhuongAn" id="pa_${pa.id}" value="${pa.id}" required>
                                                                <label class="form-check-label text-dark" for="pa_${pa.id}">
                                                                    ${pa.noiDung}
                                                                </label>
                                                            </div>
                                                        </c:forEach>
                                                    </div>
                                                    
                                                    <div class="d-flex justify-content-between align-items-center mt-4">
                                                        <span class="text-muted small">⏳ Hạn chót: <strong>${item.hanChotFormatted}</strong></span>
                                                        <button type="submit" class="btn btn-primary fw-bold px-4">📩 Gửi Phiếu Bầu</button>
                                                    </div>
                                                </form>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:if>

                                    <%-- CASE 2: BÌNH CHỌN ĐÃ ĐÓNG -> Xem kết quả từ View v_KetQuaBinhChon --%>
                                    <c:if test="${isClosed}">
                                        <div class="p-3 bg-light rounded border mb-3">
                                            <h6 class="fw-bold text-primary mb-2">📊 Kết Quả Chung Cuộc</h6>
                                            <p class="mb-2"><strong>Kết luận:</strong> ${bc.ketQua}</p>
                                            <p class="text-muted small mb-0">Yêu cầu túc số: <strong>${bc.tyLeTucSo}%</strong> cư dân tham gia.</p>
                                        </div>

                                        <div class="table-responsive">
                                            <table class="table table-bordered align-middle">
                                                <thead class="table-light">
                                                    <tr>
                                                        <th>Phương Án Bình Chọn</th>
                                                        <th class="text-center" style="width: 150px;">Số Phiếu Bầu</th>
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
                                    </c:if>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="card-custom text-center py-5">
                                <h5 class="text-muted m-0">📊 Hiện chưa có cuộc bình chọn nào trong hệ thống.</h5>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

            </div>
        </div>
    </div>
</div>

<script>
    function markRead(maThongBao, btnElem) {
        fetch('${pageContext.request.contextPath}/cudan/mark-read', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8' },
            body: 'maThongBao=' + maThongBao
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                location.reload();
            }
        })
        .catch(err => console.error(err));
    }
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
