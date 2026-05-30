package com.project.bookStore_backend.controller;

import com.project.bookStore_backend.model.Orders;
import com.project.bookStore_backend.model.Payment;
import com.project.bookStore_backend.service.OrderService;
import com.project.bookStore_backend.service.PaymentService;
import com.project.bookStore_backend.util.SessionUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.lowagie.text.*;
import com.lowagie.text.pdf.*;

import jakarta.servlet.http.HttpSession;
import java.awt.Color;
import java.io.ByteArrayOutputStream;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/payment")
public class PaymentController {

    @Autowired
    private OrderService orderService;

    @Autowired
    private PaymentService paymentService;

    // Show payment page
    @GetMapping("/{orderId}")
    public String showPaymentPage(@PathVariable Long orderId, Model model, HttpSession session) {
        // Check if user is logged in
        Long customerId = SessionUtils.getCurrentCustomerId(session);
        if (customerId == null) {
            return "redirect:/login?error=login_required";
        }

        // Get order details
        Optional<Orders> orderOpt = orderService.getOrderById(orderId);
        if (orderOpt.isEmpty()) {
            return "redirect:/cart?error=order_not_found";
        }

        Orders order = orderOpt.get();
        
        // Verify the order belongs to the current customer
        if (!order.getCustomer().getCid().equals(customerId)) {
            return "redirect:/cart?error=unauthorized_access";
        }

        // Check if order is still pending payment
        if (order.getPaymentStatus() != Orders.PaymentStatus.Pending) {
            return "redirect:/orders/confirmation/" + orderId;
        }

        model.addAttribute("order", order);
        return "payment";
    }

    // Process payment
    @PostMapping("/{orderId}/confirm")
    public String processPayment(@PathVariable Long orderId, 
                                @RequestParam(required = false) String cardNumber,
                                @RequestParam(required = false) String cardExpiry,
                                @RequestParam(required = false) String cardholderName,
                                HttpSession session) {
        // Check if user is logged in
        Long customerId = SessionUtils.getCurrentCustomerId(session);
        if (customerId == null) {
            return "redirect:/login?error=login_required";
        }

        try {
            // Get order details
            Optional<Orders> orderOpt = orderService.getOrderById(orderId);
            if (orderOpt.isEmpty()) {
                return "redirect:/cart?error=order_not_found";
            }

            Orders order = orderOpt.get();
            
            // Verify the order belongs to the current customer
            if (!order.getCustomer().getCid().equals(customerId)) {
                return "redirect:/cart?error=unauthorized_access";
            }

            // Check if order is still pending payment
            if (order.getPaymentStatus() != Orders.PaymentStatus.Pending) {
                return "redirect:/orders/confirmation/" + orderId;
            }

            // Process the payment based on payment method
            if ("CASH_ON_DELIVERY".equals(order.getPaymentMethod())) {
                paymentService.processCODPayment(orderId);
            } else {
                paymentService.processPayment(orderId, cardNumber, cardExpiry, cardholderName);
            }
            
            // Redirect to payment success page
            return "redirect:/payment/success/" + orderId;
            
        } catch (Exception e) {
            System.err.println("Payment processing error: " + e.getMessage());
            e.printStackTrace();
            return "redirect:/payment/" + orderId + "?error=payment_failed";
        }
    }

    // Show payment success page
    @GetMapping("/success/{orderId}")
    public String paymentSuccess(@PathVariable Long orderId, Model model, HttpSession session) {
        Long customerId = SessionUtils.getCurrentCustomerId(session);
        if (customerId == null) {
            return "redirect:/login";
        }

        Optional<Orders> orderOpt = orderService.getOrderById(orderId);
        if (orderOpt.isPresent()) {
            Orders order = orderOpt.get();
            // Verify the order belongs to the current customer
            if (order.getCustomer().getCid().equals(customerId)) {
                model.addAttribute("order", order);
                
                // Get payment details
                List<Payment> payments = paymentService.getPaymentsByOrder(orderId);
                if (!payments.isEmpty()) {
                    model.addAttribute("payment", payments.get(0)); // Get the latest payment
                }
                
                return "paymentSuccess";
            }
        }
        return "redirect:/orders?error=order_not_found";
    }

    // Download invoice PDF from payment success page
    @GetMapping("/{orderId}/invoice")
    public ResponseEntity<ByteArrayResource> downloadInvoice(@PathVariable Long orderId, HttpSession session) {
        try {
            Long customerId = SessionUtils.getCurrentCustomerId(session);
            if (customerId == null) {
                return ResponseEntity.status(401).build();
            }

            Optional<Orders> orderOpt = orderService.getOrderById(orderId);
            if (orderOpt.isEmpty()) {
                return ResponseEntity.notFound().build();
            }

            Orders order = orderOpt.get();
            // Verify the order belongs to the current customer
            if (!order.getCustomer().getCid().equals(customerId)) {
                return ResponseEntity.status(403).build();
            }

            // Generate PDF invoice
            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            Document document = new Document(PageSize.A4);
            PdfWriter.getInstance(document, baos);
            document.open();

            // Set up fonts
            Font titleFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 24, Color.DARK_GRAY);
            Font headerFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 14, Color.DARK_GRAY);
            Font normalFont = FontFactory.getFont(FontFactory.HELVETICA, 12, Color.BLACK);
            Font smallFont = FontFactory.getFont(FontFactory.HELVETICA, 10, Color.GRAY);

            // Title
            Paragraph title = new Paragraph("INVOICE", titleFont);
            title.setAlignment(Element.ALIGN_CENTER);
            title.setSpacingAfter(20);
            document.add(title);

            // Company info
            Paragraph companyInfo = new Paragraph();
            companyInfo.add(new Chunk("BookNest", headerFont));
            companyInfo.add(new Chunk("\nOnline Book Store\n", normalFont));
            companyInfo.add(new Chunk("Email: support@booknest.com\n", smallFont));
            companyInfo.add(new Chunk("Phone: +94 (32)220 888 23", smallFont));
            companyInfo.setSpacingAfter(20);
            document.add(companyInfo);

            // Invoice details table
            PdfPTable invoiceTable = new PdfPTable(2);
            invoiceTable.setWidthPercentage(100);
            invoiceTable.setSpacingAfter(20);

            // Invoice number and date
            invoiceTable.addCell(createCell("Invoice Number:", headerFont, false));
            invoiceTable.addCell(createCell("#" + order.getOid(), normalFont, false));
            invoiceTable.addCell(createCell("Invoice Date:", headerFont, false));
            invoiceTable.addCell(createCell(order.getOrderDate().format(DateTimeFormatter.ofPattern("MMM dd, yyyy")), normalFont, false));
            invoiceTable.addCell(createCell("Transaction ID:", headerFont, false));
            invoiceTable.addCell(createCell(order.getTransactionId(), normalFont, false));
            invoiceTable.addCell(createCell("Payment Method:", headerFont, false));
            invoiceTable.addCell(createCell(order.getPaymentMethod(), normalFont, false));

            document.add(invoiceTable);

            // Customer information
            Paragraph customerHeader = new Paragraph("Bill To:", headerFont);
            customerHeader.setSpacingBefore(20);
            customerHeader.setSpacingAfter(10);
            document.add(customerHeader);

            Paragraph customerInfo = new Paragraph();
            customerInfo.add(new Chunk(order.getCustomer().getCname(), normalFont));
            if (order.getBillingAddress() != null && !order.getBillingAddress().isEmpty()) {
                customerInfo.add(new Chunk("\n" + order.getBillingAddress(), normalFont));
            }
            customerInfo.setSpacingAfter(20);
            document.add(customerInfo);

            // Order summary
            Paragraph orderHeader = new Paragraph("Order Summary:", headerFont);
            orderHeader.setSpacingBefore(20);
            orderHeader.setSpacingAfter(10);
            document.add(orderHeader);

            PdfPTable orderTable = new PdfPTable(2);
            orderTable.setWidthPercentage(100);
            orderTable.setSpacingAfter(20);

            orderTable.addCell(createCell("Order Status:", headerFont, false));
            orderTable.addCell(createCell(order.getStatusDisplayName(), normalFont, false));
            orderTable.addCell(createCell("Payment Status:", headerFont, false));
            orderTable.addCell(createCell(order.getPaymentStatusDisplayName(), normalFont, false));
            orderTable.addCell(createCell("Total Amount:", headerFont, true));
            orderTable.addCell(createCell("$" + String.format("%.2f", order.getTotalAmount()), headerFont, true));

            document.add(orderTable);

            // Order notes if available
            if (order.getOrderNotes() != null && !order.getOrderNotes().isEmpty()) {
                Paragraph notesHeader = new Paragraph("Order Notes:", headerFont);
                notesHeader.setSpacingBefore(20);
                notesHeader.setSpacingAfter(10);
                document.add(notesHeader);

                Paragraph notes = new Paragraph(order.getOrderNotes(), normalFont);
                notes.setSpacingAfter(20);
                document.add(notes);
            }

            // Footer
            Paragraph footer = new Paragraph();
            footer.add(new Chunk("Thank you for your business!\n", normalFont));
            footer.add(new Chunk("This invoice was generated on " + 
                java.time.LocalDateTime.now().format(DateTimeFormatter.ofPattern("MMM dd, yyyy 'at' HH:mm")), smallFont));
            footer.setAlignment(Element.ALIGN_CENTER);
            footer.setSpacingBefore(40);
            document.add(footer);

            document.close();

            byte[] pdfBytes = baos.toByteArray();
            ByteArrayResource resource = new ByteArrayResource(pdfBytes);

            HttpHeaders headers = new HttpHeaders();
            headers.add(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=invoice-" + orderId + ".pdf");
            headers.add(HttpHeaders.CONTENT_TYPE, "application/pdf");

            return ResponseEntity.ok()
                    .headers(headers)
                    .contentLength(pdfBytes.length)
                    .contentType(MediaType.APPLICATION_PDF)
                    .body(resource);
                    
        } catch (Exception e) {
            System.err.println("Invoice generation error: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.status(500).build();
        }
    }

    private PdfPCell createCell(String text, Font font, boolean isBold) {
        PdfPCell cell = new PdfPCell(new Phrase(text, font));
        cell.setPadding(8);
        cell.setBorder(Rectangle.NO_BORDER);
        if (isBold) {
            cell.setBackgroundColor(Color.LIGHT_GRAY);
        }
        return cell;
    }
}
