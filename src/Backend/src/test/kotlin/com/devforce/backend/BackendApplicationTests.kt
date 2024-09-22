package com.devforce.backend

import io.github.cdimascio.dotenv.Dotenv
import org.junit.jupiter.api.BeforeAll
import org.junit.jupiter.api.Test
import org.springframework.boot.test.context.SpringBootTest

@SpringBootTest
class BackendApplicationTests {

    @Test
	fun contextLoads() {
	}

    companion object {
        @JvmStatic
        @BeforeAll
        fun setUp(): Unit {
			val dotenv: Dotenv = Dotenv.load()

			System.setProperty("DB_USERNAME", dotenv.get("DB_USERNAME"))
			System.setProperty("MAIL_PASSWORD", dotenv.get("MAIL_PASSWORD"))
			System.setProperty("MAIL_USERNAME", dotenv.get("MAIL_USERNAME"))
			System.setProperty("SECRET", dotenv.get("SECRET"))

			System.setProperty("CORS_ORIGINS", dotenv.get("CORS_ORIGINS"))
			System.setProperty("DB_PASSWORD", dotenv.get("DB_PASSWORD"))
			System.setProperty("DB_URL", dotenv.get("DB_URL"))
			System.setProperty("BEARER_TOKEN", dotenv.get("BEARER_TOKEN"))
        }
    }

}
