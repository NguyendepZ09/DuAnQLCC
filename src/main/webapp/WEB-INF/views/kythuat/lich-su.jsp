<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="util.DisplayUtil" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/WEB-INF/views/common/head.jsp" %>
    <title>Lịch Sử Xử Lý Của Tôi — Kỹ Thuật Polybuilding</title>

    <style>
body { background-color: #F4EFE4; font-family: 'Be Vietnam Pro', sans-serif; }
        .card-custom { background: #FFF; border-radius: 12px; padding: 24px; border: 1px solid #EAE3D2; box-shadow: 0 4px 12px rgba(0,0,0,0.03); }
        .stat-card { background: #FFF; border-radius: 12px; padding: 20px; border: 1px solid #EAE3D2; }
    </style>
</head>
<body>

<div class="app-layout">
    <%@ include file="/WEB-INF/views/kythuat/common/sidebar.jsp" %>

    <div class="main-wrapper">
        <%@ include file="/WEB-INF/views/kythuat/common/header.jsp" %>

        <div class="content-body">
            <h4 class="text-dark fw-bold mb-4">📜 Lịch Sử Xử Lý & Nghiệm Thu Của Tôi</h4>

            <!-- THỐNG KÊ TỔNG QUAN -->
            <div class="row g-3 mb-4">
                <div class="col-md-4">
                    <div class="stat-card border-start border-4 border-success">
                        <div class="text-muted small font-semibold">TỔNG VIỆC ĐÃ HOÀN THÀNH</div>
                        <div class="fs-2 fw-bold text-success">${totalItems} <small class="fs-6 text-muted">phiếu</small></div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="stat-card border-start border-4 border-warning">
                        <div class="text-muted small font-semibold">ĐANG XỬ LÝ</div>
                        <div class="fs-2 fw-bold text-warning">${tongDangXuLy} <small class="fs-6 text-muted">phiếu</small></div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="stat-card border-start border-4 border-info">
                        <div class="text-muted small font-semibold">THỜI GIAN XỬ LÝ TRUNG BÌNH</div>
                        <div class="fs-2 fw-bold text-info">${avgDays} <small class="fs-6 text-muted">ngày / phiếu</small></div>
                    </div>
                </div>
            </div>

            <!-- BẢNG DỮ LIỆU LỊCH SỬ -->
            <div class="card-custom">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h5 class="fw-bold text-dark m-0">📋 Nhật Ký Nghiệm Thu Sự Cố</h5>
                    <small class="text-muted">Mới nhất xếp trước</small>
                </div>

                <c:choose>
                    <c:when test="${not empty dsLichSu}">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle">
                                <thead class="table-light">
                                    <tr>
                                        <th style="width: 60px;">ID</th>
                                        <th style="width: 110px;">Căn Hộ</th>
                                        <th>Tiêu Đề & Phân Loại</th>
                                        <th class="text-center" style="width: 140px;">Ngày Báo</th>
                                        <th class="text-center" style="width: 140px;">Ngày Hoàn Thành</th>
                                        <th class="text-center" style="width: 130px;">Thời Gian Xử Lý</th>
                                        <th class="text-center" style="width: 140px;">Ảnh Trước / Sau</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="item" items="${dsLichSu}">
                                        <tr>
                                            <td><strong>#${item.id}</strong></td>
                                            <td>
                                                <span class="fw-bold text-primary">${not empty item.soPhong ? item.soPhong : (not empty item.maCanHoCode ? item.maCanHoCode : 'Căn #'.concat(item.maCanHoId))}</span>
                                            </td>
                                            <td>
                                                <div><strong>${item.tieuDe}</strong></div>
                                                <small class="text-muted">📁 ${DisplayUtil.getLoaiSuCoText(item.loaiSuCo)} | Ưu tiên: ${DisplayUtil.getMucDoUuTienText(item.mucDoUuTien)}</small>
                                            </td>
                                            <td class="text-center text-muted small">
                                                ${DisplayUtil.formatDate(item.ngayGui)}
                                            </td>
                                            <td class="text-center text-success small fw-semibold">
                                                ${DisplayUtil.formatDate(item.ngayHoanThanh)}
                                            </td>
                                            <td class="text-center">
                                                <span class="badge bg-success-subtle text-success border border-success">
                                                    ⏱️ ${item.thoiGianXuLyNgay} ngày
                                                </span>
                                            </td>
                                            <td class="text-center">
                                                <button type="button" class="btn btn-sm btn-outline-secondary fw-semibold" data-bs-toggle="modal" data-bs-target="#modalPhoto_${item.id}">
                                                    🖼️ Xem ảnh
                                                </button>
                                            </td>
                                        </tr>

                                        <!-- MODAL XEM ẢNH TRƯỚC VÀ SAU -->
                                        <div class="modal fade" id="modalPhoto_${item.id}" tabindex="-1">
                                            <div class="modal-dialog modal-lg">
                                                <div class="modal-content">
                                                    <div class="modal-header bg-light">
                                                        <h5 class="modal-title fw-bold text-dark">🖼️ Đối Chiếu Ảnh Trước & Sau Xử Lý #${item.id}</h5>
                                                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                    </div>
                                                    <div class="modal-body">
                                                        <p class="mb-3"><strong>Sự cố:</strong> ${item.tieuDe}</p>
                                                        <div class="row g-3">
                                                            <div class="col-md-6">
                                                                <div class="border rounded p-2 text-center bg-white">
                                                                    <small class="fw-bold text-muted d-block mb-2">Ảnh Trước Xử Lý</small>
                                                                    <c:choose>
                                                                        <c:when test="${not empty item.anhTruocXuLy}">
                                                                            <img src="${pageContext.request.contextPath}/${item.anhTruocXuLy}" class="img-fluid rounded border" style="max-height: 250px; object-fit: cover;" alt="Ảnh trước">
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <div class="py-4 text-muted small">Không có ảnh đính kèm</div>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </div>
                                                            </div>
                                                            <div class="col-md-6">
                                                                <div class="border rounded p-2 text-center bg-white">
                                                                    <small class="fw-bold text-success d-block mb-2">Ảnh Nghiệm Thu Sau Xử Lý</small>
                                                                    <c:choose>
                                                                        <c:when test="${not empty item.anhSauXuLy}">
                                                                            <img src="${pageContext.request.contextPath}/${item.anhSauXuLy}" class="img-fluid rounded border" style="max-height: 250px; object-fit: cover;" alt="Ảnh sau">
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <div class="py-4 text-muted small">Chưa có ảnh nghiệm thu</div>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="modal-footer">
                                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>

                        <!-- Pagination -->
                        <c:if test="${totalPages > 1}">
                            <nav class="mt-3">
                                <ul class="pagination justify-content-center mb-0">
                                    <c:forEach var="p" begin="1" end="${totalPages}">
                                        <li class="page-item ${p == currentPage ? 'active' : ''}">
                                            <a class="page-link" href="${pageContext.request.contextPath}/kythuat/lich-su?page=${p}">${p}</a>
                                        </li>
                                    </c:forEach>
                                </ul>
                            </nav>
                        </c:if>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center py-5 text-muted">
                            📭 Bạn chưa hoàn thành phản ánh sự cố nào.
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
