package com.livraria.bibliotech.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;
import org.springframework.transaction.annotation.EnableTransactionManagement;

/**
 * Configuração do JPA e repositórios
 */
@Configuration
@EnableJpaRepositories(basePackages = "com.livraria.bibliotech.repository")
@EnableTransactionManagement
public class JpaConfig {
    // Configurações adicionais do JPA podem ser adicionadas aqui
}
