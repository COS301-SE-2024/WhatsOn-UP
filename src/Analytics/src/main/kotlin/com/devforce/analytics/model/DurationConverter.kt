import jakarta.persistence.AttributeConverter
import jakarta.persistence.Converter
import java.time.Duration
import java.time.LocalTime
import java.time.format.DateTimeFormatter

@Converter(autoApply = true)
class DurationConverter : AttributeConverter<Duration, String> {

    private val formatter: DateTimeFormatter = DateTimeFormatter.ofPattern("HH:mm:ss")

    // Converts from Duration (Java) to String (Database)
    override fun convertToDatabaseColumn(attribute: Duration?): String? {
        return attribute?.let { LocalTime.ofSecondOfDay(it.seconds).format(formatter) }
    }

    // Converts from String (Database) to Duration (Java)
    override fun convertToEntityAttribute(dbData: String?): Duration? {
        return dbData?.let {
            val localTime = LocalTime.parse(it, formatter)
            Duration.ofSeconds(localTime.toSecondOfDay().toLong())
        }
    }
}
