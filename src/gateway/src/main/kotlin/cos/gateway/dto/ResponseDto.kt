package cos.gateway.dto

data class ResponseDto(
    val status: String,
    val timestamp: Long,
    val data: Any?
)
