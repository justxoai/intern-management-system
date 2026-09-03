<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Báo cáo tuần — Cổng thông tin Thực tập sinh</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        :root {
            --sidebar-w: 250px;
            --sidebar-bg: #0c1f3f;
            --accent: #7c3aed;
            --accent2: #a78bfa;
            --page-bg: #f8fafc;
            --card-bg: #fff;
            --text-primary: #0f172a;
            --text-muted: #64748b;
            --border: #e2e8f0;
        }
        body { font-family: 'Inter', sans-serif; background: var(--page-bg); display: flex; min-height: 100vh; }

        /* Sidebar */
        .sidebar { width: var(--sidebar-w); background: var(--sidebar-bg); display: flex; flex-direction: column; flex-shrink: 0; position: fixed; height: 100vh; overflow-y: auto; z-index: 100; }
        .sidebar-brand { padding: 28px 22px 20px; border-bottom: 1px solid rgba(255,255,255,.08); }
        .brand-icon { width: 40px; height: 40px; border-radius: 10px; background: linear-gradient(135deg, #7c3aed, #a78bfa); display: flex; align-items: center; justify-content: center; font-size: 1.15rem; color: #fff; margin-bottom: 10px; }
        .sidebar-brand h1 { color: #fff; font-size: .95rem; font-weight: 700; line-height: 1.3; }
        .sidebar-brand span { color: rgba(255,255,255,.4); font-size: .72rem; }
        .sidebar-section-label { padding: 18px 22px 6px; font-size: .67rem; font-weight: 700; text-transform: uppercase; letter-spacing: .8px; color: rgba(255,255,255,.3); }
        .sidebar-nav { list-style: none; padding: 0 12px; }
        .sidebar-nav li a { display: flex; align-items: center; gap: 10px; padding: 10px 12px; border-radius: 8px; margin-bottom: 2px; text-decoration: none; color: rgba(255,255,255,.65); font-size: .84rem; font-weight: 500; transition: background .15s, color .15s; }
        .sidebar-nav li a:hover { background: rgba(255,255,255,.07); color: #fff; }
        .sidebar-nav li a.active { background: rgba(124,58,237,.25); color: #fff; border-left: 3px solid var(--accent); }
        .sidebar-nav li a i { font-size: 1rem; width: 20px; }
        .sidebar-footer { margin-top: auto; padding: 16px 22px; border-top: 1px solid rgba(255,255,255,.08); }
        .sidebar-user { display: flex; align-items: center; gap: 10px; }
        .avatar { width: 34px; height: 34px; border-radius: 50%; background: linear-gradient(135deg, #7c3aed, #a78bfa); display: flex; align-items: center; justify-content: center; font-size: .85rem; color: #fff; font-weight: 700; flex-shrink: 0; }
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

        /* Stats strip */
        .stats-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 16px; margin-bottom: 24px; }
        .stat-card { background: var(--card-bg); border-radius: 14px; padding: 18px 20px; border: 1px solid var(--border); display: flex; align-items: center; gap: 14px; box-shadow: 0 1px 4px rgba(0,0,0,.04); }
        .stat-icon { width: 44px; height: 44px; border-radius: 11px; display: flex; align-items: center; justify-content: center; font-size: 1.2rem; flex-shrink: 0; }
        .si-purple{ background: #f5f3ff; color: #7c3aed; }
        .si-amber { background: #fefce8; color: #d97706; }
        .si-green { background: #f0fdf4; color: #16a34a; }
        .stat-num { font-size: 1.6rem; font-weight: 800; color: var(--text-primary); line-height: 1; }
        .stat-lbl { font-size: .74rem; color: var(--text-muted); margin-top: 3px; font-weight: 500; }

        /* Buttons */
        .btn-primary { padding: 9px 18px; border-radius: 8px; border: none; cursor: pointer; font-family: 'Inter', sans-serif; font-size: .83rem; font-weight: 600; background: linear-gradient(135deg, #7c3aed, #6d28d9); color: #fff; display: inline-flex; align-items: center; gap: 6px; text-decoration: none; box-shadow: 0 2px 8px rgba(124,58,237,.3); transition: opacity .15s; }
        .btn-primary:hover { opacity: .9; }
        .btn-ghost { padding: 6px 12px; border-radius: 6px; border: 1px solid var(--border); background: #fff; color: var(--text-muted); font-size: .78rem; font-weight: 600; cursor: pointer; display: inline-flex; align-items: center; gap: 4px; text-decoration: none; transition: all .15s; }
        .btn-ghost:hover { border-color: var(--accent); color: var(--accent); }

        /* Report Cards List */
        .report-card { background: var(--card-bg); border-radius: 16px; border: 1px solid var(--border); margin-bottom: 20px; overflow: hidden; box-shadow: 0 1px 5px rgba(0,0,0,.04); }
        .report-header { padding: 16px 22px; border-bottom: 1px solid var(--border); display: flex; align-items: center; justify-content: space-between; background: #fafafa; }
        .report-title-box { display: flex; align-items: center; gap: 10px; }
        .week-pill { background: #ede9fe; color: #6d28d9; font-weight: 700; font-size: .75rem; padding: 4px 10px; border-radius: 6px; }
        .report-title { font-size: .95rem; font-weight: 700; color: var(--text-primary); }
        .badge { display: inline-flex; align-items: center; gap: 4px; padding: 4px 11px; border-radius: 20px; font-size: .72rem; font-weight: 600; }
        .badge-submitted { background: #fefce8; color: #a16207; }
        .badge-reviewed  { background: #f0fdf4; color: #15803d; }

        .report-body { padding: 22px; }
        .report-content-box { background: #f8fafc; border-radius: 10px; padding: 14px 16px; font-size: .86rem; color: #334155; line-height: 1.6; white-space: pre-wrap; margin-bottom: 16px; border: 1px solid #edf2f7; }

        /* Feedback Section */
        .feedback-box { border-radius: 12px; padding: 16px 18px; display: flex; flex-direction: column; gap: 8px; }
        .feedback-has { background: #f0fdf4; border: 1px solid #bbf7d0; }
        .feedback-none { background: #f8fafc; border: 1px dashed var(--border); color: var(--text-muted); text-align: center; padding: 20px; font-size: .83rem; }
        .feedback-header { display: flex; align-items: center; justify-content: space-between; font-size: .78rem; font-weight: 700; color: #166534; }
        .feedback-text { font-size: .85rem; color: #14532d; line-height: 1.5; white-space: pre-wrap; }

        .meta-line { display: flex; align-items: center; gap: 14px; font-size: .75rem; color: var(--text-muted); margin-top: 14px; padding-top: 12px; border-top: 1px solid var(--border); }

        /* Modal */
        .modal-overlay { display: none; position: fixed; inset: 0; background: rgba(0,0,0,.5); z-index: 200; align-items: center; justify-content: center; backdrop-filter: blur(3px); }
        .modal-overlay.open { display: flex; }
        .modal-box { background: #fff; border-radius: 18px; width: 600px; max-width: 95vw; box-shadow: 0 20px 60px rgba(0,0,0,.25); overflow: hidden; animation: slideUp .25s ease; }
        @keyframes slideUp { from { transform: translateY(30px); opacity: 0; } to { transform: translateY(0); opacity: 1; } }
        .modal-header { padding: 20px 24px; background: linear-gradient(135deg, #7c3aed, #a78bfa); display: flex; align-items: center; justify-content: space-between; }
        .modal-header h3 { color: #fff; font-size: 1rem; font-weight: 700; display: flex; align-items: center; gap: 8px; }
        .modal-close { background: none; border: none; color: rgba(255,255,255,.8); font-size: 1.3rem; cursor: pointer; }
        .modal-close:hover { color: #fff; }
        .modal-body { padding: 24px; }
        .modal-footer { padding: 16px 24px; background: #f8fafc; display: flex; justify-content: flex-end; gap: 10px; border-top: 1px solid var(--border); }
        .form-group { display: flex; flex-direction: column; gap: 6px; margin-bottom: 16px; }
        .form-label { font-size: .75rem; font-weight: 700; color: var(--text-muted); text-transform: uppercase; letter-spacing: .4px; }
        .form-input, .form-select, .form-textarea { padding: 9px 12px; border: 1.5px solid var(--border); border-radius: 9px; font-family: 'Inter', sans-serif; font-size: .85rem; color: var(--text-primary); background: #fff; outline: none; transition: border-color .2s; }
        .form-input:focus, .form-select:focus, .form-textarea:focus { border-color: var(--accent); box-shadow: 0 0 0 3px rgba(124,58,237,.1); }
        .form-textarea { resize: vertical; min-height: 120px; }

        .btn-submit { padding: 9px 24px; border-radius: 9px; border: none; cursor: pointer; font-family: 'Inter', sans-serif; font-size: .85rem; font-weight: 600; background: linear-gradient(135deg, #7c3aed, #6d28d9); color: #fff; box-shadow: 0 2px 10px rgba(124,58,237,.3); transition: opacity .15s; }
        .btn-submit:hover { opacity: .9; }
        .btn-cancel { padding: 9px 20px; border-radius: 9px; border: 1.5px solid var(--border); cursor: pointer; font-family: 'Inter', sans-serif; font-size: .85rem; font-weight: 600; background: #fff; color: var(--text-muted); }

        .empty-box { text-align: center; padding: 60px 20px; background: #fff; border-radius: 16px; border: 1px solid var(--border); color: var(--text-muted); }
        .empty-box i { font-size: 2.6rem; color: #cbd5e1; display: block; margin-bottom: 12px; }
    </style>
</head>
<body>

<%-- Sidebar --%>
<aside class="sidebar">
    <div class="sidebar-brand">
        <div class="brand-icon"><i class="bi bi-person-workspace"></i></div>
        <h1>Cổng thông tin<br>Thực tập sinh</h1>
        <span>Không gian làm việc</span>
    </div>
    <div class="sidebar-section-label">Không gian của tôi</div>
    <ul class="sidebar-nav">
        <li><a href="${pageContext.request.contextPath}/intern/documents">
            <i class="bi bi-folder2-open"></i> Tài liệu của tôi
        </a></li>
        <li><a href="${pageContext.request.contextPath}/intern/contracts">
            <i class="bi bi-file-earmark-check"></i> Hợp đồng của tôi
        </a></li>
        <li><a href="${pageContext.request.contextPath}/intern/tasks">
            <i class="bi bi-list-task"></i> Nhiệm vụ của tôi
        </a></li>
        <li><a href="${pageContext.request.contextPath}/intern/reports" class="active">
            <i class="bi bi-journal-text"></i> Báo cáo tuần
        </a></li>
    </ul>
    <div class="sidebar-footer">
        <div class="sidebar-user">
            <div class="avatar">${fn:substring(sessionScope.currentUser.fullName, 0, 1)}</div>
            <div class="sidebar-user-info">
                <div class="sidebar-user-name">${sessionScope.currentUser.fullName}</div>
                <div class="sidebar-user-role">Thực tập sinh</div>
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
            <div class="page-title">Báo cáo tuần của tôi</div>
            <div class="page-sub">Nộp báo cáo định kỳ kết quả thực tập và theo dõi phản hồi hỗ trợ từ Mentor</div>
        </div>
        <div>
            <button class="btn-primary" onclick="openCreateModal()">
                <i class="bi bi-plus-lg"></i> Nộp báo cáo tuần mới
            </button>
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
                <div class="stat-icon si-purple"><i class="bi bi-journal-check"></i></div>
                <div>
                    <div class="stat-num">${fn:length(reports)}</div>
                    <div class="stat-lbl">Tổng báo cáo đã nộp</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon si-amber"><i class="bi bi-hourglass-split"></i></div>
                <div>
                    <div class="stat-num">${submittedCount}</div>
                    <div class="stat-lbl">Đang chờ Mentor phản hồi</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon si-green"><i class="bi bi-chat-heart-fill"></i></div>
                <div>
                    <div class="stat-num">${reviewedCount}</div>
                    <div class="stat-lbl">Đã được phản hồi &amp; hỗ trợ</div>
                </div>
            </div>
        </div>

        <%-- List of Weekly Reports --%>
        <c:choose>
            <c:when test="${empty reports}">
                <div class="empty-box">
                    <i class="bi bi-journal-x"></i>
                    <div style="font-weight:700;font-size:1rem;margin-bottom:6px">Chưa có báo cáo tuần nào</div>
                    <div style="font-size:.84rem;max-width:400px;margin:0 auto 16px">Hãy nộp báo cáo tuần đầu tiên để tóm tắt các công việc đã thực hiện và nhận phản hồi hướng dẫn từ Mentor.</div>
                    <button class="btn-primary" onclick="openCreateModal()"><i class="bi bi-plus-lg"></i> Nộp báo cáo tuần đầu tiên</button>
                </div>
            </c:when>
            <c:otherwise>
                <c:forEach var="r" items="${reports}">
                    <div class="report-card">
                        <div class="report-header">
                            <div class="report-title-box">
                                <span class="week-pill">Tuần ${r.weekNumber}</span>
                                <span class="report-title">${r.title}</span>
                            </div>
                            <div style="display:flex;align-items:center;gap:10px">
                                <c:choose>
                                    <c:when test="${r.status == 'REVIEWED'}">
                                        <span class="badge badge-reviewed"><i class="bi bi-check-circle-fill"></i> Đã phản hồi</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-submitted"><i class="bi bi-clock-history"></i> Chờ phản hồi</span>
                                    </c:otherwise>
                                </c:choose>
                                <c:if test="${r.status == 'SUBMITTED'}">
                                    <button class="btn-ghost" onclick="openEditModal(${r.id}, ${r.weekNumber}, '${fn:escapeXml(r.title)}', '${fn:escapeXml(r.content)}')">
                                        <i class="bi bi-pencil"></i> Sửa
                                    </button>
                                </c:if>
                            </div>
                        </div>
                        <div class="report-body">
                            <div style="font-size:.75rem;font-weight:700;color:var(--text-muted);text-transform:uppercase;letter-spacing:.4px;margin-bottom:6px">
                                <i class="bi bi-file-text"></i> Nội dung báo cáo kết quả thực tập:
                            </div>
                            <div class="report-content-box">${r.content}</div>

                            <%-- Mentor Feedback Box --%>
                            <c:choose>
                                <c:when test="${r.status == 'REVIEWED' && not empty r.feedback}">
                                    <div class="feedback-box feedback-has">
                                        <div class="feedback-header">
                                            <span><i class="bi bi-chat-quote-fill"></i> Phản hồi &amp; Hướng dẫn từ Mentor (${not empty r.mentorName ? r.mentorName : 'Người hướng dẫn'})</span>
                                            <c:if test="${not empty r.reviewedAt}">
                                                <span style="font-size:.7rem;font-weight:500;color:#15803d">${r.reviewedAt}</span>
                                            </c:if>
                                        </div>
                                        <div class="feedback-text">${r.feedback}</div>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="feedback-box feedback-none">
                                        <i class="bi bi-hourglass-split" style="font-size:1.2rem;display:inline-block;margin-bottom:4px"></i>
                                        <div>Mentor đang xem xét báo cáo này và sẽ gửi nhận xét, phản hồi sớm cho bạn.</div>
                                    </div>
                                </c:otherwise>
                            </c:choose>

                            <div class="meta-line">
                                <span><i class="bi bi-calendar3"></i> Ngày nộp: ${r.submittedAt}</span>
                                <c:if test="${not empty r.mentorName}">
                                    <span><i class="bi bi-person-badge"></i> Mentor: ${r.mentorName}</span>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>

    </div>
</div>

<%-- Modal Create Report --%>
<div class="modal-overlay" id="createReportModal">
    <div class="modal-box">
        <div class="modal-header">
            <h3><i class="bi bi-journal-plus"></i> Nộp báo cáo tuần mới</h3>
            <button class="modal-close" onclick="closeCreateModal()">&#x2715;</button>
        </div>
        <form method="post" action="${pageContext.request.contextPath}/intern/reports/create">
            <input type="hidden" name="mentorId" value="${assignedMentorId}">
            <div class="modal-body">
                <div class="form-group">
                    <label class="form-label">Tuần thực tập số *</label>
                    <input type="number" name="weekNumber" min="1" max="52" value="${nextWeekNumber}" class="form-input" required style="width:120px">
                </div>
                <div class="form-group">
                    <label class="form-label">Tiêu đề báo cáo *</label>
                    <input type="text" name="title" class="form-input" required placeholder="VD: Báo cáo kết quả nghiên cứu Servlet và JDBC">
                </div>
                <div class="form-group">
                    <label class="form-label">Nội dung báo cáo chi tiết *</label>
                    <textarea name="content" class="form-textarea" required rows="6" placeholder="Tóm tắt công việc đã làm trong tuần, các kết quả đạt được, khó khăn vướng mắc gặp phải và dự kiến kế hoạch cho tuần tiếp theo..."></textarea>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn-cancel" onclick="closeCreateModal()">Hủy</button>
                <button type="submit" class="btn-submit"><i class="bi bi-send-fill"></i> Nộp báo cáo</button>
            </div>
        </form>
    </div>
</div>

<%-- Modal Edit Report --%>
<div class="modal-overlay" id="editReportModal">
    <div class="modal-box">
        <div class="modal-header">
            <h3><i class="bi bi-pencil-square"></i> Chỉnh sửa báo cáo tuần</h3>
            <button class="modal-close" onclick="closeEditModal()">&#x2715;</button>
        </div>
        <form method="post" action="${pageContext.request.contextPath}/intern/reports/edit">
            <input type="hidden" name="id" id="editReportId">
            <div class="modal-body">
                <div class="form-group">
                    <label class="form-label">Tiêu đề báo cáo *</label>
                    <input type="text" name="title" id="editReportTitle" class="form-input" required>
                </div>
                <div class="form-group">
                    <label class="form-label">Nội dung báo cáo *</label>
                    <textarea name="content" id="editReportContent" class="form-textarea" required rows="6"></textarea>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn-cancel" onclick="closeEditModal()">Hủy</button>
                <button type="submit" class="btn-submit"><i class="bi bi-check-lg"></i> Cập nhật</button>
            </div>
        </form>
    </div>
</div>

<script>
    function openCreateModal() { document.getElementById('createReportModal').classList.add('open'); }
    function closeCreateModal() { document.getElementById('createReportModal').classList.remove('open'); }
    document.getElementById('createReportModal').addEventListener('click', function(e) {
        if (e.target === this) closeCreateModal();
    });

    function openEditModal(id, week, title, content) {
        document.getElementById('editReportId').value = id;
        document.getElementById('editReportTitle').value = title;
        document.getElementById('editReportContent').value = content;
        document.getElementById('editReportModal').classList.add('open');
    }
    function closeEditModal() { document.getElementById('editReportModal').classList.remove('open'); }
    document.getElementById('editReportModal').addEventListener('click', function(e) {
        if (e.target === this) closeEditModal();
    });
</script>
</body>
</html>
