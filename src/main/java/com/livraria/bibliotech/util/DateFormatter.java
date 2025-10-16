package com.livraria.bibliotech.util;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 * Funções utilitárias para formatação de datas em JSP.
 * Compatível com LocalDate e LocalDateTime do Java 8+.
 */
public class DateFormatter {

    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    private static final DateTimeFormatter DATETIME_FORMATTER = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
    private static final DateTimeFormatter ISO_DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd");

    /**
     * Formata LocalDate para formato brasileiro (dd/MM/yyyy).
     */
    public static String formatDate(LocalDate date) {
        if (date == null) {
            return "";
        }
        return date.format(DATE_FORMATTER);
    }

    /**
     * Formata LocalDateTime para formato brasileiro (dd/MM/yyyy HH:mm).
     */
    public static String formatDateTime(LocalDateTime dateTime) {
        if (dateTime == null) {
            return "";
        }
        return dateTime.format(DATETIME_FORMATTER);
    }

    /**
     * Formata LocalDate para formato ISO (yyyy-MM-dd) - usado em inputs HTML.
     */
    public static String formatDateISO(LocalDate date) {
        if (date == null) {
            return "";
        }
        return date.format(ISO_DATE_FORMATTER);
    }

    /**
     * Formata LocalDateTime para data em formato brasileiro (dd/MM/yyyy).
     */
    public static String formatDateTimeAsDate(LocalDateTime dateTime) {
        if (dateTime == null) {
            return "";
        }
        return dateTime.format(DATE_FORMATTER);
    }
}
