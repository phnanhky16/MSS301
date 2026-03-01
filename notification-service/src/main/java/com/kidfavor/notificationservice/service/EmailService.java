package com.kidfavor.notificationservice.service;

import com.kidfavor.notificationservice.dto.OrderPlacedEvent;
import jakarta.mail.internet.MimeMessage;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.text.NumberFormat;
import java.time.format.DateTimeFormatter;
import java.util.Locale;

/**
 * Service for sending email notifications via JavaMailSender.
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class EmailService {

        private final JavaMailSender mailSender;

        @Value("${spring.mail.username}")
        private String senderEmail;

        private static final DateTimeFormatter DATE_FMT = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
        private static final NumberFormat CURRENCY_FMT = NumberFormat.getInstance(new Locale("vi", "VN"));

        /**
         * Sends an order confirmation email containing full item details,
         * coupon/discount info, and the total amount to pay.
         */
        public void sendOrderConfirmationEmail(OrderPlacedEvent event) {
                try {
                        MimeMessage message = mailSender.createMimeMessage();
                        MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

                        helper.setFrom(senderEmail);
                        helper.setTo(event.getCustomerEmail());
                        helper.setSubject("KidFavor - Order Confirmation #" + event.getOrderNumber());
                        helper.setText(buildOrderConfirmationBody(event), true);

                        mailSender.send(message);
                        log.info("Order confirmation email sent to: {} for order: {}",
                                        event.getCustomerEmail(), event.getOrderNumber());
                } catch (Exception e) {
                        log.error("Failed to send order confirmation email to: {} for order: {}. Error: {}",
                                        event.getCustomerEmail(), event.getOrderNumber(), e.getMessage());
                }
        }

        /**
         * Sends a welcome email to a newly registered user.
         */
        public void sendWelcomeEmail(String to, String fullName, String username) {
                try {
                        MimeMessage message = mailSender.createMimeMessage();
                        MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

                        helper.setFrom(senderEmail);
                        helper.setTo(to);
                        helper.setSubject("Welcome to KidFavor!");
                        helper.setText(buildWelcomeEmailBody(fullName, username), true);

                        mailSender.send(message);
                        log.info("Welcome email sent to: {} (username: {})", to, username);
                } catch (Exception e) {
                        log.error("Failed to send welcome email to: {} (username: {}). Error: {}",
                                        to, username, e.getMessage());
                }
        }

        // ───────────────────── HTML builders ─────────────────────

        private String buildOrderConfirmationBody(OrderPlacedEvent event) {
                String customerName = event.getCustomerName() != null ? event.getCustomerName() : "Customer";
                String orderDate = event.getCreatedAt() != null ? event.getCreatedAt().format(DATE_FMT) : "N/A";

                // Calculate items subtotal (sum of all item subtotals, before discount)
                BigDecimal itemsSubtotal = BigDecimal.ZERO;
                if (event.getItems() != null) {
                        for (OrderPlacedEvent.OrderItemEvent item : event.getItems()) {
                                if (item.getSubtotal() != null) {
                                        itemsSubtotal = itemsSubtotal.add(item.getSubtotal());
                                }
                        }
                }

                StringBuilder sb = new StringBuilder();
                sb.append("<!DOCTYPE html><html><head><meta charset='UTF-8'></head>");
                sb.append("<body style='margin:0;padding:0;font-family:Arial,Helvetica,sans-serif;background:#f4f4f4;'>");
                sb.append(
                                "<div style='max-width:600px;margin:20px auto;background:#ffffff;border-radius:8px;overflow:hidden;box-shadow:0 2px 8px rgba(0,0,0,0.1);'>");

                // ── Header ──
                sb.append("<div style='background:linear-gradient(135deg,#ff6f61,#ff9a76);padding:24px;text-align:center;'>");
                sb.append("<h1 style='margin:0;color:#fff;font-size:24px;'>&#129528; KidFavor</h1>");
                sb.append("<p style='margin:4px 0 0;color:#fff;font-size:14px;'>Order Confirmation</p>");
                sb.append("</div>");

                // ── Greeting ──
                sb.append("<div style='padding:24px;'>");
                sb.append("<p style='font-size:16px;color:#333;'>Dear <strong>").append(customerName)
                                .append("</strong>,</p>");
                sb.append("<p style='color:#555;'>Thank you for your order! Here are your order details:</p>");

                // ── Order info ──
                sb.append("<table style='width:100%;border-collapse:collapse;margin-bottom:16px;'>");
                sb.append("<tr><td style='padding:6px 0;color:#777;'>Order Number:</td>");
                sb.append("<td style='padding:6px 0;font-weight:bold;color:#333;'>").append(event.getOrderNumber())
                                .append("</td></tr>");
                sb.append("<tr><td style='padding:6px 0;color:#777;'>Order Date:</td>");
                sb.append("<td style='padding:6px 0;color:#333;'>").append(orderDate).append("</td></tr>");
                sb.append("</table>");

                // ── Items table ──
                sb.append("<table style='width:100%;border-collapse:collapse;margin-bottom:16px;'>");
                sb.append("<thead><tr style='background:#f8f8f8;'>");
                sb.append(
                                "<th style='padding:10px 8px;text-align:left;border-bottom:2px solid #eee;color:#555;font-size:13px;'>Product</th>");
                sb.append(
                                "<th style='padding:10px 8px;text-align:center;border-bottom:2px solid #eee;color:#555;font-size:13px;'>Qty</th>");
                sb.append(
                                "<th style='padding:10px 8px;text-align:right;border-bottom:2px solid #eee;color:#555;font-size:13px;'>Unit Price</th>");
                sb.append(
                                "<th style='padding:10px 8px;text-align:right;border-bottom:2px solid #eee;color:#555;font-size:13px;'>Subtotal</th>");
                sb.append("</tr></thead><tbody>");

                if (event.getItems() != null && !event.getItems().isEmpty()) {
                        for (OrderPlacedEvent.OrderItemEvent item : event.getItems()) {
                                sb.append("<tr>");
                                sb.append("<td style='padding:10px 8px;border-bottom:1px solid #f0f0f0;color:#333;'>")
                                                .append(item.getProductName() != null ? item.getProductName() : "N/A")
                                                .append("</td>");
                                sb.append("<td style='padding:10px 8px;text-align:center;border-bottom:1px solid #f0f0f0;color:#333;'>")
                                                .append(item.getQuantity() != null ? item.getQuantity() : 0)
                                                .append("</td>");
                                sb.append("<td style='padding:10px 8px;text-align:right;border-bottom:1px solid #f0f0f0;color:#333;'>")
                                                .append(formatCurrency(item.getUnitPrice())).append("</td>");
                                sb.append(
                                                "<td style='padding:10px 8px;text-align:right;border-bottom:1px solid #f0f0f0;color:#333;font-weight:bold;'>")
                                                .append(formatCurrency(item.getSubtotal())).append("</td>");
                                sb.append("</tr>");
                        }
                } else {
                        sb.append("<tr><td colspan='4' style='padding:10px 8px;text-align:center;color:#999;'>No items</td></tr>");
                }
                sb.append("</tbody></table>");

                // ── Totals section ──
                sb.append("<div style='border-top:2px solid #eee;padding-top:12px;'>");
                sb.append("<table style='width:100%;border-collapse:collapse;'>");

                // Subtotal row
                sb.append("<tr><td style='padding:6px 8px;color:#555;'>Subtotal:</td>");
                sb.append("<td style='padding:6px 8px;text-align:right;color:#333;'>")
                                .append(formatCurrency(itemsSubtotal))
                                .append("</td></tr>");

                // Coupon / Discount row (only if applied)
                boolean hasCoupon = event.getCouponCode() != null && !event.getCouponCode().isBlank();
                BigDecimal discount = event.getDiscountAmount() != null ? event.getDiscountAmount() : BigDecimal.ZERO;
                if (hasCoupon || discount.compareTo(BigDecimal.ZERO) > 0) {
                        String couponLabel = hasCoupon ? "Discount (Coupon: " + event.getCouponCode() + "):"
                                        : "Discount:";
                        sb.append("<tr><td style='padding:6px 8px;color:#27ae60;'>").append(couponLabel)
                                        .append("</td>");
                        sb.append("<td style='padding:6px 8px;text-align:right;color:#27ae60;font-weight:bold;'>-")
                                        .append(formatCurrency(discount)).append("</td></tr>");
                }

                // Total amount row
                sb.append("<tr><td style='padding:10px 8px;font-size:18px;font-weight:bold;color:#333;'>Total:</td>");
                sb.append("<td style='padding:10px 8px;text-align:right;font-size:18px;font-weight:bold;color:#ff6f61;'>")
                                .append(formatCurrency(event.getTotalAmount())).append("</td></tr>");
                sb.append("</table></div>");

                // Footer note
                sb.append("<br/><p style='color:#555;font-size:14px;'>Your order is now being processed. ");
                sb.append("You will receive another email once your order has been shipped.</p>");
                sb.append("</div>"); // end content padding

                // ── Footer ──
                sb.append("<div style='background:#f8f8f8;padding:16px;text-align:center;border-top:1px solid #eee;'>");
                sb.append(
                                "<p style='margin:0;color:#999;font-size:12px;'>Thank you for shopping with <strong>KidFavor</strong> &#129528;</p>");
                sb.append(
                                "<p style='margin:4px 0 0;color:#bbb;font-size:11px;'>This is an automated email. Please do not reply.</p>");
                sb.append("</div>");

                sb.append("</div></body></html>");
                return sb.toString();
        }

        private String buildWelcomeEmailBody(String fullName, String username) {
                return "<html><body>"
                                + "<h2>Welcome to KidFavor, " + fullName + "!</h2>"
                                + "<p>Your account has been successfully created.</p>"
                                + "<p><strong>Username:</strong> " + username + "</p>"
                                + "<br/>"
                                + "<p>Start exploring our wide range of products for kids at the best prices.</p>"
                                + "<p>Happy Shopping!</p>"
                                + "<p><strong>The KidFavor Team</strong></p>"
                                + "</body></html>";
        }

        private String formatCurrency(BigDecimal amount) {
                if (amount == null)
                        return "0 $$";
                return CURRENCY_FMT.format(amount) + " $$";
        }
}
