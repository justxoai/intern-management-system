package codegym.vn.internmanagement.util;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

import java.io.InputStream;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Dịch vụ gửi email thông báo qua SMTP.
 *
 * Đọc cấu hình từ classpath:email.properties.
 * Nếu credentials chưa được cấu hình, bỏ qua việc gửi một cách gracefully (không crash).
 *
 * Các sự kiện được thông báo:
 *  - Hồ sơ thực tập được DUYỆT    → sendApprovalEmail()
 *  - Hồ sơ thực tập bị TỪ CHỐI   → sendRejectionEmail()
 */
public class EmailService {

    private static final Logger LOG = Logger.getLogger(EmailService.class.getName());
    private static final Properties CONFIG = new Properties();

    static {
        try (InputStream is = EmailService.class.getClassLoader()
                .getResourceAsStream("email.properties")) {
            if (is != null) {
                CONFIG.load(is);
                LOG.info("email.properties loaded — SMTP host: "
                        + CONFIG.getProperty("mail.smtp.host", "(not set)"));
            } else {
                LOG.warning("email.properties không tìm thấy — tính năng gửi email bị tắt.");
            }
        } catch (Exception e) {
            LOG.warning("Lỗi khi đọc email.properties: " + e.getMessage());
        }
    }

    // ────────────────────────────────────────────────────────────────
    // Public API
    // ────────────────────────────────────────────────────────────────

    /**
     * Gửi email thông báo hồ sơ thực tập đã được DUYỆT.
     *
     * @param toEmail   Địa chỉ email người nhận (thực tập sinh)
     * @param internName Họ tên thực tập sinh
     */
    public static void sendApprovalEmail(String toEmail, String internName) {
        String subject = "🎉 Hồ sơ thực tập của bạn đã được DUYỆT!";
        String body = buildApprovalBody(internName);
        sendHtml(toEmail, subject, body);
    }

    /**
     * Gửi email thông báo hồ sơ thực tập bị TỪ CHỐI.
     *
     * @param toEmail    Địa chỉ email người nhận (thực tập sinh)
     * @param internName Họ tên thực tập sinh
     * @param reason     Lý do từ chối (có thể null hoặc rỗng)
     */
    public static void sendRejectionEmail(String toEmail, String internName, String reason) {
        String subject = "Thông báo kết quả xét duyệt hồ sơ thực tập";
        String body = buildRejectionBody(internName, reason);
        sendHtml(toEmail, subject, body);
    }

    // ────────────────────────────────────────────────────────────────
    // Email templates
    // ────────────────────────────────────────────────────────────────

    private static String buildApprovalBody(String internName) {
        return "<div style='font-family:\"Helvetica Neue\",Arial,sans-serif;max-width:600px;margin:0 auto;padding:0;background:#f8fafc;'>"
                // Header
                + "<div style='background:linear-gradient(135deg,#1565c0,#1e88e5);border-radius:14px 14px 0 0;padding:32px;text-align:center;'>"
                + "<div style='width:64px;height:64px;background:rgba(255,255,255,.15);border-radius:50%;display:inline-flex;align-items:center;justify-content:center;margin-bottom:12px;font-size:2rem;'>🎓</div>"
                + "<h1 style='color:#fff;margin:0;font-size:1.4rem;font-weight:700;'>Hệ thống Quản lý Thực tập</h1>"
                + "<p style='color:rgba(255,255,255,.75);margin:6px 0 0;font-size:.9rem;'>Thông báo kết quả xét duyệt</p>"
                + "</div>"
                // Body
                + "<div style='background:#fff;padding:32px;border:1px solid #e2e8f0;border-top:none;'>"
                + "<div style='width:56px;height:56px;background:#f0fdf4;border-radius:50%;display:inline-flex;align-items:center;justify-content:center;font-size:1.8rem;margin-bottom:16px;'>✅</div>"
                + "<h2 style='color:#0f172a;margin:0 0 8px;font-size:1.3rem;'>Chúc mừng, " + escapeHtml(internName) + "! 🎊</h2>"
                + "<p style='color:#475569;line-height:1.7;margin:0 0 16px;'>Hồ sơ thực tập của bạn đã được xem xét và chính thức "
                + "<strong style='color:#16a34a;'>ĐƯỢC DUYỆT</strong>.</p>"
                + "<p style='color:#475569;line-height:1.7;margin:0 0 12px;'>Vui lòng đăng nhập vào hệ thống để:</p>"
                + "<ul style='color:#475569;line-height:2;padding-left:20px;margin:0 0 20px;'>"
                + "<li>Xem và ký hợp đồng thực tập khi có sẵn</li>"
                + "<li>Hoàn thiện hồ sơ và tải lên các tài liệu còn thiếu</li>"
                + "<li>Nhận nhiệm vụ từ mentor hướng dẫn của bạn</li>"
                + "</ul>"
                // Success banner
                + "<div style='background:#f0fdf4;border-left:4px solid #16a34a;border-radius:0 8px 8px 0;padding:16px;margin-bottom:24px;'>"
                + "<p style='margin:0;color:#15803d;font-weight:600;'>🌟 Chào mừng bạn đến với chương trình thực tập của chúng tôi!</p>"
                + "</div>"
                // CTA button
                + "<div style='text-align:center;margin:24px 0;'>"
                + "<a href='#' style='display:inline-block;background:linear-gradient(135deg,#1565c0,#1e88e5);color:#fff;padding:13px 32px;"
                + "border-radius:10px;text-decoration:none;font-weight:700;font-size:.95rem;box-shadow:0 4px 14px rgba(21,101,192,.35);'>"
                + "Đăng nhập hệ thống →</a>"
                + "</div>"
                + "</div>"
                // Footer
                + "<div style='padding:20px 32px;text-align:center;'>"
                + "<p style='color:#94a3b8;font-size:.78rem;margin:0;'>Email này được gửi tự động từ Hệ thống Quản lý Thực tập.</p>"
                + "<p style='color:#94a3b8;font-size:.78rem;margin:4px 0 0;'>Vui lòng không trả lời email này.</p>"
                + "</div>"
                + "</div>";
    }

    private static String buildRejectionBody(String internName, String reason) {
        String reasonBlock = (reason != null && !reason.isBlank())
                ? "<div style='background:#fef2f2;border-left:4px solid #dc2626;border-radius:0 8px 8px 0;padding:16px;margin:20px 0;'>"
                + "<p style='margin:0 0 4px;color:#64748b;font-size:.82rem;font-weight:700;text-transform:uppercase;letter-spacing:.5px;'>Lý do:</p>"
                + "<p style='margin:0;color:#0f172a;'>" + escapeHtml(reason) + "</p>"
                + "</div>"
                : "";

        return "<div style='font-family:\"Helvetica Neue\",Arial,sans-serif;max-width:600px;margin:0 auto;padding:0;background:#f8fafc;'>"
                // Header
                + "<div style='background:linear-gradient(135deg,#1565c0,#1e88e5);border-radius:14px 14px 0 0;padding:32px;text-align:center;'>"
                + "<div style='width:64px;height:64px;background:rgba(255,255,255,.15);border-radius:50%;display:inline-flex;align-items:center;justify-content:center;margin-bottom:12px;font-size:2rem;'>🎓</div>"
                + "<h1 style='color:#fff;margin:0;font-size:1.4rem;font-weight:700;'>Hệ thống Quản lý Thực tập</h1>"
                + "<p style='color:rgba(255,255,255,.75);margin:6px 0 0;font-size:.9rem;'>Thông báo kết quả xét duyệt</p>"
                + "</div>"
                // Body
                + "<div style='background:#fff;padding:32px;border:1px solid #e2e8f0;border-top:none;'>"
                + "<h2 style='color:#0f172a;margin:0 0 8px;font-size:1.2rem;'>Kính gửi " + escapeHtml(internName) + ",</h2>"
                + "<p style='color:#475569;line-height:1.7;margin:0 0 12px;'>"
                + "Cảm ơn bạn đã quan tâm đến chương trình thực tập của chúng tôi.</p>"
                + "<p style='color:#475569;line-height:1.7;margin:0 0 12px;'>"
                + "Sau khi xem xét kỹ lưỡng, chúng tôi rất tiếc phải thông báo rằng hồ sơ của bạn "
                + "<strong style='color:#dc2626;'>chưa được chấp nhận</strong> trong đợt xét tuyển lần này.</p>"
                + reasonBlock
                + "<p style='color:#475569;line-height:1.7;margin:0 0 20px;'>"
                + "Chúng tôi khuyến khích bạn tiếp tục nộp đơn trong các đợt tuyển dụng tiếp theo. "
                + "Chúc bạn thành công trên con đường sự nghiệp!</p>"
                // Footer note
                + "<div style='background:#f8fafc;border-radius:8px;padding:16px;border:1px solid #e2e8f0;'>"
                + "<p style='margin:0;color:#64748b;font-size:.85rem;'>💡 Nếu có thắc mắc, vui lòng liên hệ bộ phận nhân sự để được hỗ trợ thêm.</p>"
                + "</div>"
                + "</div>"
                // Footer
                + "<div style='padding:20px 32px;text-align:center;'>"
                + "<p style='color:#94a3b8;font-size:.78rem;margin:0;'>Email này được gửi tự động từ Hệ thống Quản lý Thực tập.</p>"
                + "<p style='color:#94a3b8;font-size:.78rem;margin:4px 0 0;'>Vui lòng không trả lời email này.</p>"
                + "</div>"
                + "</div>";
    }

    // ────────────────────────────────────────────────────────────────
    // Core send
    // ────────────────────────────────────────────────────────────────

    private static void sendHtml(String to, String subject, String htmlBody) {
        String username = CONFIG.getProperty("mail.username", "").trim();
        String password = CONFIG.getProperty("mail.password", "").trim();
        if (username.isEmpty() || password.isEmpty()) {
            LOG.info("Email chưa cấu hình — bỏ qua gửi đến: " + to);
            return;
        }

        Properties props = new Properties();
        props.put("mail.smtp.host",            CONFIG.getProperty("mail.smtp.host", "smtp.gmail.com"));
        props.put("mail.smtp.port",            CONFIG.getProperty("mail.smtp.port", "587"));
        props.put("mail.smtp.auth",            CONFIG.getProperty("mail.smtp.auth", "true"));
        props.put("mail.smtp.starttls.enable", CONFIG.getProperty("mail.smtp.starttls.enable", "true"));
        props.put("mail.smtp.ssl.protocols",   "TLSv1.2 TLSv1.3");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(username, password);
            }
        });

        try {
            MimeMessage msg = new MimeMessage(session);
            String fromName    = CONFIG.getProperty("mail.from.name",    "Hệ thống Quản lý Thực tập");
            String fromAddress = CONFIG.getProperty("mail.from.address", username);
            msg.setFrom(new InternetAddress(fromAddress, fromName, "UTF-8"));
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
            msg.setSubject(subject, "UTF-8");
            msg.setContent(htmlBody, "text/html; charset=UTF-8");
            Transport.send(msg);
            LOG.info("✅ Email đã gửi đến " + to + " — " + subject);
        } catch (Exception e) {
            LOG.log(Level.WARNING, "❌ Gửi email thất bại đến " + to + ": " + e.getMessage(), e);
        }
    }

    private static String escapeHtml(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;");
    }
}
