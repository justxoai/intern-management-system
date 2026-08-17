package codegym.vn.internmanagement.util;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

import java.io.InputStream;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Email notification service. (#13)
 * Reads SMTP config from classpath:email.properties.
 * If credentials are not configured, silently skips sending (no crash).
 */
public class EmailService {

    private static final Logger LOG = Logger.getLogger(EmailService.class.getName());
    private static final Properties CONFIG = new Properties();

    static {
        try (InputStream is = EmailService.class.getClassLoader()
                .getResourceAsStream("email.properties")) {
            if (is != null) CONFIG.load(is);
        } catch (Exception e) {
            LOG.warning("email.properties not found — email sending disabled.");
        }
    }

    /** Send intern application APPROVED notification. */
    public static void sendApprovalEmail(String toEmail, String internName) {
        String subject = "🎉 Your Internship Application Has Been Approved!";
        String body = "<div style='font-family:Inter,sans-serif;max-width:600px;margin:0 auto;padding:32px;'>"
                + "<div style='background:linear-gradient(135deg,#0ea5e9,#38bdf8);border-radius:14px;padding:24px;margin-bottom:24px;text-align:center;'>"
                + "<h1 style='color:#fff;margin:0;font-size:1.5rem'>Internship Management System</h1></div>"
                + "<h2 style='color:#0f172a'>Congratulations, " + escapeHtml(internName) + "! 🎊</h2>"
                + "<p style='color:#475569;line-height:1.6'>Your internship application has been <strong style='color:#16a34a'>APPROVED</strong>.</p>"
                + "<p style='color:#475569;line-height:1.6'>Please log in to the system to:</p>"
                + "<ul style='color:#475569;line-height:1.8'>"
                + "<li>Review your internship contract when available</li>"
                + "<li>Complete your profile and upload any remaining documents</li>"
                + "<li>Check task assignments from your mentor</li>"
                + "</ul>"
                + "<div style='margin-top:24px;padding:16px;background:#f0fdf4;border-radius:10px;border-left:4px solid #16a34a;'>"
                + "<p style='margin:0;color:#15803d;font-weight:600'>Welcome aboard! We look forward to working with you.</p></div>"
                + "<p style='color:#94a3b8;font-size:.8rem;margin-top:24px'>This is an automated message. Please do not reply.</p>"
                + "</div>";
        sendHtml(toEmail, subject, body);
    }

    /** Send intern application REJECTED notification. */
    public static void sendRejectionEmail(String toEmail, String internName, String reason) {
        String subject = "Update on Your Internship Application";
        String body = "<div style='font-family:Inter,sans-serif;max-width:600px;margin:0 auto;padding:32px;'>"
                + "<div style='background:linear-gradient(135deg,#0ea5e9,#38bdf8);border-radius:14px;padding:24px;margin-bottom:24px;text-align:center;'>"
                + "<h1 style='color:#fff;margin:0;font-size:1.5rem'>Internship Management System</h1></div>"
                + "<h2 style='color:#0f172a'>Dear " + escapeHtml(internName) + ",</h2>"
                + "<p style='color:#475569;line-height:1.6'>Thank you for your interest in our internship program.</p>"
                + "<p style='color:#475569;line-height:1.6'>After careful review, we regret to inform you that your application has not been selected at this time.</p>"
                + (reason != null && !reason.isBlank()
                    ? "<div style='margin:20px 0;padding:16px;background:#fef2f2;border-radius:10px;border-left:4px solid #dc2626;'>"
                    + "<p style='margin:0;color:#64748b;font-size:.85rem;font-weight:600'>Reason:</p>"
                    + "<p style='margin:6px 0 0;color:#0f172a'>" + escapeHtml(reason) + "</p></div>"
                    : "")
                + "<p style='color:#475569;line-height:1.6'>We encourage you to apply again in future internship cycles.</p>"
                + "<p style='color:#94a3b8;font-size:.8rem;margin-top:24px'>This is an automated message. Please do not reply.</p>"
                + "</div>";
        sendHtml(toEmail, subject, body);
    }

    // ── core send ──────────────────────────────────────────────────

    private static void sendHtml(String to, String subject, String htmlBody) {
        String username = CONFIG.getProperty("mail.username", "").trim();
        String password = CONFIG.getProperty("mail.password", "").trim();
        if (username.isEmpty() || password.isEmpty()) {
            LOG.info("Email not configured — skipping send to " + to);
            return;
        }

        Properties props = new Properties();
        props.put("mail.smtp.host",             CONFIG.getProperty("mail.smtp.host", "smtp.gmail.com"));
        props.put("mail.smtp.port",             CONFIG.getProperty("mail.smtp.port", "587"));
        props.put("mail.smtp.auth",             CONFIG.getProperty("mail.smtp.auth", "true"));
        props.put("mail.smtp.starttls.enable",  CONFIG.getProperty("mail.smtp.starttls.enable", "true"));

        Session session = Session.getInstance(props, new Authenticator() {
            @Override protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(username, password);
            }
        });

        try {
            MimeMessage msg = new MimeMessage(session);
            String fromName    = CONFIG.getProperty("mail.from.name",    "Internship System");
            String fromAddress = CONFIG.getProperty("mail.from.address", username);
            msg.setFrom(new InternetAddress(fromAddress, fromName, "UTF-8"));
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
            msg.setSubject(subject, "UTF-8");
            msg.setContent(htmlBody, "text/html; charset=UTF-8");
            Transport.send(msg);
            LOG.info("Email sent to " + to + " — " + subject);
        } catch (Exception e) {
            LOG.log(Level.WARNING, "Failed to send email to " + to, e);
        }
    }

    private static String escapeHtml(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;");
    }
}
