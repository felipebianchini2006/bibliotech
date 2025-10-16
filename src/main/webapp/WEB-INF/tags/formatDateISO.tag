<%@ tag description="Formata LocalDate para ISO" pageEncoding="UTF-8"%>
<%@ attribute name="value" required="true" type="java.time.LocalDate" %>
${com.livraria.bibliotech.util.DateFormatter.formatDateISO(value)}
