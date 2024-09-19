import { Inject, Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { EventEntity } from './entities/event.entity';
import { EventDto } from './dto/event.dto';
import { SupabaseClient } from '@supabase/supabase-js';
import { SUPABASE_CLIENT } from 'src/supabase-provider/supabase-provider';
import { UnauthorizedException } from '@nestjs/common';
import * as jwt from 'jsonwebtoken';

const API_KEY = ''
const axios = require('axios');
// const { computeOffset } = require ('spherical-geometry-js');

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
    let predictedRatings: {
        event: String,
        fitness: number 
    }[] = events.map(event => {
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
      const rating = (interactionPreferenceValue * surveyPreferenceValue) * binaryDigit; //fitness 

      console.log(`Event: ${event}, Category: ${category}, Rating: ${rating}`);

      return {
        event,
        rating,
      };
    });

    // Sort predicted ratings in descending order
    predictedRatings.sort((event1, event2) => event2.fitness - event1.fitness);

    console.log('Predicted Ratings:', predictedRatings);

    return {
    status: 'success',
    data: { message: this.selection(predictedRatings) },
    timestamp: new Date().toISOString(),
    };

  }

  selection(events: {
    event: String,
    fitness: number 
  }[])
  {
    return events;
  }

  // function uniqueRouletteWheelSelection(predictedRatings, numSelections) {
  //   let selectedEvents = [];
  
  //   // Check if numSelections exceeds the available events
  //   if (numSelections > predictedRatings.length) {
  //     console.warn('Requested more selections than available events. Returning all events.');
  //     numSelections = predictedRatings.length; // Adjust to select all available events
  //   }
  
  //   for (let i = 0; i < numSelections; i++) {
  //     // Calculate total fitness for current ratings
  //     const totalFitness = predictedRatings.reduce((sum, { fitness }) => sum + fitness, 0);
  
  //     if (totalFitness === 0) {
  //       console.warn('All fitness values are zero, returning random event.');
  //       const randomEvent = predictedRatings[Math.floor(Math.random() * predictedRatings.length)].event;
  //       selectedEvents.push(randomEvent);
  //       break;
  //     }
  
  //     // Generate a random number between 0 and totalFitness
  //     const randomValue = Math.random() * totalFitness;
  
  //     let runningSum = 0;
  //     for (let j = 0; j < predictedRatings.length; j++) {
  //       const { event, fitness } = predictedRatings[j];
  //       runningSum += fitness;
  
  //       if (runningSum >= randomValue) {
  //         selectedEvents.push(event);  // Select the event
  
  //         // Remove the selected event to prevent it from being selected again
  //         predictedRatings.splice(j, 1);
  //         break;
  //       }
  //     }
  //   }
  
  //   return selectedEvents;
  // }
  

  // updates LatLng of each building
  // shouldn't need to be called often -- only as buildings are inserted into the db
  async updateBuildingLocations() : Promise<void>{
    let {data: buildings, error} = await this.supabase
      .from('buildings')
      .select('name');

    if(error){
      console.log(error);
      // throw Error(error.message);
    }

    console.log(`buildings retrieved from db: \n ${JSON.stringify(buildings, null, 2)}`);
    let buildingCoordinates: {
      name: String,
      coordinates : {
        latitude : String,
        longitude : String
      }
    }[] = [];

    for(let building of buildings){
      let location = await this.geocode(building.name);
      buildingCoordinates.push({
        name: building.name,
        coordinates: location
      })
    }

    // update coordinate values in database 
    for(let b of buildingCoordinates){

      let latLngString =  
       (b.coordinates != null) 
        ? `${b.coordinates.latitude},${b.coordinates.longitude}`
        : b.coordinates;

      await this.supabase
        .from('buildings')
        .update({location: latLngString})
        .eq('name',b.name)
     
    }    
  }

  async geocode(searchText) {
    const headers = {
      'Content-Type': 'application/json',
      'X-Goog-Api-Key': API_KEY,
      'X-Goog-FieldMask': 'places.formattedAddress,places.location',
    };

    console.log(`Getting result for building ${searchText}...`);
    let body = {
      "textQuery": `${searchText}`,
      "locationBias": {
        "circle": {
              "center": {
              "latitude": -25.7545492,
              "longitude": 28.2314676
            },
            "radius": 5000.0
          }
        }
      }

      let response = await axios.post(
        `https://places.googleapis.com/v1/places:searchText`,
        body,
        {
          headers: headers
        }
      );

      if (response.data && response.data.places && response.data.places.length > 0) {
        let coordinates = response.data.places[0].location;
        console.log(coordinates);
        return coordinates;
      } else {
        console.log("No places found for this query.");
        return null;
      }
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