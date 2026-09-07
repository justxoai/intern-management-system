<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Đánh giá Thực tập sinh — Cổng thông tin Mentor</title>
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
        .stats-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 16px; margin-bottom: 24px; }
        .stat-card { background: var(--card-bg); border-radius: 14px; padding: 18px 20px; border: 1px solid var(--border); display: flex; align-items: center; gap: 14px; box-shadow: 0 1px 4px rgba(0,0,0,.04); }
        .stat-icon { width: 44px; height: 44px; border-radius: 11px; display: flex; align-items: center; justify-content: center; font-size: 1.2rem; flex-shrink: 0; }
        .si-blue  { background: #eff6ff; color: #0284c7; }
        .si-green { background: #f0fdf4; color: #16a34a; }
        .si-amber { background: #fefce8; color: #d97706; }
        .si-purple{ background: #f5f3ff; color: #7c3aed; }
        .stat-num { font-size: 1.6rem; font-weight: 800; color: var(--text-primary); line-height: 1; }
        .stat-lbl { font-size: .74rem; color: var(--text-muted); margin-top: 3px; font-weight: 500; }

        /* Section Card */
        .sec-card { background: var(--card-bg); border-radius: 16px; border: 1px solid var(--border); margin-bottom: 24px; overflow: hidden; box-shadow: 0 1px 6px rgba(0,0,0,.05); }
        .sec-header { padding: 16px 22px; display: flex; align-items: center; justify-content: space-between; border-bottom: 1px solid var(--border); }
        .sec-header-left { display: flex; align-items: center; gap: 10px; }
        .sec-icon { width: 36px; height: 36px; border-radius: 9px; background: #fefce8; color: #ca8a04; display: flex; align-items: center; justify-content: center; font-size: .95rem; }
        .sec-title { font-size: .95rem; font-weight: 700; color: var(--text-primary); }

        /* Table */
        .data-table { width: 100%; border-collapse: collapse; }
        .data-table thead th { padding: 12px 16px; text-align: left; font-size: .7rem; font-weight: 700; text-transform: uppercase; letter-spacing: .5px; color: var(--text-muted); background: #f8fafc; border-bottom: 1px solid var(--border); }
        .data-table tbody td { padding: 14px 16px; font-size: .84rem; color: var(--text-primary); border-bottom: 1px solid #f1f5f9; vertical-align: middle; }
        .data-table tbody tr:hover td { background: #f0fdf4; }

        .intern-name-cell { font-weight: 700; font-size: .87rem; color: var(--text-primary); }
        .intern-sub-cell { font-size: .74rem; color: var(--text-muted); margin-top: 2px; }

        .score-pill { display: inline-flex; align-items: center; justify-content: center; width: 38px; height: 26px; border-radius: 6px; font-weight: 700; font-size: .82rem; }
        .sp-tech { background: #eff6ff; color: #0284c7; }
        .sp-att  { background: #f0fdf4; color: #16a34a; }
        .sp-comm { background: #faf5ff; color: #9333ea; }
        .sp-over { background: linear-gradient(135deg, #10b981, #059669); color: #fff; font-size: .88rem; width: 44px; height: 28px; }

        .badge { display: inline-flex; align-items: center; gap: 4px; padding: 4px 10px; border-radius: 20px; font-size: .7rem; font-weight: 700; }
        .badge-excellent { background: #f0fdf4; color: #15803d; border: 1px solid #bbf7d0; }
        .badge-good      { background: #eff6ff; color: #0369a1; border: 1px solid #bae6fd; }
        .badge-average   { background: #fefce8; color: #a16207; border: 1px solid #fde68a; }
        .badge-bad       { background: #fef2f2; color: #b91c1c; border: 1px solid #fecaca; }
        .badge-na        { background: #f1f5f9; color: #64748b; }

        .btn-eval { padding: 6px 14px; border-radius: 8px; border: none; cursor: pointer; font-family: 'Inter', sans-serif; font-size: .78rem; font-weight: 600; background: linear-gradient(135deg, #10b981, #059669); color: #fff; display: inline-flex; align-items: center; gap: 5px; text-decoration: none; box-shadow: 0 2px 6px rgba(16,185,129,.25); transition: opacity .15s; }
        .btn-eval:hover { opacity: .9; }

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
        .form-row { display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 12px; margin-bottom: 16px; }
        .form-group { display: flex; flex-direction: column; gap: 6px; margin-bottom: 16px; }
        .form-label { font-size: .75rem; font-weight: 700; color: var(--text-muted); text-transform: uppercase; letter-spacing: .4px; }
        .form-input, .form-select, .form-textarea { padding: 9px 12px; border: 1.5px solid var(--border); border-radius: 9px; font-family: 'Inter', sans-serif; font-size: .85rem; color: var(--text-primary); background: #fff; outline: none; transition: border-color .2s; }
        .form-input:focus, .form-select:focus, .form-textarea:focus { border-color: var(--accent); box-shadow: 0 0 0 3px rgba(16,185,129,.1); }
        .form-textarea { resize: vertical; min-height: 100px; }

        .live-score-box { background: #f0fdf4; border: 1.5px solid #bbf7d0; border-radius: 12px; padding: 14px 18px; display: flex; align-items: center; justify-content: space-between; margin-bottom: 16px; }
        .live-score-title { font-size: .84rem; font-weight: 700; color: #166534; }
        .live-score-val { font-size: 1.5rem; font-weight: 800; color: #15803d; }
        .live-score-grade { font-size: .8rem; font-weight: 700; padding: 3px 10px; border-radius: 20px; background: #dcfce7; color: #166534; margin-left: 8px; }

        .btn-submit { padding: 9px 24px; border-radius: 9px; border: none; cursor: pointer; font-family: 'Inter', sans-serif; font-size: .85rem; font-weight: 600; background: linear-gradient(135deg, #10b981, #059669); color: #fff; box-shadow: 0 2px 10px rgba(16,185,129,.3); transition: opacity .15s; }
        .btn-submit:hover { opacity: .9; }
        .btn-cancel { padding: 9px 20px; border-radius: 9px; border: 1.5px solid var(--border); cursor: pointer; font-family: 'Inter', sans-serif; font-size: .85rem; font-weight: 600; background: #fff; color: var(--text-muted); }
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
        <li><a href="${pageContext.request.contextPath}/mentor/reports">
            <i class="bi bi-journal-text"></i> Báo cáo tuần TTS
        </a></li>
        <li><a href="${pageContext.request.contextPath}/mentor/evaluations" class="active">
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
            <div class="page-title">Đánh giá Thực tập sinh Cuối kỳ</div>
            <div class="page-sub">Đánh giá năng lực chuyên môn, kỹ năng và thái độ làm việc để tổng kết kỳ thực tập</div>
        </div>
        <div>
            <a href="${pageContext.request.contextPath}/mentor/dashboard" class="btn-eval" style="background:#fff;color:var(--text-muted);border:1.5px solid var(--border);box-shadow:none">
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
                <div class="stat-icon si-blue"><i class="bi bi-people-fill"></i></div>
                <div>
                    <div class="stat-num">${totalInterns}</div>
                    <div class="stat-lbl">Thực tập sinh phụ trách</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon si-green"><i class="bi bi-patch-check-fill"></i></div>
                <div>
                    <div class="stat-num">${evaluatedCount}</div>
                    <div class="stat-lbl">Đã hoàn thành đánh giá</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon si-amber"><i class="bi bi-hourglass-top"></i></div>
                <div>
                    <div class="stat-num">${unEvaluatedCount}</div>
                    <div class="stat-lbl">Chưa có đánh giá</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon si-purple"><i class="bi bi-trophy-fill"></i></div>
                <div>
                    <div class="stat-num">${avgScore}</div>
                    <div class="stat-lbl">Điểm tổng kết TB</div>
                </div>
            </div>
        </div>

        <%-- Evaluations Table Card --%>
        <div class="sec-card">
            <div class="sec-header">
                <div class="sec-header-left">
                    <div class="sec-icon"><i class="bi bi-star-half"></i></div>
                    <span class="sec-title">Danh sách Đánh giá Kỹ năng &amp; Thái độ</span>
                </div>
            </div>

            <table class="data-table">
                <thead><tr>
                    <th>Thực tập sinh</th>
                    <th>Trường / Ngành</th>
                    <th style="text-align:center">Kỹ thuật (10)</th>
                    <th style="text-align:center">Thái độ (10)</th>
                    <th style="text-align:center">Giao tiếp (10)</th>
                    <th style="text-align:center">Tổng kết</th>
                    <th>Xếp loại</th>
                    <th>Nhận xét &amp; Góp ý</th>
                    <th>Thao tác</th>
                </tr></thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty allMyInterns}">
                            <tr><td colspan="9" style="text-align:center;padding:40px;color:var(--text-muted)">Bạn chưa được phân công hướng dẫn thực tập sinh nào.</td></tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="i" items="${allMyInterns}">
                                <c:set var="ev" value="${evalMap[i.id]}"/>
                                <tr>
                                    <td>
                                        <div class="intern-name-cell">${i.fullName}</div>
                                        <div class="intern-sub-cell">${i.studentCode}</div>
                                    </td>
                                    <td>
                                        <div style="font-size:.82rem">${i.university}</div>
                                        <div class="intern-sub-cell">${i.major}</div>
                                    </td>
                                    <td style="text-align:center">
                                        <c:choose>
                                            <c:when test="${not empty ev && not empty ev.technicalScore}">
                                                <span class="score-pill sp-tech">${ev.technicalScore}</span>
                                            </c:when>
                                            <c:otherwise><span style="color:var(--text-muted)">—</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td style="text-align:center">
                                        <c:choose>
                                            <c:when test="${not empty ev && not empty ev.attitudeScore}">
                                                <span class="score-pill sp-att">${ev.attitudeScore}</span>
                                            </c:when>
                                            <c:otherwise><span style="color:var(--text-muted)">—</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td style="text-align:center">
                                        <c:choose>
                                            <c:when test="${not empty ev && not empty ev.communicationScore}">
                                                <span class="score-pill sp-comm">${ev.communicationScore}</span>
                                            </c:when>
                                            <c:otherwise><span style="color:var(--text-muted)">—</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td style="text-align:center">
                                        <c:choose>
                                            <c:when test="${not empty ev && not empty ev.overallScore}">
                                                <span class="score-pill sp-over">${ev.overallScore}</span>
                                            </c:when>
                                            <c:otherwise><span style="color:var(--text-muted)">—</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty ev && not empty ev.overallScore}">
                                                <c:choose>
                                                    <c:when test="${ev.overallScore >= 9.0}"><span class="badge badge-excellent"><i class="bi bi-award-fill"></i> Xuất sắc</span></c:when>
                                                    <c:when test="${ev.overallScore >= 8.0}"><span class="badge badge-good"><i class="bi bi-check-circle-fill"></i> Giỏi</span></c:when>
                                                    <c:when test="${ev.overallScore >= 6.5}"><span class="badge badge-good"><i class="bi bi-check"></i> Khá</span></c:when>
                                                    <c:when test="${ev.overallScore >= 5.0}"><span class="badge badge-average">Trung bình</span></c:when>
                                                    <c:otherwise><span class="badge badge-bad">Chưa đạt</span></c:otherwise>
                                                </c:choose>
                                            </c:when>
                                            <c:otherwise><span class="badge badge-na">Chưa đánh giá</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td style="max-width:240px">
                                        <c:choose>
                                            <c:when test="${not empty ev && not empty ev.comments}">
                                                <div style="font-size:.78rem;color:#334155;line-height:1.4" title="${ev.comments}">${ev.comments}</div>
                                            </c:when>
                                            <c:otherwise><span style="color:var(--text-muted);font-size:.76rem;font-style:italic">Chưa có nhận xét</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <button class="btn-eval" onclick="openEvalModal(${i.id}, '${fn:escapeXml(i.fullName)}', '${fn:escapeXml(i.studentCode)}', '${not empty ev ? ev.technicalScore : ''}', '${not empty ev ? ev.attitudeScore : ''}', '${not empty ev ? ev.communicationScore : ''}', '${not empty ev ? ev.overallScore : ''}', '${fn:escapeXml(not empty ev ? ev.comments : '')}')">
                                            <i class="bi bi-pencil-square"></i> ${not empty ev ? 'Sửa đánh giá' : 'Đánh giá'}
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

<%-- Evaluation Modal --%>
<div class="modal-overlay" id="evalModal">
    <div class="modal-box">
        <div class="modal-header">
            <h3><i class="bi bi-star-fill"></i> Đánh giá Năng lực &amp; Thái độ Thực tập sinh</h3>
            <button class="modal-close" onclick="closeEvalModal()">&#x2715;</button>
        </div>
        <form method="post" action="${pageContext.request.contextPath}/mentor/evaluations/save">
            <input type="hidden" name="internId" id="modalInternId">
            <div class="modal-body">
                <div style="background:#f8fafc;padding:12px 16px;border-radius:10px;border:1px solid var(--border);margin-bottom:16px">
                    <span style="font-size:.72rem;font-weight:700;color:var(--text-muted);text-transform:uppercase">Thực tập sinh:</span>
                    <div style="font-weight:700;font-size:.95rem;color:var(--text-primary)" id="modalInternName"></div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label">Kỹ thuật (0 - 10) *</label>
                        <input type="number" step="0.1" min="0" max="10" name="technicalScore" id="mTech" class="form-input" required placeholder="VD: 8.5" oninput="calcLiveScore()">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Thái độ (0 - 10) *</label>
                        <input type="number" step="0.1" min="0" max="10" name="attitudeScore" id="mAtt" class="form-input" required placeholder="VD: 9.0" oninput="calcLiveScore()">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Giao tiếp (0 - 10) *</label>
                        <input type="number" step="0.1" min="0" max="10" name="communicationScore" id="mComm" class="form-input" required placeholder="VD: 8.0" oninput="calcLiveScore()">
                    </div>
                </div>

                <div class="live-score-box">
                    <div>
                        <div class="live-score-title"><i class="bi bi-calculator"></i> Điểm Tổng kết (tự động tính):</div>
                        <div style="font-size:.72rem;color:#166534">TB cộng = (Kỹ thuật + Thái độ + Giao tiếp) / 3</div>
                    </div>
                    <div style="display:flex;align-items:center">
                        <span class="live-score-val" id="liveScoreText">0.0</span>
                        <span class="live-score-grade" id="liveGradeText">Chưa xếp loại</span>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label">Điểm tổng kết cuối cùng (có thể tùy chỉnh nếu cần)</label>
                    <input type="number" step="0.1" min="0" max="10" name="overallScore" id="mOverall" class="form-input" placeholder="Tự động tính từ 3 điểm trên">
                </div>

                <div class="form-group">
                    <label class="form-label">Nhận xét chi tiết của Mentor *</label>
                    <textarea name="comments" id="mComments" class="form-textarea" required rows="4" placeholder="Nhận xét cụ thể về: tinh thần trách nhiệm, mức độ hoàn thành công việc, khả năng tiếp thu công nghệ, điểm mạnh và điểm cần hoàn thiện thêm..."></textarea>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn-cancel" onclick="closeEvalModal()">Hủy</button>
                <button type="submit" class="btn-submit"><i class="bi bi-check-lg"></i> Lưu đánh giá</button>
            </div>
        </form>
    </div>
</div>

<script>
    function openEvalModal(internId, name, code, tech, att, comm, overall, comments) {
        document.getElementById('modalInternId').value = internId;
        document.getElementById('modalInternName').textContent = name + ' (' + code + ')';
        document.getElementById('mTech').value = tech || '';
        document.getElementById('mAtt').value = att || '';
        document.getElementById('mComm').value = comm || '';
        document.getElementById('mOverall').value = overall || '';
        document.getElementById('mComments').value = comments || '';
        calcLiveScore();
        document.getElementById('evalModal').classList.add('open');
    }
    function closeEvalModal() { document.getElementById('evalModal').classList.remove('open'); }
    document.getElementById('evalModal').addEventListener('click', function(e) {
        if (e.target === this) closeEvalModal();
    });

    function calcLiveScore() {
        var t = parseFloat(document.getElementById('mTech').value) || 0;
        var a = parseFloat(document.getElementById('mAtt').value) || 0;
        var c = parseFloat(document.getElementById('mComm').value) || 0;
        if (t > 0 || a > 0 || c > 0) {
            var count = (t > 0 ? 1 : 0) + (a > 0 ? 1 : 0) + (c > 0 ? 1 : 0);
            var avg = count > 0 ? ((t + a + c) / count).toFixed(1) : '0.0';
            document.getElementById('liveScoreText').textContent = avg;
            var ovInput = document.getElementById('mOverall');
            if (!ovInput.value || parseFloat(ovInput.value) === 0) {
                ovInput.value = avg;
            }
            var grade = 'Chưa đạt';
            var sc = parseFloat(avg);
            if (sc >= 9.0) grade = 'Xuất sắc';
            else if (sc >= 8.0) grade = 'Giỏi';
            else if (sc >= 6.5) grade = 'Khá';
            else if (sc >= 5.0) grade = 'Trung bình';
            document.getElementById('liveGradeText').textContent = grade;
        } else {
            document.getElementById('liveScoreText').textContent = '0.0';
            document.getElementById('liveGradeText').textContent = 'Chưa xếp loại';
        }
    }
</script>
</body>
</html>
