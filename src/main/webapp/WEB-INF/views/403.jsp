<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" isErrorPage="true" %>
<%
    response.setStatus(HttpServletResponse.SC_FORBIDDEN);
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/WEB-INF/views/common/head.jsp" %>
    <title>403 Forbidden — Không có quyền truy cập</title>

    <style>
body { background-color: #F4EFE4; font-family: 'Be Vietnam Pro', sans-serif; display: flex; align-items: center; justify-content: center; min-height: 100vh; margin: 0; }
        .error-card { background: #FFF; padding: 40px; border-radius: 16px; border: 1px solid #EAE3D2; box-shadow: 0 8px 24px rgba(0,0,0,0.06); text-align: center; max-width: 480px; width: 90%; }
        .error-code { font-size: 4rem; font-weight: 800; color: #DC3545; line-height: 1; margin-bottom: 12px; }
        .error-title { font-size: 1.3rem; font-weight: 700; color: #1E3B34; margin-bottom: 12px; }
        .error-msg { font-size: 0.95rem; color: #6C757D; margin-bottom: 24px; }
    </style>
</head>
<body>
    <div class="error-card">
        <div class="error-code">403</div>
        <div class="error-title">Truy Cập Bị Từ Chối</div>
        <div class="error-msg">Bạn không có quyền truy cập vào khu vực này. Vui lòng đăng nhập bằng tài khoản có vai trò phù hợp.</div>
        <a href="${pageContext.request.contextPath}/dang-nhap.jsp" class="btn btn-warning text-dark fw-bold px-4 py-2">Quay về trang đăng nhập</a>
    </div>
</body>
</html>
