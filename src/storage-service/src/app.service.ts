import { HttpException, HttpStatus, Injectable } from '@nestjs/common';
import { SupabaseClient } from '@supabase/supabase-js';
import { createClient } from '@supabase/supabase-js';

@Injectable()
export class AppService {
  private supabase: SupabaseClient;

  constructor() {
    this.supabase = createClient(
      process.env.SUPABASE_URL,
      process.env.SUPABASE_KEY
    );
  }
  generateRandomString(length) {
    let randomString = '';
    while (randomString.length < length) {
      randomString += Math.random().toString(36).substring(2, 2 + length);
    }
    return randomString.substring(0, length);
  }

  async uploadProfile(file: any, token: string){
    const filename = this.generateRandomString(26) + file.originalname.substring(file.originalname.lastIndexOf('.'));
    const { data: profile, error: profile_error } = await this.supabase
      .from('profiles')
      .select('media_name')
      .eq('user_id', token);

    if (profile_error) {
      throw new HttpException(
        {
          status: 'error',
          message: 'Error fetching profile',
          timestamp: new Date().toISOString(),
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }

    if (profile.length == 0) {
      throw new HttpException(
        {
          status: 'error',
          message: 'User not found',
          timestamp: new Date().toISOString(),
        },
        HttpStatus.NOT_FOUND,
      );
    }

    if (profile[0].media_name) {
      const { data: file_info, error: file_error } = await this.supabase.storage
        .from('storage')
        .remove([profile[0].media_name]);

      if (file_error) {
        throw new HttpException(
          {
            status: 'error',
            message: 'Error deleting old file',
            timestamp: new Date().toISOString(),
          },
          HttpStatus.INTERNAL_SERVER_ERROR,
        );
      }
    }



    const { data: file_info, error: file_error } = await this.supabase.storage
      .from('storage')
      .upload(filename, file.buffer);

    if (file_error) {
      throw new HttpException(
        {
          status: 'error',
          message: 'Error uploading file',
          timestamp: new Date().toISOString(),
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }

    const url = await this.supabase.storage
    .from('storage')
    .getPublicUrl(filename);

    const { data: profileData, error: profileError } = await this.supabase
      .from('profiles')
      .update({ profile_image: url.data.publicUrl, media_name: filename })
      .eq('user_id', token);

    if (profileError) {
      throw new HttpException(
        {
          status: 'error',
          message: 'Error updating profile',
          timestamp: new Date().toISOString(),
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }

    return {
      media_name: filename,
      media_link: url.data.publicUrl
    }
  }

  async uploadEventMedia(file: any, event_id: string){
    const filename = this.generateRandomString(50) + file.originalname.substring(file.originalname.lastIndexOf('.'));
    const { data: fileInfo, error: fileError } = await this.supabase.storage
      .from('storage')
      .upload(filename, file.buffer);


    if (fileError) {
      throw new HttpException(
        {
          status: 'error',
          message: `Error uploading file ${file.originalname}`,
          timestamp: new Date().toISOString(),
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }

    const url = this.supabase
      .storage
      .from('storage')
      .getPublicUrl(filename);

    if (!url.data.publicUrl) {
      throw new HttpException(
        {
          status: 'error',
          message: `Error getting public URL for file ${file.originalname}`,
          timestamp: new Date().toISOString(),
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }

    const { data: eventMedia, error: eventMediaError } = await this.supabase
      .from('event_media')
      .insert([
        {
          event_id: event_id,
          media_name: filename,
          media_link: url.data.publicUrl,
        }
      ]);


    if (eventMediaError) {
      throw new HttpException(
        {
          status: 'error',
          message: `Error inserting media record for file ${file.originalname}`,
          timestamp: new Date().toISOString(),
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }

    return {
      media_name: filename,
      media_link: url.data.publicUrl
    }
  }

  async deleteMedia(media_name: string): Promise<string> {
    try {
      // Remove the file from storage
      const { error: storageError } = await this.supabase.storage
        .from('storage')
        .remove([media_name]);

      if (storageError) {
        throw new HttpException(
          {
            status: 'error',
            message: `Error deleting file from storage: ${storageError.message}`,
            timestamp: new Date().toISOString(),
          },
          HttpStatus.INTERNAL_SERVER_ERROR,
        );
      }

      // Delete the record from event_media table
      const { error: dbError } = await this.supabase
        .from('event_media')
        .delete()
        .eq('media_name', media_name);

      if (dbError) {
        throw new HttpException(
          {
            status: 'error',
            message: `Error deleting record from event_media: ${dbError.message}`,
            timestamp: new Date().toISOString(),
          },
          HttpStatus.INTERNAL_SERVER_ERROR,
        );
      }

      return 'File deleted successfully';
    } catch (error) {
      throw new HttpException(
        {
          status: 'error',
          message: `Error deleting media: ${error.message}`,
          timestamp: new Date().toISOString(),
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  async uploadProof(file: any, application_id: string) {
    const filename = this.generateRandomString(50) + file.originalname.substring(file.originalname.lastIndexOf('.'));
    
    // Upload file to storage
    const { data: fileInfo, error: fileError } = await this.supabase.storage
      .from('storage')
      .upload(filename, file.buffer);
  
    if (fileError) {
      throw new HttpException(
        {
          status: 'error',
          message: `Error uploading file ${file.originalname}: ${fileError.message}`,
          timestamp: new Date().toISOString(),
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  
    // Get public URL for the uploaded file
    const { data: urlData} = this.supabase
      .storage
      .from('storage')
      .getPublicUrl(filename);
  
    if (!urlData.publicUrl) {
      throw new HttpException(
        {
          status: 'error',
          message: `Error getting public URL for file ${file.originalname}: 'No public URL returned'}`,
          timestamp: new Date().toISOString(),
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  
    // Update host_applications table with the URL and filename
    const { data: eventMedia, error: eventMediaError } = await this.supabase
      .from('host_applications')
      .update({ proof_url: urlData.publicUrl, proof_name: filename })
      .eq('application_id', application_id);
  
    if (eventMediaError) {
      throw new HttpException(
        {
          status: 'error',
          message: `Error updating record for file ${file.originalname}: ${eventMediaError.message}`,
          timestamp: new Date().toISOString(),
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  
    return {
      media_name: filename,
      media_link: urlData.publicUrl
    };
  }
  
    
}


