package com.elmeftouhi.coolify;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.boot.CommandLineRunner;

@SpringBootApplication
public class CoolifyApplication {

	public static void main(String[] args) {
		SpringApplication.run(CoolifyApplication.class, args);
	}

	@Bean
	public CommandLineRunner seedData(ItemRepository itemRepository) {
		return args -> {
			if (itemRepository.count() == 0) {
				itemRepository.save(new Item("Coffee Maker", "Brews excellent coffee"));
				itemRepository.save(new Item("Smart Lamp", "Wi-Fi enabled lamp"));
				itemRepository.save(new Item("Notebook", "200-page ruled notebook"));
			}
		};
	}

}
