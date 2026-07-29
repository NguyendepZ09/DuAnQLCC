<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bảng Tin Bảo Vệ — PolyBuilding</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
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

        /* Sidebar & Header Shared Layout */
        .sidebar {
            width: 260px;
            background-color: var(--bv-primary);
            color: #FFFFFF;
            flex-shrink: 0;
            display: flex;
            flex-direction: column;
        }

        .sidebar-brand {
            padding: 20px;
            font-size: 1.2rem;
            font-weight: 700;
            color: var(--bv-gold);
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }

        .sidebar-user {
            padding: 15px 20px;
            display: flex;
            align-items: center;
            gap: 12px;
            border-bottom: 1px solid rgba(255,255,255,0.1);
            background-color: rgba(0,0,0,0.1);
        }

        .sidebar-user .avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background-color: var(--bv-gold);
            color: #FFF;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
        }

        .sidebar-user .name {
            font-weight: 600;
            font-size: 0.95rem;
            display: block;
        }

        .sidebar-user .role {
            font-size: 0.75rem;
            color: #A0AEC0;
        }

        .sidebar-nav {
            padding: 15px 10px;
            display: flex;
            flex-direction: column;
            gap: 5px;
        }

        .nav-item {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 10px 15px;
            color: rgba(255, 255, 255, 0.8);
            text-decoration: none;
            border-radius: 8px;
            transition: all 0.2s;
            font-size: 0.95rem;
        }

        .nav-item:hover {
            background-color: rgba(255,255,255,0.1);
            color: #FFF;
        }

        .nav-item.active {
            background-color: var(--bv-gold);
            color: #FFF;
            font-weight: 600;
        }

        .nav-divider {
            height: 1px;
            background-color: rgba(255,255,255,0.1);
            margin: 10px 0;
        }

        /* Main Content */
        .main-content {
            flex-grow: 1;
            display: flex;
            flex-direction: column;
        }

        .top-header {
            background-color: #FFFFFF;
            padding: 15px 30px;
            border-bottom: 1px solid var(--bv-border);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .top-header h2 {
            margin: 0;
            font-size: 1.3rem;
            color: var(--bv-primary);
            font-weight: 700;
        }

        .top-header .sub {
            font-size: 0.85rem;
            color: #718096;
        }

        .content-body {
            padding: 25px 30px;
        }

        .stat-card {
            background: var(--bv-card-bg);
            border-radius: 12px;
            padding: 20px;
            border: 1px solid var(--bv-border);
            box-shadow: 0 2px 8px rgba(0,0,0,0.04);
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .stat-card .val {
            font-size: 1.8rem;
            font-weight: 700;
            color: var(--bv-primary);
        }

        .stat-card .lbl {
            font-size: 0.85rem;
            color: #718096;
            font-weight: 500;
        }

        .stat-card .icon {
            width: 50px;
            height: 50px;
            border-radius: 10px;
            background: rgba(30, 59, 52, 0.08);
            color: var(--bv-primary);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.4rem;
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
    </style>
</head>
<body>

    <!-- SIDEBAR -->
    <jsp:include page="/WEB-INF/views/baove/common/sidebar.jsp" />

    <!-- MAIN CONTENT -->
    <div class="main-content">
        <jsp:include page="/WEB-INF/views/baove/common/header.jsp" />

        <div class="content-body">
            
            <!-- STATS CARDS -->
            <div class="row g-3 mb-4">
                <div class="col-md-3">
                    <div class="stat-card">
                        <div>
                            <div class="val">${stats.luotTuanTraHomNay}</div>
                            <div class="lbl">Lượt tuần tra hôm nay</div>
                        </div>
                        <div class="icon">🛡️</div>
                    </div>
                </div>

                <div class="col-md-3">
                    <div class="stat-card">
                        <div>
                            <div class="val text-danger">${stats.tangChuaTuanTraCount}</div>
                            <div class="lbl">Tầng chưa quét (24h qua)</div>
                        </div>
                        <div class="icon bg-danger bg-opacity-10 text-danger">⚠️</div>
                    </div>
                </div>

                <div class="col-md-3">
                    <div class="stat-card">
                        <div>
                            <div class="val text-warning">${stats.caTrucDangMo}</div>
                            <div class="lbl">Ca trực đang mở</div>
                        </div>
                        <div class="icon bg-warning bg-opacity-10 text-warning">⏳</div>
                    </div>
                </div>

                <div class="col-md-3">
                    <div class="stat-card">
                        <div>
                            <div class="val text-info">${stats.caChoNhanBanGiaoCount}</div>
                            <div class="lbl">Ca chờ tôi nhận bàn giao</div>
                        </div>
                        <div class="icon bg-info bg-opacity-10 text-info">🤝</div>
                    </div>
                </div>
            </div>

            <!-- TẦNG CHƯA TUẦN TRA 24H -->
            <div class="card-custom">
                <div class="card-header-custom">
                    <span>⚠️ Danh Sách Tầng Chưa Được Tuần Tra Trong 24H Qua</span>
                    <a href="${pageContext.request.contextPath}/baove/tuan-tra" class="btn btn-sm btn-outline-success">
                        🛡️ Đến Màn Hình Tuần Tra
                    </a>
                </div>
                <div class="card-body p-3">
                    <c:choose>
                        <c:when test="${not empty stats.tangChuaTuanTraList}">
                            <div class="d-flex flex-wrap gap-2">
                                <c:forEach var="t" items="${stats.tangChuaTuanTraList}">
                                    <span class="badge bg-danger fs-6 px-3 py-2">Tầng <c:out value="${t}"/></span>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="alert alert-success m-0" role="alert">
                                🎉 Tất cả 25 tầng đã được tuần tra đầy đủ trong 24h qua!
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- TOP 5 LƯỢT TUẦN TRA GẦN NHẤT -->
            <div class="card-custom">
                <div class="card-header-custom">
                    <span>📋 5 Lượt Tuần Tra Gần Nhất Của Tôi</span>
                </div>
                <div class="card-body p-0">
                    <table class="table table-hover align-middle m-0">
                        <thead class="table-light">
                            <tr>
                                <th class="ps-3">STT</th>
                                <th>Tầng Tuần Tra</th>
                                <th>Thời Gian Quét</th>
                                <th>Ảnh Minh Chứng</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty stats.top5TuanTra}">
                                    <c:forEach var="row" items="${stats.top5TuanTra}" varStatus="loop">
                                        <tr>
                                            <td class="ps-3 fw-bold">${loop.count}</td>
                                            <td><span class="badge bg-primary fs-6">Tầng <c:out value="${row[1]}"/></span></td>
                                            <td><c:out value="${row[2]}"/></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty row[3]}">
                                                        <span class="text-muted small">📷 <c:out value="${row[3]}"/></span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">—</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="4" class="text-center text-muted py-4">Bạn chưa thực hiện lượt tuần tra nào hôm nay.</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>

        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            // Dashboard initialized
        });
    </script>
</body>
</html>
