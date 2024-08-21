import { HttpException, HttpStatus, Injectable } from '@nestjs/common';
import { createClient } from '@supabase/supabase-js';

@Injectable()
export class UserPreferencesService {
  private supabase = createClient(
        'https://mehgbhiirnmypfgnkaud.supabase.co',
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1laGdiaGlpcm5teXBmZ25rYXVkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjQwODA0NzAsImV4cCI6MjAzOTY1NjQ3MH0.HvqoJdWdJrDefkJVjx1Y2aUsp33syv0nu4jwfGY4om0'
    );

    //initialise user preferences with initial values
    async initPreferences(userId: string, preferences: { categoryId: string, preferenceValue: number }[]): Promise<any> {

        if (!Array.isArray(preferences)) {
            
            throw new HttpException(
                {
                  status: 'error',
                  message: 'Preferences should be an array',
                  timestamp: new Date().toISOString(),
                },
                HttpStatus.BAD_REQUEST,
              );
          }
        

        const insertData = preferences.map(pref => ({
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
                    errorMsg += " Invalid userId or categoryId supplied"
                    break;
                case '23505' : {
                    //extract and return category id
                    const regex = /Key \(user_id, category_id\)=\(([^,]+), ([^)]+)\) already exists/;
                    const match = regex.exec(error.details);
                    const categoryId =  match ? match[2] : "";

                    errorMsg += ` Category ${categoryId} already has initial value for this user`
                    break;
                }
            }
            throw new HttpException(
                {
                  status: 'error',
                  message: errorMsg,
                  timestamp: new Date().toISOString(),
                },
                HttpStatus.INTERNAL_SERVER_ERROR,
              );
        }
        
        return {
            status: 'success',
            data,
            timestamp: new Date().toISOString(),
        };
      }

//   //update user preferences
//   async updatePreferences(userId: string): Promise<any> {
//     const { data, error } = await this.supabase
//       .from('user_preferences')
//       .upsert({ user_id: userId});

//     if (error) {
//       throw new Error(error.message);
//     }
//     return data;
//   }

//   async getPreferences(userId: string): Promise<any> {
//     const { data, error } = await this.supabase
//       .from('user_preferences')
//       .select('*')
//       .eq('user_id', userId);

//     if (error) {
//       throw new Error(error.message);
//     }
//     return data;
//   }
}