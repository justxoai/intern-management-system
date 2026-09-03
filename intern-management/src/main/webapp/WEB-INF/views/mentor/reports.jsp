<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Báo cáo tuần Thực tập sinh — Cổng thông tin Mentor</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        :root {
            --sidebar-w: 250px;
            --sidebar-bg: #0f2318;
            --accent: #10b981;
            --accent2: #34d399;
            --task-col: #0891b2;
            --page-bg: #f0fdf6;
            --card-bg: #fff;
            --text-primary: #0f172a;
            --text-muted: #64748b;
            --border: #e2e8f0;
        }
        body { font-family: 'Inter', sans-serif; background: var(--page-bg); display: flex; min-height: 100vh; }

        /* Sidebar */
        .sidebar { width: var(--sidebar-w); background: var(--sidebar-bg); display: flex; flex-direction: column; flex-shrink: 0; position: fixed; height: 100vh; overflow-y: auto; z-index: 100; }
        .sidebar-brand { padding: 28px 22px 20px; border-bottom: 1px solid rgba(255,255,255,.08); }
        .sidebar-brand .brand-icon { width: 40px; height: 40px; border-radius: 10px; background: linear-gradient(135deg, #10b981, #34d399); display: flex; align-items: center; justify-content: center; font-size: 1.15rem; color: #fff; margin-bottom: 10px; }
        .sidebar-brand h1 { color: #fff; font-size: .95rem; font-weight: 700; line-height: 1.3; }
        .sidebar-brand span { color: rgba(255,255,255,.4); font-size: .72rem; }
        .sidebar-section-label { padding: 18px 22px 6px; font-size: .67rem; font-weight: 700; text-transform: uppercase; letter-spacing: .8px; color: rgba(255,255,255,.3); }
        .sidebar-nav { list-style: none; padding: 0 12px; }
        .sidebar-nav li a { display: flex; align-items: center; gap: 10px; padding: 10px 12px; border-radius: 8px; margin-bottom: 2px; text-decoration: none; color: rgba(255,255,255,.65); font-size: .84rem; font-weight: 500; transition: background .15s, color .15s; }
        .sidebar-nav li a:hover { background: rgba(255,255,255,.07); color: #fff; }
        .sidebar-nav li a.active { background: rgba(16,185,129,.2); color: #fff; border-left: 3px solid var(--accent); }
        .sidebar-nav li a i { font-size: 1rem; width: 20px; }
        .sidebar-footer { margin-top: auto; padding: 16px 22px; border-top: 1px solid rgba(255,255,255,.08); }
        .sidebar-user { display: flex; align-items: center; gap: 10px; }
        .avatar { width: 34px; height: 34px; border-radius: 50%; background: linear-gradient(135deg, #10b981, #34d399); display: flex; align-items: center; justify-content: center; font-size: .85rem; color: #fff; font-weight: 700; flex-shrink: 0; }
        .sidebar-user-info { flex: 1; min-width: 0; }
        .sidebar-user-name { color: #fff; font-size: .82rem; font-weight: 600; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .sidebar-user-role { color: rgba(255,255,255,.4); font-size: .7rem; }
        .logout-btn { color: rgba(255,255,255,.4); font-size: 1rem; text-decoration: none; transition: color .15s; }
        .logout-btn:hover { color: #f87171; }

        /* Main */
        .main { margin-left: var(--sidebar-w); flex: 1; display: flex; flex-direction: column; }
        .topbar { background: var(--card-bg); padding: 16px 32px; border-bottom: 1px solid var(--border); display: flex; align-items: center; justify-content: space-between; position: sticky; top: 0; z-index: 50; box-shadow: 0 1px 4px rgba(0,0,0,.06); }
        .page-title { font-size: 1.2rem; font-weight: 700; color: var(--text-primary); }
        .page-sub { font-size: .8rem; color: var(--text-muted); margin-top: 1px; }
        .content { padding: 28px 32px; flex: 1; }

        /* Stats */
        .stats-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 16px; margin-bottom: 24px; }
        .stat-card { background: var(--card-bg); border-radius: 14px; padding: 18px 20px; border: 1px solid var(--border); display: flex; align-items: center; gap: 14px; box-shadow: 0 1px 4px rgba(0,0,0,.04); }
        .stat-icon { width: 44px; height: 44px; border-radius: 11px; display: flex; align-items: center; justify-content: center; font-size: 1.2rem; flex-shrink: 0; }
        .si-all   { background: linear-gradient(135deg, #0891b2, #22d3ee); color: #fff; }
        .si-amber { background: #fefce8; color: #d97706; }
        .si-green { background: #f0fdf4; color: #16a34a; }
        .stat-num { font-size: 1.6rem; font-weight: 800; color: var(--text-primary); line-height: 1; }
        .stat-lbl { font-size: .74rem; color: var(--text-muted); margin-top: 3px; font-weight: 500; }

        /* Section Card */
        .sec-card { background: var(--card-bg); border-radius: 16px; border: 1px solid var(--border); margin-bottom: 24px; overflow: hidden; box-shadow: 0 1px 6px rgba(0,0,0,.05); }
        .sec-header { padding: 16px 22px; display: flex; align-items: center; justify-content: space-between; border-bottom: 1px solid var(--border); }
        .sec-header-left { display: flex; align-items: center; gap: 10px; }
        .sec-icon { width: 36px; height: 36px; border-radius: 9px; background: #ecfeff; color: #0891b2; display: flex; align-items: center; justify-content: center; font-size: .95rem; }
        .sec-title { font-size: .95rem; font-weight: 700; color: var(--text-primary); }

        /* Filter bar */
        .filter-bar { background: #f8fafc; padding: 12px 22px; border-bottom: 1px solid var(--border); display: flex; align-items: center; justify-content: space-between; gap: 12px; flex-wrap: wrap; }
        .filter-tabs { display: flex; align-items: center; gap: 6px; }
        .btn-filter { padding: 6px 14px; border-radius: 8px; border: none; cursor: pointer; font-family: 'Inter', sans-serif; font-size: .8rem; font-weight: 600; display: inline-flex; align-items: center; gap: 5px; text-decoration: none; transition: all .15s; }
        .btn-filter.cyan  { background: var(--task-col); color: #fff; }
        .btn-filter.ghost { background: var(--border); color: var(--text-muted); }
        .btn-filter.active-tab { background: var(--accent); color: #fff; }

        /* Data Table */
        .data-table { width: 100%; border-collapse: collapse; }
        .data-table thead th { padding: 11px 16px; text-align: left; font-size: .7rem; font-weight: 700; text-transform: uppercase; letter-spacing: .5px; color: var(--text-muted); background: #f8fafc; border-bottom: 1px solid var(--border); }
        .data-table tbody td { padding: 14px 16px; font-size: .84rem; color: var(--text-primary); border-bottom: 1px solid #f1f5f9; vertical-align: top; }
        .data-table tbody tr:hover td { background: #f0fdf4; }

        .week-pill { background: #ecfeff; color: #0891b2; font-weight: 700; font-size: .73rem; padding: 3px 8px; border-radius: 6px; display: inline-block; margin-bottom: 4px; }
        .report-title-text { font-weight: 600; font-size: .86rem; color: var(--text-primary); }
        .content-snippet { font-size: .78rem; color: #475569; margin-top: 4px; line-height: 1.4; max-height: 60px; overflow: hidden; text-overflow: ellipsis; display: -webkit-box; -webkit-line-clamp: 3; -webkit-box-orient: vertical; }

        .feedback-snippet { background: #f0fdf4; border: 1px solid #bbf7d0; border-radius: 8px; padding: 8px 12px; font-size: .78rem; color: #15803d; line-height: 1.4; margin-top: 4px; }

        .badge { display: inline-flex; align-items: center; gap: 4px; padding: 4px 10px; border-radius: 20px; font-size: .7rem; font-weight: 600; white-space: nowrap; }
        .badge-submitted { background: #fefce8; color: #a16207; }
        .badge-reviewed  { background: #f0fdf4; color: #15803d; }

        .btn-reply { padding: 6px 14px; border-radius: 8px; border: none; cursor: pointer; font-family: 'Inter', sans-serif; font-size: .78rem; font-weight: 600; background: linear-gradient(135deg, #10b981, #059669); color: #fff; display: inline-flex; align-items: center; gap: 5px; text-decoration: none; box-shadow: 0 2px 6px rgba(16,185,129,.25); transition: opacity .15s; }
        .btn-reply:hover { opacity: .9; }

        /* Modal */
        .modal-overlay { display: none; position: fixed; inset: 0; background: rgba(0,0,0,.5); z-index: 200; align-items: center; justify-content: center; backdrop-filter: blur(3px); }
        .modal-overlay.open { display: flex; }
        .modal-box { background: #fff; border-radius: 18px; width: 620px; max-width: 95vw; box-shadow: 0 20px 60px rgba(0,0,0,.25); overflow: hidden; animation: slideUp .25s ease; }
        @keyframes slideUp { from { transform: translateY(30px); opacity: 0; } to { transform: translateY(0); opacity: 1; } }
        .modal-header { padding: 20px 24px; background: linear-gradient(135deg, #10b981, #34d399); display: flex; align-items: center; justify-content: space-between; }
        .modal-header h3 { color: #fff; font-size: 1rem; font-weight: 700; display: flex; align-items: center; gap: 8px; }
        .modal-close { background: none; border: none; color: rgba(255,255,255,.8); font-size: 1.3rem; cursor: pointer; }
        .modal-close:hover { color: #fff; }
        .modal-body { padding: 24px; max-height: 75vh; overflow-y: auto; }
        .modal-footer { padding: 16px 24px; background: #f8fafc; display: flex; justify-content: flex-end; gap: 10px; border-top: 1px solid var(--border); }
        .form-group { display: flex; flex-direction: column; gap: 6px; margin-bottom: 16px; }
        .form-label { font-size: .75rem; font-weight: 700; color: var(--text-muted); text-transform: uppercase; letter-spacing: .4px; }
        .form-textarea { padding: 10px 12px; border: 1.5px solid var(--border); border-radius: 9px; font-family: 'Inter', sans-serif; font-size: .85rem; color: var(--text-primary); background: #fff; outline: none; transition: border-color .2s; resize: vertical; min-height: 120px; }
        .form-textarea:focus { border-color: var(--accent); box-shadow: 0 0 0 3px rgba(16,185,129,.1); }

        .btn-submit { padding: 9px 24px; border-radius: 9px; border: none; cursor: pointer; font-family: 'Inter', sans-serif; font-size: .85rem; font-weight: 600; background: linear-gradient(135deg, #10b981, #059669); color: #fff; box-shadow: 0 2px 10px rgba(16,185,129,.3); transition: opacity .15s; }
        .btn-submit:hover { opacity: .9; }
        .btn-cancel { padding: 9px 20px; border-radius: 9px; border: 1.5px solid var(--border); cursor: pointer; font-family: 'Inter', sans-serif; font-size: .85rem; font-weight: 600; background: #fff; color: var(--text-muted); }

        .preview-report-box { background: #f8fafc; border-radius: 10px; padding: 14px 16px; border: 1px solid var(--border); margin-bottom: 16px; }
        .preview-label { font-size: .72rem; font-weight: 700; color: var(--text-muted); text-transform: uppercase; margin-bottom: 6px; }
        .preview-text { font-size: .85rem; color: #334155; line-height: 1.5; white-space: pre-wrap; }

        .empty-state { padding: 48px; text-align: center; color: var(--text-muted); }
        .empty-state i { font-size: 2.2rem; margin-bottom: 8px; display: block; opacity: .4; }
    </style>
</head>
<body>

<%-- Sidebar --%>
<aside class="sidebar">
    <div class="sidebar-brand">
        <div class="brand-icon"><i class="bi bi-mortarboard-fill"></i></div>
        <h1>Cổng thông tin<br>Mentor</h1>
        <span>Quản lý Thực tập</span>
    </div>
    <div class="sidebar-section-label">Tổng quan</div>
    <ul class="sidebar-nav">
        <li><a href="${pageContext.request.contextPath}/mentor/dashboard">
            <i class="bi bi-grid"></i> Bảng điều khiển
        </a></li>
    </ul>
    <div class="sidebar-section-label">Nhiệm vụ &amp; Đánh giá</div>
    <ul class="sidebar-nav">
        <li><a href="${pageContext.request.contextPath}/mentor/dashboard/task/edit">
            <i class="bi bi-pencil-square"></i> Cập nhật nhiệm vụ
        </a></li>
        <li><a href="${pageContext.request.contextPath}/mentor/reports" class="active">
            <i class="bi bi-journal-text"></i> Báo cáo tuần TTS
        </a></li>
        <li><a href="${pageContext.request.contextPath}/mentor/evaluations">
            <i class="bi bi-star-fill"></i> Đánh giá thực tập sinh
        </a></li>
    </ul>
    <div class="sidebar-footer">
        <div class="sidebar-user">
            <div class="avatar">${fn:substring(sessionScope.currentUser.fullName, 0, 1)}</div>
            <div class="sidebar-user-info">
                <div class="sidebar-user-name">${sessionScope.currentUser.fullName}</div>
                <div class="sidebar-user-role">Mentor</div>
            </div>
            <a href="${pageContext.request.contextPath}/logout" class="logout-btn" title="Đăng xuất">
                <i class="bi bi-box-arrow-right"></i>
            </a>
        </div>
    </div>
</aside>

<%-- Main --%>
<div class="main">
    <div class="topbar">
        <div>
            <div class="page-title">Báo cáo tuần của Thực tập sinh</div>
            <div class="page-sub">Xem xét kết quả thực tập định kỳ và gửi phản hồi, hướng dẫn hỗ trợ thực tập sinh</div>
        </div>
        <div>
            <a href="${pageContext.request.contextPath}/mentor/dashboard" class="btn-filter ghost">
                <i class="bi bi-arrow-left"></i> Bảng điều khiển
            </a>
        </div>
    </div>

    <div class="content">

        <%-- Alerts --%>
        <c:if test="${not empty param.success}">
            <div style="padding:12px 18px;background:#f0fdf4;border:1px solid #bbf7d0;border-radius:10px;margin-bottom:20px;color:#15803d;font-size:.85rem;font-weight:600;display:flex;align-items:center;gap:8px">
                <i class="bi bi-check-circle-fill"></i> ${param.success}
            </div>
        </c:if>
        <c:if test="${not empty param.error}">
            <div style="padding:12px 18px;background:#fef2f2;border:1px solid #fecaca;border-radius:10px;margin-bottom:20px;color:#b91c1c;font-size:.85rem;font-weight:600;display:flex;align-items:center;gap:8px">
                <i class="bi bi-exclamation-triangle-fill"></i> ${param.error}
            </div>
        </c:if>

        <%-- Stats --%>
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon si-all"><i class="bi bi-journal-bookmark-fill"></i></div>
                <div>
                    <div class="stat-num">${fn:length(allReports)}</div>
                    <div class="stat-lbl">Tổng báo cáo nhận được</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon si-amber"><i class="bi bi-hourglass-split"></i></div>
                <div>
                    <div class="stat-num">${pendingFeedbackCount}</div>
                    <div class="stat-lbl">Báo cáo chờ phản hồi</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon si-green"><i class="bi bi-chat-square-quote-fill"></i></div>
                <div>
                    <div class="stat-num">${reviewedCount}</div>
                    <div class="stat-lbl">Báo cáo đã gửi phản hồi</div>
                </div>
            </div>
        </div>

        <%-- Reports Table Card --%>
        <div class="sec-card">
            <div class="sec-header">
                <div class="sec-header-left">
                    <div class="sec-icon"><i class="bi bi-journal-text"></i></div>
                    <span class="sec-title">Danh sách Báo cáo tuần &amp; Phản hồi</span>
                </div>
            </div>

            <%-- Filter Bar --%>
            <div class="filter-bar">
                <div class="filter-tabs">
                    <a href="${pageContext.request.contextPath}/mentor/reports${not empty internIdFilter ? '?internId='.concat(internIdFilter) : ''}"
                       class="btn-filter ${empty statusFilter ? 'active-tab' : 'ghost'}">
                        Tất cả (${fn:length(allReports)})
                    </a>
                    <a href="${pageContext.request.contextPath}/mentor/reports?status=SUBMITTED${not empty internIdFilter ? '&internId='.concat(internIdFilter) : ''}"
                       class="btn-filter ${statusFilter == 'SUBMITTED' ? 'active-tab' : 'ghost'}">
                        <i class="bi bi-hourglass-split"></i> Chờ phản hồi (${pendingFeedbackCount})
                    </a>
                    <a href="${pageContext.request.contextPath}/mentor/reports?status=REVIEWED${not empty internIdFilter ? '&internId='.concat(internIdFilter) : ''}"
                       class="btn-filter ${statusFilter == 'REVIEWED' ? 'active-tab' : 'ghost'}">
                        <i class="bi bi-check2-circle"></i> Đã phản hồi (${reviewedCount})
                    </a>
                </div>

                <form method="get" action="${pageContext.request.contextPath}/mentor/reports" style="display:flex;align-items:center;gap:8px">
                    <c:if test="${not empty statusFilter}">
                        <input type="hidden" name="status" value="${statusFilter}">
                    </c:if>
                    <select name="internId" class="filter-select" style="padding:6px 12px;border:1.5px solid var(--border);border-radius:8px;font-size:.8rem" onchange="this.form.submit()">
                        <option value="">— Tất cả thực tập sinh —</option>
                        <c:forEach var="i" items="${allMyInterns}">
                            <option value="${i.id}" ${internIdFilter == i.id ? 'selected' : ''}>${i.fullName} (${i.studentCode})</option>
                        </c:forEach>
                    </select>
                </form>
            </div>

            <%-- Table --%>
            <table class="data-table">
                <thead><tr>
                    <th>Thực tập sinh</th>
                    <th>Nội dung báo cáo tuần</th>
                    <th>Ngày nộp</th>
                    <th>Trạng thái</th>
                    <th>Phản hồi của Mentor</th>
                    <th>Thao tác</th>
                </tr></thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty reports}">
                            <tr><td colspan="6"><div class="empty-state"><i class="bi bi-journal-x"></i>Không tìm thấy báo cáo tuần nào.</div></td></tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="r" items="${reports}">
                                <tr>
                                    <td style="min-width:160px">
                                        <div style="font-weight:700;font-size:.86rem">${not empty r.internName ? r.internName : '—'}</div>
                                        <div style="font-size:.74rem;color:var(--text-muted)">${r.studentCode}</div>
                                    </td>
                                    <td style="max-width:320px">
                                        <span class="week-pill">Tuần ${r.weekNumber}</span>
                                        <div class="report-title-text">${r.title}</div>
                                        <div class="content-snippet" title="${r.content}">${r.content}</div>
                                    </td>
                                    <td style="white-space:nowrap;font-size:.78rem;color:var(--text-muted)">
                                        <i class="bi bi-calendar3"></i> ${r.submittedAt}
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${r.status == 'REVIEWED'}">
                                                <span class="badge badge-reviewed"><i class="bi bi-check-circle-fill"></i> Đã phản hồi</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-submitted"><i class="bi bi-clock-history"></i> Chờ phản hồi</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td style="max-width:260px">
                                        <c:choose>
                                            <c:when test="${not empty r.feedback}">
                                                <div class="feedback-snippet" title="${r.feedback}">
                                                    <i class="bi bi-quote"></i> ${r.feedback}
                                                </div>
                                                <div style="font-size:.7rem;color:var(--text-muted);margin-top:2px">${r.reviewedAt}</div>
                                            </c:when>
                                            <c:otherwise>
                                                <span style="color:var(--text-muted);font-size:.78rem;font-style:italic">Chưa có phản hồi</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <button class="btn-reply" onclick="openFeedbackModal(${r.id}, '${fn:escapeXml(r.internName)}', ${r.weekNumber}, '${fn:escapeXml(r.title)}', '${fn:escapeXml(r.content)}', '${fn:escapeXml(r.feedback)}')">
                                            <i class="bi bi-chat-dots-fill"></i> ${not empty r.feedback ? 'Sửa phản hồi' : 'Phản hồi'}
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
</div>

<%-- Feedback Modal --%>
<div class="modal-overlay" id="feedbackModal">
    <div class="modal-box">
        <div class="modal-header">
            <h3><i class="bi bi-chat-quote-fill"></i> Gửi nhận xét &amp; Hỗ trợ Thực tập sinh</h3>
            <button class="modal-close" onclick="closeFeedbackModal()">&#x2715;</button>
        </div>
        <form method="post" action="${pageContext.request.contextPath}/mentor/reports/feedback">
            <input type="hidden" name="id" id="feedbackReportId">
            <div class="modal-body">
                <div class="preview-report-box">
                    <div class="preview-label" id="previewInternHeader">Nội dung báo cáo:</div>
                    <div style="font-weight:700;font-size:.88rem;color:var(--text-primary);margin-bottom:6px" id="previewReportTitle"></div>
                    <div class="preview-text" id="previewReportContent"></div>
                </div>
                <div class="form-group">
                    <label class="form-label">Nội dung phản hồi / Nhận xét của Mentor *</label>
                    <textarea name="feedback" id="feedbackInput" class="form-textarea" required rows="5" placeholder="Ghi nhận xét, đánh giá kết quả hoàn thành trong tuần, góp ý chuyên môn hoặc hướng dẫn giải quyết các vướng mắc của thực tập sinh..."></textarea>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn-cancel" onclick="closeFeedbackModal()">Đóng</button>
                <button type="submit" class="btn-submit"><i class="bi bi-send-fill"></i> Gửi phản hồi</button>
            </div>
        </form>
    </div>
</div>

<script>
    function openFeedbackModal(id, internName, week, title, content, feedback) {
        document.getElementById('feedbackReportId').value = id;
        document.getElementById('previewInternHeader').textContent = 'Báo cáo Tuần ' + week + ' của: ' + internName;
        document.getElementById('previewReportTitle').textContent = title;
        document.getElementById('previewReportContent').textContent = content;
        document.getElementById('feedbackInput').value = feedback || '';
        document.getElementById('feedbackModal').classList.add('open');
    }
    function closeFeedbackModal() { document.getElementById('feedbackModal').classList.remove('open'); }
    document.getElementById('feedbackModal').addEventListener('click', function(e) {
        if (e.target === this) closeFeedbackModal();
    });
</script>
</body>
</html>
