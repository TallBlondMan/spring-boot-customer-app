package dev.simplesolution.customer;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class CustomerApiApplication {

	@Value("${cors.allowed-origins}")
	private String allowedOrigins;

	public static void main(String[] args) {
		SpringApplication.run(CustomerApiApplication.class, args);
	}
}
