package com.devforce.analytics.service
import com.devforce.analytics.repo.RecommendedDateRepoImpl
import com.devforce.analytics.repo.RecommendedVenueRepoImpl
import com.devforce.analytics.security.CustomUser
import com.devforce.backend.dto.ResponseDto
import com.fasterxml.jackson.module.kotlin.jacksonObjectMapper
import com.fasterxml.jackson.module.kotlin.readValue
import org.springframework.http.*
import org.springframework.stereotype.Service
import org.springframework.web.client.RestTemplate
import kotlinx.serialization.*
import kotlinx.serialization.json.*
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Value
import org.springframework.security.core.context.SecurityContextHolder


data class ContentPart(val text: String)
data class RolePart(val role: String, val parts: List<ContentPart>)
data class GenerationConfig(
    val temperature: Float,
    val topK: Int,
    val topP: Float,
    val maxOutputTokens: Int,
    val responseMimeType: String
)
data class ApiRequestBody(val contents: List<RolePart>, val generationConfig: GenerationConfig)

@Serializable
data class Descriptions(
    val description: String,
    val category: String
)

@Service
class LanguageModelService {

    private val API_KEY: String? = System.getenv("API_KEY")

    private val API_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$API_KEY"

    @Autowired
    private lateinit var recommendedDateRepo: RecommendedDateRepoImpl


    @Autowired
    private lateinit var recommendedVenueRepo: RecommendedVenueRepoImpl

    fun generateEventDescription(prompt: String, title: String): ResponseEntity<ResponseDto> {
        val user = SecurityContextHolder.getContext().authentication.principal
        val userModel = (user as CustomUser).userModel

        val restTemplate = RestTemplate()

        // Construct headers
        val headers = HttpHeaders().apply {
            contentType = MediaType.APPLICATION_JSON
        }

        // Construct the body
        val body = ApiRequestBody(
            contents = listOf(
                RolePart(
                    role = "user",
                    parts = listOf(ContentPart("Can you please the role of an assistant for the host users of our application and generate a longer description about an event which you are going a going to receive a title and short description for which will be about 10-25 words about the event, you need to generate a 50 words description and categorise the event into an array of the categories categories = [\\n\\\"Comedy Show\\\",\\n\\\"Industry Talk\\\",\\n\\\"Academic\\\",\\n\\\"Game Night\\\",\\n\\\"Literary Event\\\",\\n\\\"Dance Performance\\\",\\n\\\"Technology\\\",\\n\\\"Fashion Show\\\",\\n\\\"Film Screening\\\",\\n\\\"Theater Production\\\",\\n\\\"Career Fair\\\",\\n\\\"Nutrition\\\",\\n\\\"Food\\\",\\n\\\"Workshop\\\",\\n\\\"Guest Lecture\\\",\\n\\\"Sports & Fitness\\\",\\n\\\"Hackathon\\\",\\n\\\"Art Exhibition\\\",\\n\\\"Entrepreneurship\\\",\\n\\\"Mental Health\\\",\\n\\\"Health & Wellness\\\",\\n\\\"Tech Expo\\\",\\n\\\"Social\\\",\\n\\\"Music Performance\\\",\\n\\\"Cultural Festival\\\",\\n\\\"Debating\\\",\\n\\\"Clubs & Organizations\\\",\\n\\\"Charity Event\\\"\\n]\\nreturn a json with 3 options of 3 \\\"descriptions\\\" & \\\"category\\\" one category for each option as a string\\nplease return only the json\\n"))
                ),
                RolePart(
                    role = "model",
                    parts = listOf(ContentPart("```json\\n[\\n  {\\n    \\\"description\\\": \\\"Join us for an interactive and engaging workshop where you'\\''ll learn the fundamentals of web development and build your first website. This hands-on session is perfect for beginners looking to get started in the world of coding.\\\",\\n    \\\"category\\\": \\\"Technology\\\"\\n  },\\n  {\\n    \\\"description\\\": \\\"Indulge in a delightful evening of delicious food and engaging conversation with fellow foodies. We'\\''ll be showcasing the best local culinary creations, offering insights into the art of food preparation, and fostering a vibrant community of food enthusiasts.\\\",\\n    \\\"category\\\": \\\"Food\\\"\\n  },\\n  {\\n    \\\"description\\\": \\\"Experience a captivating performance by our talented dance troupe, showcasing a fusion of traditional and contemporary styles. Prepare to be mesmerized by their intricate movements, expressive storytelling, and vibrant costumes.\\\",\\n    \\\"category\\\": \\\"Dance Performance\\\"\\n  }\\n]\\n```"))
                ),
                RolePart(
                    role = "user",
                    parts = listOf(ContentPart(prompt))
                )
            ),
            generationConfig = GenerationConfig(
                temperature = 1f,
                topK = 64,
                topP = 0.95f,
                maxOutputTokens = 8192,
                responseMimeType = "text/plain"
            )
        )

        // Convert body to JSON
        val objectMapper = jacksonObjectMapper()
        val jsonBody = objectMapper.writeValueAsString(body)

        // Prepare the request
        val entity = HttpEntity(jsonBody, headers)


        // Make the POST request
        val response: ResponseEntity<String> = restTemplate.exchange(
            API_URL,
            HttpMethod.POST,
            entity,
            String::class.java
        )

        // Deserialize the response to the desired format
        return if (response.statusCode.is2xxSuccessful) {
            val apiResponse = objectMapper.readValue<Any>(response.body!!)
            val candidates = (apiResponse as? Map<*, *>)?.get("candidates") as? List<*> ?: emptyList<Any>()
            val firstCandidate = candidates.getOrNull(0) as? Map<*, *> ?: emptyMap<Any, Any>()
            val content = firstCandidate["content"] as? Map<*, *> ?: emptyMap<Any, Any>()
            val parts = content["parts"] as? List<*> ?: emptyList<Any>()
            val firstPart = parts.getOrNull(0) as? Map<*, *> ?: emptyMap<Any, Any>()
            val output = firstPart["text"] as? String ?: "Failed to generate description"

            val cleanedOutput = output.replace("```json", "")
                .replace("```", "")
                .trim()

            val json = Json { ignoreUnknownKeys = true }
            val descriptions = json.decodeFromString<List<Descriptions>>(cleanedOutput)

            val responseDto = descriptions.map { description ->
                // Get possible venues and dates
                val possibleVenues = recommendedVenueRepo.getPossibleVenues(userModel.userId, title, description.category)
                val possibleDates = recommendedDateRepo.getPossibleDates(userModel.userId, title, description.category)

                // Check if there are any results
                val venue = possibleVenues.firstOrNull() ?: "No venue found"
                val date = possibleDates.firstOrNull() ?: "No date found"

                // Create the map
                mapOf(
                    "description" to description.description,
                    "category" to description.category,
                    "venue" to venue,
                    "date" to date
                )
            }

            ResponseEntity.ok(ResponseDto("success", System.currentTimeMillis(), responseDto))

        } else {
            ResponseEntity.ok(ResponseDto("error", System.currentTimeMillis(), "Failed to generate description"))
        }
    }
}
