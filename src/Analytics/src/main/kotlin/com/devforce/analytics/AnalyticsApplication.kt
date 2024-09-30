package com.devforce.analytics


import io.github.cdimascio.dotenv.Dotenv
import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication


@SpringBootApplication
class AnalyticsApplication
fun main(args: Array<String>) {
    val dotenv: Dotenv = Dotenv.load()

    System.setProperty("DB_USERNAME", dotenv.get("DB_USERNAME"))
    val port = dotenv.get("DB_URL")
    System.setProperty("MAIL_PASSWORD", dotenv.get("MAIL_PASSWORD"))
    System.setProperty("MAIL_USERNAME", dotenv.get("MAIL_USERNAME"))
    System.setProperty("SECRET", dotenv.get("SECRET"))

    System.setProperty("CORS_ORIGINS", dotenv.get("CORS_ORIGINS"))
    System.setProperty("API_KEY", dotenv.get("API_KEY"))
    System.setProperty("DB_PASSWORD", dotenv.get("DB_PASSWORD"))
    System.setProperty("DB_URL", dotenv.get("DB_URL"))

    runApplication<AnalyticsApplication>(*args)
}