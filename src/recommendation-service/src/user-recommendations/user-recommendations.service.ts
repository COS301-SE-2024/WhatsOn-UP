import { Inject, Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { EventEntity } from './entities/event.entity';
import { EventDto } from './dto/event.dto';
import { SupabaseClient } from '@supabase/supabase-js';
import { SUPABASE_CLIENT } from 'src/supabase-provider/supabase-provider';

@Injectable()
export class UserRecommendationsService {
  constructor(
    @Inject(SUPABASE_CLIENT)
    private readonly supabase: SupabaseClient,
  ) {}

  async getRecommendedEvents(userID: string): Promise<any> {

    // Pull user preference values per category
    const { data: preferenceValues, error: prefError } = await this.supabase
    .rpc("get_user_category_preferences", { userid: userID });

    if (prefError) {
    throw new Error(`Error fetching user category preferences: ${prefError.message}`);
    }

    console.log(preferenceValues);

    // Get all events
    const { data: events, error: catErr} = await this.supabase
    .rpc("get_all_events_with_categories");

    if (catErr) {
    throw new Error(`Error fetching all events: ${catErr.message}`);
    }

    const preferenceMap = new Map<string, { interaction: number, survey: number }>();
    preferenceValues.forEach((pref) => {
    preferenceMap.set(pref.category, {
      interaction: pref.interaction_preference_value,
      survey: pref.survey_preference_value
    });
    });

    // Calculate predicted ratings
    const predictedRatings = events.map(event => {
    const category = event.category;
    const preferences = preferenceMap.get(category);

    if (!preferences) {
      console.warn(`No preferences found for category: ${category}`);
      return {
        event,
        rating: 0, // Default rating if no preferences are found
      };
    }

    const interactionPreferenceValue = preferences.interaction || 0;
    const surveyPreferenceValue = preferences.survey || 0;

    const binaryDigit = 1; // always 1
    const rating = (interactionPreferenceValue + surveyPreferenceValue) * binaryDigit;

    console.log(`Event: ${event}, Category: ${category}, Rating: ${rating}`);

    return {
      event,
      rating,
    };
    });

    // Sort predicted ratings in descending order
    predictedRatings.sort((event1, event2) => event2.rating - event1.rating);

    console.log('Predicted Ratings:', predictedRatings);

    return {
    status: 'success',
    data: { message: predictedRatings },
    timestamp: new Date().toISOString(),
    };

  }

  private toDto(event: EventEntity): EventDto {
    return {
      eventId: event.event_id,
      title: event.title,
      description: event.description,
      metadata: event.metadata,
      startDateTime: event.start_date_time,
      endDateTime: event.end_date_time,
      maxAttendees: event.max_attendees,
      isPrivate: event.is_private,
      venueId: event.venue_id,
      availableSlots: event.available_slots,
    };
  }
}
