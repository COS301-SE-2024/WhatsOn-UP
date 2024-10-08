import { HttpException, HttpStatus, Inject, Injectable } from '@nestjs/common';
import { createClient, SupabaseClient } from '@supabase/supabase-js';
import { InitPreferencesDto } from './dto/init-preferences.dto';
import { SUPABASE_CLIENT} from 'src/supabase-provider/supabase-provider';

@Injectable()
export class UserPreferencesService {

  constructor(
    @Inject(SUPABASE_CLIENT)
    private readonly supabase: SupabaseClient
  ) {}

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
                  errorMsg += " Invalid JWT or categoryId supplied";
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
              HttpStatus.BAD_REQUEST,
            );
      }
      
      return {
          status: 'success',
          data: {message : "preferences set successfully"},
          timestamp: new Date().toISOString(),
      };
    }
}