import org.jetbrains.kotlin.gradle.tasks.KotlinCompile
import org.gradle.testing.jacoco.tasks.JacocoReport

plugins {
	id("org.springframework.boot") version "3.3.0"
	id("io.spring.dependency-management") version "1.1.5"
	kotlin("jvm") version "1.9.24"
	kotlin("plugin.spring") version "1.9.24"
	id("jacoco")
}
val springCloudGcpVersion by extra("5.6.0")

group = "com.devforce"
version = "BACKEND_VERSION"

java {
	sourceCompatibility = JavaVersion.VERSION_17
}

repositories {
	mavenCentral()
}

dependencies {
	implementation("org.springframework.boot:spring-boot-starter-web")
	implementation("com.fasterxml.jackson.module:jackson-module-kotlin") //
	implementation("io.jsonwebtoken:jjwt:0.2")
	implementation("org.jetbrains.kotlin:kotlin-reflect")
	implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk8")
	implementation("org.springframework.boot:spring-boot-starter-data-jpa")
	implementation("org.springframework.boot:spring-boot-starter-security") //
	implementation("org.projectlombok:lombok") //
	implementation("org.springframework.boot:spring-boot-starter-mail")
	implementation("org.springframework.boot:spring-boot-starter-mail")
	implementation("com.google.cloud:spring-cloud-gcp-starter-storage")
	implementation("com.google.cloud:spring-cloud-gcp-starter")
	implementation ("com.google.cloud:libraries-bom:25.1.0")
	implementation("com.google.cloud:spring-cloud-gcp-vision")
	implementation("com.google.cloud:google-cloud-bigquery")
	testImplementation("org.springframework.boot:spring-boot-starter-test")
	testImplementation("org.springframework.restdocs:spring-restdocs-mockmvc")
	testImplementation("org.springframework.security:spring-security-test")
	runtimeOnly("org.postgresql:postgresql")
	testRuntimeOnly("org.junit.platform:junit-platform-launcher")
	implementation("javax.xml.bind:jaxb-api:2.3.1")
	implementation("org.glassfish.jaxb:jaxb-runtime:2.3.1")
	implementation("io.jsonwebtoken:jjwt-api:0.11.5") //
	implementation("io.jsonwebtoken:jjwt-impl:0.11.5") //
	implementation("io.jsonwebtoken:jjwt-jackson:0.11.5") //
	implementation("io.github.cdimascio:dotenv-java:2.2.0") //



}

tasks.withType<KotlinCompile> {
	kotlinOptions {
		freeCompilerArgs += "-Xjsr305=strict"
		jvmTarget = "17"
	}
}

tasks {
	val test by getting(Test::class) {
		useJUnitPlatform()
		testLogging {
			events("passed", "skipped", "failed")
		}
	}

	val codeCoverageReport by creating(JacocoReport::class) {
		executionData(fileTree(project.rootDir.absolutePath).include("**/build/jacoco/*.exec"))

		subprojects.forEach {
			sourceSets(it.sourceSets["main"])
		}

		reports {
			xml.required.set(true)
			xml.outputLocation.set(layout.buildDirectory.file("reports/jacoco/report.xml"))
			html.required.set(true)
			html.outputLocation.set(layout.buildDirectory.dir("reports/jacoco/html"))
			csv.required.set(false)

			sourceDirectories.setFrom(files(sourceSets["main"].allSource.srcDirs))
			classDirectories.setFrom(files(sourceSets["main"].output))
		}

		dependsOn(test)

		doLast {
			println("Jacoco report generated at: ${reports.xml.outputLocation.get().asFile.absolutePath}")
			println("Jacoco HTML report generated at: ${reports.html.outputLocation.get().asFile.absolutePath}")
		}
	}
}

tasks.named("check") {
	dependsOn("codeCoverageReport")
}
dependencyManagement {
	imports {
		mavenBom("com.google.cloud:spring-cloud-gcp-dependencies:$springCloudGcpVersion")
	}
}
