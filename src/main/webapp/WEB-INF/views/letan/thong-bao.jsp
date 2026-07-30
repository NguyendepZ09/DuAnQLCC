<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/WEB-INF/views/common/head.jsp" %>
    <title>Thông Báo - PolyBuilding Lễ Tân</title>
</head>
<body>

<div class="app-layout">
    <jsp:include page="/WEB-INF/views/letan/common/sidebar.jsp" />

    <div class="main-wrapper">
        <jsp:include page="/WEB-INF/views/letan/common/header.jsp" />

        <main class="content-body p-4">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h4 class="fw-bold mb-1" style="color: #1E3B34;">📢 Thông Báo Nhân Viên</h4>
                    <p class="text-muted small m-0">Xem danh sách thông báo chỉ đạo từ Ban Quản Lý</p>
                </div>
            </div>

            <c:choose>
                <c:when test="${not empty dsThongBao}">
                    <div class="row g-3">
                        <c:forEach var="tb" items="${dsThongBao}">
                            <div class="col-12">
                                <div class="card shadow-sm border-0 ${!tb.daDoc ? 'border-start border-4 border-warning bg-light-subtle' : ''}">
                                    <div class="card-body p-3">
                                        <div class="d-flex justify-content-between align-items-start mb-2">
                                            <h5 class="fw-bold m-0 text-dark">
                                                <c:if test="${!tb.daDoc}">
                                                    <span class="badge bg-warning text-dark me-2">Mới</span>
                                                </c:if>
                                                <span class="badge ${tb.loaiThongBaoBadgeClass} me-2">
                                                    <c:if test="${tb.loaiThongBao == 'KhanCap'}">🚨 </c:if><c:out value="${tb.loaiThongBaoText}" />
                                                </span>
                                                <c:out value="${tb.tieuDe}" />
                                            </h5>
                                            <small class="text-muted font-monospace">📅 <c:out value="${tb.ngayTaoText}" /></small>
                                        </div>

                                        <p class="card-text text-secondary mb-3" style="white-space: pre-line;"><c:out value="${tb.noiDung}" /></p>

                                        <div class="d-flex justify-content-between align-items-center pt-2 border-top">
                                            <small class="text-muted">👤 Người gửi: <strong class="text-dark"><c:out value="${tb.tenNguoiGui}" /></strong></small>
                                            <c:choose>
                                                <c:when test="${!tb.daDoc}">
                                                    <form method="POST" action="${pageContext.request.contextPath}/letan/thong-bao/da-doc" class="m-0">
                                                        <input type="hidden" name="maThongBao" value="${tb.id}">
                                                        <button type="submit" class="btn btn-sm btn-outline-success">
                                                            ✓ Đánh dấu đã đọc
                                                        </button>
                                                    </form>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-secondary">✓ Đã đọc</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="card shadow-sm border-0 p-5 text-center">
                        <div class="text-muted fs-5">📭 Hiện chưa có thông báo nào dành cho nhân viên.</div>
                    </div>
                </c:otherwise>
            </c:choose>
        </main>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
