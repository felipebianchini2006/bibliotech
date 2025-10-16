<%@ tag description="Formata LocalDate" pageEncoding="UTF-8"%>
<%@ attribute name="value" required="true" type="java.time.LocalDate" %>
${com.livraria.bibliotech.util.DateFormatter.formatDate(value)}
