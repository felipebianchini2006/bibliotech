<%@ tag description="Formata LocalDateTime" pageEncoding="UTF-8"%>
<%@ attribute name="value" required="true" type="java.time.LocalDateTime" %>
${com.livraria.bibliotech.util.DateFormatter.formatDateTime(value)}
