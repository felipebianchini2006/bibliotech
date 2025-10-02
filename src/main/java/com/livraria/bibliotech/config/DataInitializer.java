package com.livraria.bibliotech.config;

import com.livraria.bibliotech.model.Usuario;
import com.livraria.bibliotech.repository.UsuarioRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.crypto.password.PasswordEncoder;

@Configuration
@RequiredArgsConstructor
@Slf4j
public class DataInitializer {

    private final UsuarioRepository usuarioRepository;
    private final PasswordEncoder passwordEncoder;

    @Bean
    public CommandLineRunner initData() {
        return args -> {
            // Criar usuário admin se não existir
            if (!usuarioRepository.existsByEmail("admin@bibliotech.com")) {
                Usuario admin = new Usuario();
                admin.setNome("Administrador");
                admin.setEmail("admin@bibliotech.com");
                admin.setSenha(passwordEncoder.encode("admin123"));
                admin.setCpf("00000000000");
                admin.setRole(Usuario.Role.ADMIN);
                admin.setAtivo(true);
                usuarioRepository.save(admin);
                log.info("✓ Usuário ADMIN criado: admin@bibliotech.com / admin123");
            }

            // Criar usuário teste se não existir
            if (!usuarioRepository.existsByEmail("joao@email.com")) {
                Usuario user = new Usuario();
                user.setNome("João Silva");
                user.setEmail("joao@email.com");
                user.setSenha(passwordEncoder.encode("user123"));
                user.setCpf("12345678900");
                user.setTelefone("11999999999");
                user.setRole(Usuario.Role.USER);
                user.setAtivo(true);
                usuarioRepository.save(user);
                log.info("✓ Usuário USER criado: joao@email.com / user123");
            }

            log.info("=".repeat(60));
            log.info("SISTEMA INICIALIZADO COM SUCESSO!");
            log.info("Acesse: http://localhost:8080");
            log.info("=".repeat(60));
        };
    }
}
