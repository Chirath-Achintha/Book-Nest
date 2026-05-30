package com.project.bookStore_backend.controller;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.boot.web.servlet.error.ErrorController;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class CustomErrorController implements ErrorController {

    @RequestMapping("/error")
    public String handleError(HttpServletRequest request, Model model) {
        Object status = request.getAttribute(RequestDispatcher.ERROR_STATUS_CODE);
        Integer statusCode = null;
        String errorMessage = "Unexpected error";

        if (status != null) {
            try {
                statusCode = Integer.valueOf(status.toString());
                HttpStatus httpStatus = HttpStatus.resolve(statusCode);
                if (httpStatus != null) {
                    errorMessage = httpStatus.getReasonPhrase();
                }
            } catch (NumberFormatException ignored) {
                // leave defaults
            }
        }

        model.addAttribute("statusCode", statusCode);
        model.addAttribute("message", errorMessage);
        return "error"; // /WEB-INF/jsp/error.jsp
    }
}


