package com.kidfavor.notificationservice.service;

import jakarta.mail.internet.MimeMessage;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

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

    /**
     * Sends an order confirmation email to the customer.
     */
    public void sendOrderConfirmationEmail(String to, String customerName, String orderNumber,
                                           String totalAmount) {
        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            helper.setFrom(senderEmail);
            helper.setTo(to);
            helper.setSubject("Order Confirmation - " + orderNumber);
            helper.setText(buildOrderConfirmationBody(customerName, orderNumber, totalAmount), true);

            mailSender.send(message);
            log.info("Order confirmation email sent to: {} for order: {}", to, orderNumber);
        } catch (Exception e) {
            log.error("Failed to send order confirmation email to: {} for order: {}. Error: {}",
                    to, orderNumber, e.getMessage());
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

    private String buildOrderConfirmationBody(String customerName, String orderNumber, String totalAmount) {
        return "<html><body>"
                + "<h2>Dear " + customerName + ",</h2>"
                + "<p>Thank you for your order! We have received your order and it is now being processed.</p>"
                + "<table border='1' cellpadding='8'>"
                + "<tr><th>Order Number</th><td><strong>" + orderNumber + "</strong></td></tr>"
                + "<tr><th>Total Amount</th><td>" + totalAmount + " VND</td></tr>"
                + "</table>"
                + "<br/>"
                + "<p>You will receive another email once your order has been shipped.</p>"
                + "<p>Thank you for shopping with <strong>KidFavor</strong>!</p>"
                + "</body></html>";
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
}
