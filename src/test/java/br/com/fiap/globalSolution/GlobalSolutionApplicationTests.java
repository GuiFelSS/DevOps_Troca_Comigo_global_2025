package br.com.fiap.globalSolution;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;

@SpringBootTest(properties = {
		// Força o uso do H2, ignorando a variável de ambiente SPRING_DATASOURCE_URL do Azure
		"spring.datasource.url=jdbc:h2:mem:testdb;DB_CLOSE_DELAY=-1;DB_CLOSE_ON_EXIT=FALSE;MODE=Oracle",
		"spring.datasource.driver-class-name=org.h2.Driver",
		"spring.datasource.username=sa",
		"spring.datasource.password=",
		// Força o RabbitMQ local para não tentar conectar no CloudAMQP durante o teste
		"spring.rabbitmq.host=localhost",
		"spring.rabbitmq.port=5672",
		"spring.rabbitmq.username=guest",
		"spring.rabbitmq.password=guest"
})
@ActiveProfiles("test")
class GlobalSolutionApplicationTests {

	@Test
	void contextLoads() {
		// O teste passa se o contexto carregar corretamente (conectando no H2 e não no SQL Server)
	}

}