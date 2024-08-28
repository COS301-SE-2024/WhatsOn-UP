import { HttpException, HttpStatus, Injectable } from '@nestjs/common';
import { createClient } from '@supabase/supabase-js';
import { InitPreferencesDto } from './dto/init-preferences.dto';

@Injectable()
export class UserPreferencesService {
  private supabase = createClient(
        'https://mehgbhiirnmypfgnkaud.supabase.co',
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1laGdiaGlpcm5teXBmZ25rYXVkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjQwODA0NzAsImV4cCI6MjAzOTY1NjQ3MH0.HvqoJdWdJrDefkJVjx1Y2aUsp33syv0nu4jwfGY4om0'
    );

  //initialise user preferences with initial values
  async initPreferences(userId: string, prefs: InitPreferencesDto): Promise<any> {

      if (!Array.isArray(prefs.preferences)) {
          
          throw new HttpException(
              {
                status: 'error',
                message: 'Preferences should be an array',
                timestamp: new Date().toISOString(),
              },
              HttpStatus.BAD_REQUEST,
            );
        }
      

      const insertData = prefs.preferences.map(pref => ({
        user_id: userId,
        category_id: pref.categoryId,
        survey_preference_value: pref.preferenceValue,
      }));
  
      const { data, error } = await this.supabase
        .from('user_category_preferences')
        .insert(insertData);
  
      if (error) {
          let errorMsg = "Error initializing user preferences.";

          console.log(error);
          switch (error.code) {
              case '23503' : 
                  errorMsg += " Invalid userId or categoryId supplied";
                  break;
              case '23505' : {
                  //extract and return category id
                  const regex = /Key \(user_id, category_id\)=\(([^,]+), ([^)]+)\) already exists/;
                  const match = regex.exec(error.details);
                  const categoryId =  match ? match[2] : "";

                  errorMsg += ` Category ${categoryId} already has initial value for this user`;
                  break;
              }
              case '22P02' : 
                  errorMsg += ` ${error.message}`;
                  break;
          }
          throw new HttpException(
              {
                status: 'error',
                message: errorMsg,
                hint: error.hint,
                timestamp: new Date().toISOString(),
              },
              HttpStatus.INTERNAL_SERVER_ERROR,
            );
      }
      
      return {
          status: 'success',
          data: {message : "preferences set successfully"},
          timestamp: new Date().toISOString(),
      };
    }

  async updatePreferences(userId: string) {
    // get all categories 
      let categories = await this.supabase.from(
        'category'
      ).select(
        'id,category'
      );
    // get users questionnaire prefs for each category -- 0 where there is none

    let categoryList = categories.data;
    console.log(categories);
    
    // calculate number of saved events a user has for each category
    const catCounts = await this.supabase
    .rpc('get_saved_event_categories_count', { userid: userId });

    let categoryCountsList = catCounts.data;

    if (catCounts!= null && catCounts.error) {
      console.error('Error:', catCounts.error);
    } else {
      console.log('Data:', catCounts.data);
    }

    const totalCount = categoryCountsList.reduce((sum, item) => sum + item.count, 0);
    let insertionData = categoryCountsList.map(item => {
      const categoryObj = categoryList.find(c => c.category === item.category);

      if (!categoryObj) {
        throw new Error(`Category '${item.category}' not found in the categories array`);
      }

      // Calculate the proportion and multiply by 5 (interaction_preference_value)
      const interaction_preference_value = (item.count / totalCount) * 5;

      return {
        category_id: categoryObj.id,
        interaction_preference_value: interaction_preference_value
      };
    });

    console.log(insertionData);

      // store these updated values in the database (they may not yet be in the table)
        //if not in the table, add to the table with 0 for survey_preference_value
      
    // calculate weighted preference value proportion 
      //-- just to see final preference value (to be in the user vector)

  }
}