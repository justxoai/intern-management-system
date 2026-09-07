<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Báo cáo Cuối kỳ — HR</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        :root {
            --sidebar-w: 250px; --sidebar-bg: #0c1f3f; --accent: #0ea5e9;
            --page-bg: #f0f6ff; --card-bg: #fff;
            --text-primary: #0f172a; --text-muted: #64748b; --border: #e2e8f0;
        }
        body { font-family: 'Inter', sans-serif; background: var(--page-bg); display: flex; min-height: 100vh; }

        /* ── Sidebar ── */
        .sidebar { width: var(--sidebar-w); background: var(--sidebar-bg); display: flex; flex-direction: column; flex-shrink: 0; position: fixed; height: 100vh; overflow-y: auto; z-index: 100; }
        .sidebar-brand { padding: 28px 22px 20px; border-bottom: 1px solid rgba(255,255,255,.08); }
        .brand-icon { width: 40px; height: 40px; border-radius: 10px; background: linear-gradient(135deg, #0ea5e9, #38bdf8); display: flex; align-items: center; justify-content: center; font-size: 1.15rem; color: #fff; margin-bottom: 10px; }
        .sidebar-brand h1 { color: #fff; font-size: .95rem; font-weight: 700; line-height: 1.3; }
        .sidebar-brand span { color: rgba(255,255,255,.4); font-size: .72rem; }
        .sidebar-section-label { padding: 18px 22px 6px; font-size: .67rem; font-weight: 700; text-transform: uppercase; letter-spacing: .8px; color: rgba(255,255,255,.3); }
        .sidebar-nav { list-style: none; padding: 0 12px; }
        .sidebar-nav li a { display: flex; align-items: center; gap: 10px; padding: 10px 12px; border-radius: 8px; margin-bottom: 2px; text-decoration: none; color: rgba(255,255,255,.65); font-size: .84rem; font-weight: 500; transition: background .15s, color .15s; }
        .sidebar-nav li a:hover { background: rgba(255,255,255,.07); color: #fff; }
        .sidebar-nav li a.active { background: rgba(14,165,233,.2); color: #fff; border-left: 3px solid var(--accent); }
        .sidebar-nav li a i { font-size: 1rem; width: 20px; }
        .sidebar-footer { margin-top: auto; padding: 16px 22px; border-top: 1px solid rgba(255,255,255,.08); }
        .sidebar-user { display: flex; align-items: center; gap: 10px; }
        .avatar { width: 34px; height: 34px; border-radius: 50%; background: linear-gradient(135deg, #0ea5e9, #38bdf8); display: flex; align-items: center; justify-content: center; font-size: .85rem; color: #fff; font-weight: 700; flex-shrink: 0; }
        .sidebar-user-info { flex: 1; min-width: 0; }
        .sidebar-user-name { color: #fff; font-size: .82rem; font-weight: 600; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .sidebar-user-role { color: rgba(255,255,255,.4); font-size: .7rem; }
        .logout-btn { color: rgba(255,255,255,.4); font-size: 1rem; text-decoration: none; transition: color .15s; }
        .logout-btn:hover { color: #f87171; }

        /* ── Main ── */
        .main { margin-left: var(--sidebar-w); flex: 1; display: flex; flex-direction: column; }
        .topbar { background: var(--card-bg); padding: 16px 32px; border-bottom: 1px solid var(--border); display: flex; align-items: center; justify-content: space-between; position: sticky; top: 0; z-index: 50; box-shadow: 0 1px 4px rgba(0,0,0,.06); }
        .page-title { font-size: 1.2rem; font-weight: 700; color: var(--text-primary); }
        .page-sub   { font-size: .8rem; color: var(--text-muted); margin-top: 1px; }
        .content { padding: 28px 32px; flex: 1; }

        /* ── Summary strip ── */
        .summary-strip { display: grid; grid-template-columns: repeat(4, 1fr); gap: 14px; margin-bottom: 24px; }
        .sum-card { background: var(--card-bg); border: 1px solid var(--border); border-radius: 14px; padding: 18px 20px; display: flex; align-items: center; gap: 14px; box-shadow: 0 1px 4px rgba(0,0,0,.05); }
        .sum-icon { width: 44px; height: 44px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 1.2rem; flex-shrink: 0; }
        .si-blue  { background: #eff6ff; color: #0ea5e9; }
        .si-green { background: #f0fdf4; color: #10b981; }
        .si-amber { background: #fefce8; color: #f59e0b; }
        .si-purple{ background: #f5f3ff; color: #8b5cf6; }
        .sum-num  { font-size: 1.6rem; font-weight: 800; color: var(--text-primary); line-height: 1; }
        .sum-lbl  { font-size: .74rem; color: var(--text-muted); font-weight: 500; margin-top: 2px; }

        /* ── Filter bar ── */
        .filter-bar { background: var(--card-bg); border-radius: 12px; border: 1px solid var(--border); padding: 14px 20px; display: flex; align-items: flex-end; gap: 12px; flex-wrap: wrap; margin-bottom: 20px; box-shadow: 0 1px 4px rgba(0,0,0,.05); }
        .filter-group { display: flex; flex-direction: column; gap: 4px; }
        .filter-label { font-size: .68rem; font-weight: 700; color: var(--text-muted); text-transform: uppercase; letter-spacing: .4px; }
        .filter-input, .filter-select { padding: 8px 11px; border: 1.5px solid var(--border); border-radius: 8px; font-family: 'Inter', sans-serif; font-size: .83rem; color: var(--text-primary); outline: none; transition: border-color .2s; min-width: 140px; }
        .filter-input:focus, .filter-select:focus { border-color: var(--accent); }
        .btn-filter { padding: 8px 18px; border-radius: 8px; border: none; cursor: pointer; font-family: 'Inter', sans-serif; font-size: .83rem; font-weight: 600; display: flex; align-items: center; gap: 5px; transition: opacity .15s; }
        .btn-filter.blue { background: var(--accent); color: #fff; }
        .btn-filter.ghost { background: var(--border); color: var(--text-muted); text-decoration: none; }
        .btn-filter:hover { opacity: .85; }
        .btn-print { padding: 8px 18px; border-radius: 8px; border: 1.5px solid var(--border); background: #fff; cursor: pointer; font-family: 'Inter', sans-serif; font-size: .83rem; font-weight: 600; display: flex; align-items: center; gap: 5px; color: var(--text-muted); transition: all .15s; }
        .btn-print:hover { border-color: var(--accent); color: var(--accent); }

        /* ── Table ── */
        .report-card { background: var(--card-bg); border-radius: 16px; border: 1px solid var(--border); overflow: hidden; box-shadow: 0 1px 6px rgba(0,0,0,.05); }
        .report-card-header { padding: 16px 22px; border-bottom: 1px solid var(--border); display: flex; align-items: center; gap: 10px; }
        .rh-icon { width: 36px; height: 36px; border-radius: 9px; background: #eff6ff; color: var(--accent); display: flex; align-items: center; justify-content: center; font-size: .95rem; }
        .rh-title { font-size: .95rem; font-weight: 700; color: var(--text-primary); flex: 1; }

        .data-table { width: 100%; border-collapse: collapse; font-size: .83rem; }
        .data-table thead th { padding: 11px 14px; text-align: left; font-size: .68rem; font-weight: 700; text-transform: uppercase; letter-spacing: .5px; color: var(--text-muted); background: #f8fafc; border-bottom: 1px solid var(--border); white-space: nowrap; }
        .data-table tbody td { padding: 13px 14px; color: var(--text-primary); border-bottom: 1px solid #f1f5f9; vertical-align: middle; }
        .data-table tbody tr:last-child td { border-bottom: none; }
        .data-table tbody tr:hover td { background: #f0f9ff; }

        .intern-cell { display: flex; align-items: center; gap: 9px; }
        .intern-avatar { width: 32px; height: 32px; border-radius: 50%; background: linear-gradient(135deg, #0ea5e9, #38bdf8); display: flex; align-items: center; justify-content: center; font-size: .75rem; font-weight: 700; color: #fff; flex-shrink: 0; }
        .intern-name { font-weight: 600; font-size: .86rem; }
        .intern-sub  { font-size: .72rem; color: var(--text-muted); }

        .badge { display: inline-flex; align-items: center; gap: 3px; padding: 3px 10px; border-radius: 20px; font-size: .68rem; font-weight: 600; white-space: nowrap; }
        .badge-interning  { background: #eff6ff; color: #0ea5e9; }
        .badge-approved   { background: #f0fdf4; color: #16a34a; }
        .badge-completed  { background: #f5f3ff; color: #7c3aed; }
        .badge-pending    { background: #fefce8; color: #a16207; }
        .badge-rejected   { background: #fef2f2; color: #dc2626; }

        /* Progress mini-bar */
        .mini-bar-wrap { display: flex; align-items: center; gap: 7px; }
        .mini-bar { flex: 1; height: 6px; background: #f1f5f9; border-radius: 999px; overflow: hidden; min-width: 60px; }
        .mini-fill { height: 100%; border-radius: 999px; }
        .fill-excellent { background: linear-gradient(90deg, #10b981, #34d399); }
        .fill-good      { background: linear-gradient(90deg, #0ea5e9, #38bdf8); }
        .fill-average   { background: linear-gradient(90deg, #f59e0b, #fbbf24); }
        .fill-bad       { background: linear-gradient(90deg, #ef4444, #f87171); }
        .fill-na        { background: #e2e8f0; }
        .mini-pct { font-size: .72rem; font-weight: 700; color: var(--text-muted); min-width: 32px; }

        .grade-badge { padding: 3px 9px; border-radius: 6px; font-size: .7rem; font-weight: 700; white-space: nowrap; }
        .grade-excellent { background: #f0fdf4; color: #15803d; }
        .grade-good      { background: #eff6ff; color: #0369a1; }
        .grade-average   { background: #fefce8; color: #a16207; }
        .grade-bad       { background: #fef2f2; color: #b91c1c; }
        .grade-na        { background: #f1f5f9; color: #475569; }

        .check-icon { font-size: .9rem; }
        .ci-yes { color: #10b981; }
        .ci-no  { color: #e2e8f0; }

        .empty-state { padding: 48px; text-align: center; color: var(--text-muted); }
        .empty-state i { font-size: 2rem; display: block; margin-bottom: 10px; opacity: .3; }

        @media print {
            .sidebar, .topbar .btn-print, .filter-bar, .no-print { display: none !important; }
            .main { margin-left: 0; }
            .topbar { position: relative; box-shadow: none; }
            body { background: #fff; }
        }
    </style>
</head>
<body>

<%-- ── Sidebar ── --%>
<aside class="sidebar">
    <div class="sidebar-brand">
        <div class="brand-icon"><i class="bi bi-building"></i></div>
        <h1>Nhân sự (HR)</h1>
    </div>
    <div class="sidebar-section-label">Quản lý</div>
    <ul class="sidebar-nav">
        <li><a href="${pageContext.request.contextPath}/hr/dashboard"><i class="bi bi-grid"></i> Tổng quan</a></li>
        <li><a href="${pageContext.request.contextPath}/hr/applications"><i class="bi bi-clipboard-check"></i> Đơn xét tuyển</a></li>
        <li><a href="${pageContext.request.contextPath}/hr/documents"><i class="bi bi-folder-check"></i> Duyệt tài liệu</a></li>
    </ul>
    <div class="sidebar-footer">
        <div class="sidebar-user">
            <div class="avatar">${fn:substring(sessionScope.currentUser.fullName, 0, 1)}</div>
            <div class="sidebar-user-info">
                <div class="sidebar-user-name">${sessionScope.currentUser.fullName}</div>
                <div class="sidebar-user-role">Nhân sự</div>
            </div>
            <a href="${pageContext.request.contextPath}/logout" class="logout-btn" title="Đăng xuất"><i class="bi bi-box-arrow-right"></i></a>
        </div>
    </div>
</aside>

<%-- ── Main ── --%>
<div class="main">
    <div class="topbar">
        <div>
            <div class="page-title"><i class="bi bi-bar-chart-line" style="color:var(--accent);margin-right:8px"></i>Báo cáo Cuối kỳ</div>
            <div class="page-sub">Tổng hợp đánh giá kết quả thực tập dành cho Trưởng bộ phận &amp; Trường đại học</div>
        </div>
        <button class="btn-print no-print" onclick="window.print()">
            <i class="bi bi-printer"></i> In / Xuất PDF
        </button>
    </div>

    <div class="content">

        <%-- Summary strip --%>
        <div class="summary-strip" style="grid-template-columns: repeat(5, 1fr)">
            <div class="sum-card">
                <div class="sum-icon si-blue"><i class="bi bi-people"></i></div>
                <div>
                    <div class="sum-num">${totalInterns}</div>
                    <div class="sum-lbl">Tổng số TTS</div>
                </div>
            </div>
            <div class="sum-card">
                <div class="sum-icon si-green"><i class="bi bi-person-workspace"></i></div>
                <div>
                    <div class="sum-num">${activeInterns}</div>
                    <div class="sum-lbl">Đang thực tập</div>
                </div>
            </div>
            <div class="sum-card">
                <div class="sum-icon si-purple"><i class="bi bi-patch-check"></i></div>
                <div>
                    <div class="sum-num">${evaluatedInterns} / ${totalInterns}</div>
                    <div class="sum-lbl">Đã có đánh giá</div>
                </div>
            </div>
            <div class="sum-card">
                <div class="sum-icon si-blue"><i class="bi bi-trophy"></i></div>
                <div>
                    <div class="sum-num">${avgOverallScore} <span style="font-size:.9rem;font-weight:600;color:var(--text-muted)">/ 10</span></div>
                    <div class="sum-lbl">Điểm TB toàn khóa</div>
                </div>
            </div>
            <div class="sum-card">
                <div class="sum-icon si-amber"><i class="bi bi-check2-circle"></i></div>
                <div>
                    <div class="sum-num">${doneTasks} / ${totalTasks}</div>
                    <div class="sum-lbl">Nhiệm vụ hoàn thành</div>
                </div>
            </div>
        </div>

        <%-- Filter bar --%>
        <form class="filter-bar no-print" method="get" action="${pageContext.request.contextPath}/hr/report">
            <div class="filter-group">
                <span class="filter-label">Trạng thái TTS</span>
                <select name="internStatus" class="filter-select">
                    <option value="">Tất cả trạng thái</option>
                    <option value="INTERNING"  ${filterStatus == 'INTERNING'  ? 'selected' : ''}>Đang thực tập</option>
                    <option value="APPROVED"   ${filterStatus == 'APPROVED'   ? 'selected' : ''}>Đã duyệt</option>
                    <option value="COMPLETED"  ${filterStatus == 'COMPLETED'  ? 'selected' : ''}>Hoàn thành</option>
                    <option value="PENDING"    ${filterStatus == 'PENDING'    ? 'selected' : ''}>Chờ duyệt</option>
                    <option value="REJECTED"   ${filterStatus == 'REJECTED'   ? 'selected' : ''}>Từ chối</option>
                </select>
            </div>
            <div class="filter-group">
                <span class="filter-label">Trường đại học</span>
                <input class="filter-input" type="text" name="university" value="${filterUniversity}" placeholder="Tìm theo trường…">
            </div>
            <div class="filter-group">
                <span class="filter-label">Chuyên ngành</span>
                <input class="filter-input" type="text" name="major" value="${filterMajor}" placeholder="Tìm theo chuyên ngành…">
            </div>
            <button type="submit" class="btn-filter blue"><i class="bi bi-funnel"></i> Lọc</button>
            <a href="${pageContext.request.contextPath}/hr/report" class="btn-filter ghost" style="text-decoration:none">Xóa lọc</a>
        </form>

        <%-- Official Header for Print Mode --%>
        <div class="print-official-header" style="display:none">
            <div style="display:flex;justify-content:space-between;align-items:flex-start;margin-bottom:20px;border-bottom:2px solid #0f172a;padding-bottom:14px">
                <div>
                    <div style="font-weight:800;font-size:1rem;text-transform:uppercase">CÔNG TY CỔ PHẦN CÔNG NGHỆ &amp; ĐÀO TẠO</div>
                    <div style="font-size:.85rem;color:#475569">Ban Nhân sự &amp; Quản lý Thực tập sinh</div>
                </div>
                <div style="text-align:right">
                    <div style="font-weight:700;font-size:.85rem">CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM</div>
                    <div style="font-size:.8rem;color:#475569">Độc lập - Tự do - Hạnh phúc</div>
                </div>
            </div>
            <div style="text-align:center;margin-bottom:24px">
                <h2 style="font-size:1.3rem;font-weight:800;text-transform:uppercase;margin-bottom:4px">BÁO CÁO TỔNG KẾT KẾT QUẢ THỰC TẬP TỐT NGHIỆP</h2>
                <div style="font-size:.85rem;font-style:italic;color:#475569">Kính gửi: Ban Giám hiệu / Ban Chủ nhiệm Khoa &amp; Ban Lãnh đạo Công ty</div>
            </div>
        </div>

        <%-- Report table --%>
        <div class="report-card">
            <div class="report-card-header">
                <div class="rh-icon"><i class="bi bi-table"></i></div>
                <span class="rh-title">Báo cáo Đánh giá Kết quả Thực tập sinh Toàn khóa
                    <span style="font-size:.75rem;color:var(--text-muted);font-weight:500;margin-left:6px">(${fn:length(reportRows)} thực tập sinh)</span>
                </span>
            </div>
            <div style="overflow-x:auto">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Thực tập sinh</th>
                            <th>Trường / Ngành</th>
                            <th>Mentor</th>
                            <th>Tiến độ NV</th>
                            <th style="text-align:center">Điểm chi tiết (KT - TĐ - GT)</th>
                            <th style="text-align:center">Tổng kết</th>
                            <th>Xếp loại</th>
                            <th>Nhận xét của Mentor</th>
                            <th class="no-print">Phiếu ĐG</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty reportRows}">
                                <tr><td colspan="10">
                                    <div class="empty-state">
                                        <i class="bi bi-bar-chart"></i>
                                        Không tìm thấy dữ liệu thực tập sinh phù hợp với bộ lọc.
                                    </div>
                                </td></tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="r" items="${reportRows}" varStatus="st">
                                    <tr>
                                        <td style="color:var(--text-muted);font-size:.75rem">${st.index + 1}</td>
                                        <td>
                                            <div class="intern-cell">
                                                <div class="intern-avatar">${fn:substring(r.internName, 0, 1)}</div>
                                                <div>
                                                    <div class="intern-name">${r.internName}</div>
                                                    <div class="intern-sub">${r.internEmail}</div>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <div style="font-size:.82rem;font-weight:500">${r.major}</div>
                                            <div class="intern-sub">${r.university}</div>
                                        </td>
                                        <td style="font-size:.82rem">
                                            <c:choose>
                                                <c:when test="${not empty r.mentorName}">
                                                    <i class="bi bi-mortarboard" style="color:#10b981;margin-right:4px"></i>${r.mentorName}
                                                </c:when>
                                                <c:otherwise><span style="color:var(--text-muted)">—</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <div style="font-weight:600;font-size:.8rem">${r.completedTasks} / ${r.totalTasks} task</div>
                                            <div class="mini-bar-wrap" style="margin-top:3px">
                                                <div class="mini-bar" style="height:5px">
                                                    <div class="mini-fill fill-good" style="width:${r.completionRate}%"></div>
                                                </div>
                                                <span class="mini-pct" style="font-size:.68rem">${r.completionRate}%</span>
                                            </div>
                                        </td>
                                        <td style="text-align:center">
                                            <c:choose>
                                                <c:when test="${not empty r.technicalScore || not empty r.attitudeScore}">
                                                    <div style="font-size:.78rem;font-weight:700">
                                                        <span title="Kỹ thuật" style="color:#0284c7">${not empty r.technicalScore ? r.technicalScore : '—'}</span> /
                                                        <span title="Thái độ" style="color:#16a34a">${not empty r.attitudeScore ? r.attitudeScore : '—'}</span> /
                                                        <span title="Giao tiếp" style="color:#9333ea">${not empty r.communicationScore ? r.communicationScore : '—'}</span>
                                                    </div>
                                                    <div style="font-size:.66rem;color:var(--text-muted)">KT / TĐ / GT</div>
                                                </c:when>
                                                <c:otherwise><span style="color:var(--text-muted);font-size:.78rem">—</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td style="text-align:center">
                                            <c:choose>
                                                <c:when test="${not empty r.overallScore}">
                                                    <span style="display:inline-block;padding:3px 8px;border-radius:6px;background:#f0fdf4;color:#15803d;font-weight:800;font-size:.85rem">
                                                        ${r.overallScore}
                                                    </span>
                                                </c:when>
                                                <c:otherwise><span style="color:var(--text-muted);font-size:.78rem">—</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${r.evalGrade == 'Xuất sắc'}"><span class="badge badge-approved"><i class="bi bi-award-fill"></i> Xuất sắc</span></c:when>
                                                <c:when test="${r.evalGrade == 'Giỏi'}"><span class="badge badge-interning"><i class="bi bi-check-circle-fill"></i> Giỏi</span></c:when>
                                                <c:when test="${r.evalGrade == 'Khá'}"><span class="badge badge-completed"><i class="bi bi-check"></i> Khá</span></c:when>
                                                <c:when test="${r.evalGrade == 'Trung bình'}"><span class="badge badge-pending">Trung bình</span></c:when>
                                                <c:when test="${r.evalGrade == 'Chưa đạt'}"><span class="badge badge-rejected">Chưa đạt</span></c:when>
                                                <c:otherwise><span class="badge" style="background:#f1f5f9;color:#64748b">Chưa ĐG</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td style="max-width:200px">
                                            <c:choose>
                                                <c:when test="${not empty r.mentorComments}">
                                                    <div style="font-size:.76rem;color:#334155;line-height:1.4;max-height:45px;overflow:hidden;text-overflow:ellipsis" title="${r.mentorComments}">
                                                        ${r.mentorComments}
                                                    </div>
                                                </c:when>
                                                <c:otherwise><span style="color:var(--text-muted);font-size:.74rem;font-style:italic">Chưa có nhận xét</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="no-print">
                                            <button class="btn-filter ghost" style="padding:4px 10px;font-size:.74rem"
                                                    onclick="openCertModal('${fn:escapeXml(r.internName)}', '${fn:escapeXml(r.studentCode)}', '${fn:escapeXml(r.university)}', '${fn:escapeXml(r.major)}', '${fn:escapeXml(r.mentorName)}', '${r.technicalScore}', '${r.attitudeScore}', '${r.communicationScore}', '${r.overallScore}', '${r.evalGrade}', '${fn:escapeXml(r.mentorComments)}', '${r.completedTasks}/${r.totalTasks}')">
                                                <i class="bi bi-file-earmark-person"></i> Phiếu
                                            </button>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>

        <%-- Signatures for Print Mode --%>
        <div class="print-signatures" style="display:none;margin-top:40px;page-break-inside:avoid">
            <div style="display:flex;justify-content:space-between;text-align:center;padding:0 30px">
                <div>
                    <div style="font-weight:700;font-size:.88rem">NGƯỜI HƯỚNG DẪN (MENTOR)</div>
                    <div style="font-size:.76rem;font-style:italic;color:#64748b;margin-bottom:60px">(Ký và ghi rõ họ tên)</div>
                </div>
                <div>
                    <div style="font-size:.82rem;font-style:italic;margin-bottom:4px">Hà Nội, ngày ..... tháng ..... năm 2026</div>
                    <div style="font-weight:700;font-size:.88rem">ĐẠI DIỆN PHÒNG NHÂN SỰ (HR)</div>
                    <div style="font-size:.76rem;font-style:italic;color:#64748b;margin-bottom:60px">(Ký, đóng dấu và ghi rõ họ tên)</div>
                    <div style="font-weight:700">${sessionScope.currentUser.fullName}</div>
                </div>
            </div>
        </div>

        <%-- Print footer --%>
        <div class="no-print" style="margin-top:20px;padding:14px 20px;background:var(--card-bg);border-radius:10px;border:1px solid var(--border);font-size:.78rem;color:var(--text-muted);display:flex;justify-content:space-between;align-items:center">
            <span><i class="bi bi-building" style="margin-right:5px"></i>Hệ thống Quản lý Thực tập — Báo cáo Cuối kỳ</span>
            <span>Người lập báo cáo: ${sessionScope.currentUser.fullName} (HR)</span>
        </div>
    </div>
</div>

<%-- Modal: Phiếu Đánh Giá Chi Tiết Từng TTS --%>
<div class="modal-overlay no-print" id="certModal">
    <div class="modal-box" style="width:680px;background:#fff;border-radius:18px;overflow:hidden;box-shadow:0 20px 60px rgba(0,0,0,.25)">
        <div style="padding:18px 24px;background:linear-gradient(135deg, #0ea5e9, #38bdf8);display:flex;align-items:center;justify-content:space-between">
            <h3 style="color:#fff;font-size:1.05rem;font-weight:700;display:flex;align-items:center;gap:8px">
                <i class="bi bi-file-earmark-person-fill"></i> Phiếu Đánh Giá Kết Quả Thực Tập
            </h3>
            <button style="background:none;border:none;color:#fff;font-size:1.3rem;cursor:pointer" onclick="closeCertModal()">&#x2715;</button>
        </div>
        <div style="padding:24px;max-height:75vh;overflow-y:auto">
            <div style="border:2px solid #e2e8f0;border-radius:12px;padding:20px;background:#fafafa">
                <div style="text-align:center;margin-bottom:16px;border-bottom:1px dashed #cbd5e1;padding-bottom:12px">
                    <h4 style="font-size:1.1rem;font-weight:800;color:#0f172a;text-transform:uppercase" id="cName"></h4>
                    <div style="font-size:.82rem;color:#475569" id="cSub"></div>
                </div>

                <div style="display:grid;grid-template-columns:1fr 1fr;gap:12px;margin-bottom:18px;font-size:.84rem">
                    <div><strong>Trường:</strong> <span id="cUni"></span></div>
                    <div><strong>Chuyên ngành:</strong> <span id="cMajor"></span></div>
                    <div><strong>Người hướng dẫn:</strong> <span id="cMentor"></span></div>
                    <div><strong>Nhiệm vụ hoàn thành:</strong> <span id="cTasks"></span></div>
                </div>

                <div style="background:#fff;border:1px solid #e2e8f0;border-radius:10px;padding:14px;margin-bottom:16px">
                    <div style="font-weight:700;font-size:.8rem;text-transform:uppercase;color:#64748b;margin-bottom:10px">Kết quả đánh giá năng lực:</div>
                    <div style="display:grid;grid-template-columns:repeat(3, 1fr);gap:10px;text-align:center">
                        <div style="background:#eff6ff;padding:10px;border-radius:8px">
                            <div style="font-size:.72rem;color:#0284c7;font-weight:700">KỸ THUẬT CHUYÊN MÔN</div>
                            <div style="font-size:1.3rem;font-weight:800;color:#0369a1" id="cTech">-</div>
                        </div>
                        <div style="background:#f0fdf4;padding:10px;border-radius:8px">
                            <div style="font-size:.72rem;color:#16a34a;font-weight:700">THÁI ĐỘ &amp; TÁC PHONG</div>
                            <div style="font-size:1.3rem;font-weight:800;color:#15803d" id="cAtt">-</div>
                        </div>
                        <div style="background:#faf5ff;padding:10px;border-radius:8px">
                            <div style="font-size:.72rem;color:#9333ea;font-weight:700">GIAO TIẾP &amp; NHÓM</div>
                            <div style="font-size:1.3rem;font-weight:800;color:#7e22ce" id="cComm">-</div>
                        </div>
                    </div>
                    <div style="display:flex;align-items:center;justify-content:space-between;margin-top:14px;padding-top:12px;border-top:1px solid #f1f5f9">
                        <span style="font-weight:700;font-size:.9rem">Điểm Tổng Kết &amp; Xếp Loại:</span>
                        <div>
                            <span style="font-size:1.3rem;font-weight:800;color:#0ea5e9" id="cOver">-</span>
                            <span style="margin-left:6px;font-weight:700;font-size:.85rem;padding:3px 10px;border-radius:20px;background:#e0f2fe;color:#0369a1" id="cGrade">-</span>
                        </div>
                    </div>
                </div>

                <div>
                    <div style="font-weight:700;font-size:.8rem;text-transform:uppercase;color:#64748b;margin-bottom:6px">Nhận xét chi tiết từ Mentor:</div>
                    <div style="background:#fff;border:1px solid #e2e8f0;border-radius:8px;padding:12px;font-size:.85rem;color:#334155;line-height:1.5" id="cComments">Chưa có nhận xét.</div>
                </div>
            </div>
        </div>
        <div style="padding:14px 24px;background:#f8fafc;display:flex;justify-content:flex-end;gap:10px;border-top:1px solid #e2e8f0">
            <button type="button" class="btn-filter ghost" onclick="closeCertModal()">Đóng</button>
            <button type="button" class="btn-filter blue" onclick="window.print()"><i class="bi bi-printer"></i> In báo cáo</button>
        </div>
    </div>
</div>

<script>
    function openCertModal(name, code, uni, major, mentor, tech, att, comm, overall, grade, comments, tasks) {
        document.getElementById('cName').textContent = name;
        document.getElementById('cSub').textContent = 'Mã sinh viên: ' + (code || '—');
        document.getElementById('cUni').textContent = uni || '—';
        document.getElementById('cMajor').textContent = major || '—';
        document.getElementById('cMentor').textContent = mentor || '—';
        document.getElementById('cTasks').textContent = tasks || '—';
        document.getElementById('cTech').textContent = tech || '—';
        document.getElementById('cAtt').textContent = att || '—';
        document.getElementById('cComm').textContent = comm || '—';
        document.getElementById('cOver').textContent = overall || '—';
        document.getElementById('cGrade').textContent = grade || '—';
        document.getElementById('cComments').textContent = comments || 'Chưa có nhận xét từ Mentor.';
        document.getElementById('certModal').classList.add('open');
    }
    function closeCertModal() { document.getElementById('certModal').classList.remove('open'); }
    document.getElementById('certModal').addEventListener('click', function(e) {
        if (e.target === this) closeCertModal();
    });
</script>
</body>
</html>
