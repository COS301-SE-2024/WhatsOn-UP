import { HttpException, Injectable } from '@nestjs/common';
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


  getHello(): string {
    return 'Hello World!';
  }

  async resetPassword(email: string, password: string, recovery_token: string){
    
    const {data, error} = await this.supabase.rpc('get_user_id_by_email', { email, recovery_token });

    console.log(data, error);

    if (error) {
      if (error.message.includes('Password already reset')) {
        throw new HttpException(
          'Password already reset',
          400
        )
      }
      throw new HttpException(
        'Failed to reset password',
        400
      )
    }


    const userId = data[0].id;


    const { data: data2, error: error2 } = await this.supabase.auth.admin.updateUserById(userId, { password });


    return {
      message: 'Password reset successfully',
      timestamp: new Date().toISOString()
    }
  }

  resetPasswordPage(): string {
    return `
      <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Reset Your Password</title>
            <style>
                body {
                    font-family: Arial, sans-serif;
                    background-color: #f4f4f4;
                    margin: 0;
                    padding: 0;
                }
                .container {
                    max-width: 600px;
                    margin: 50px auto;
                    background-color: #ffffff;
                    padding: 20px;
                    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
                    border-radius: 10px;
                }
                h1 {
                    color: #333;
                    text-align: center;
                }
                p {
                    font-size: 16px;
                    color: #555;
                    line-height: 1.6;
                }
                form {
                    margin-top: 20px;
                }
                .input-box {
                    width: 100%;
                    padding: 12px;
                    margin: 8px 0;
                    display: inline-block;
                    border: 1px solid #ccc;
                    border-radius: 4px;
                    box-sizing: border-box;
                    font-size: 16px;
                }
                .btn {
                    width: 100%;
                    background-color: #007BFF;
                    color: white;
                    padding: 14px 20px;
                    margin: 20px 0;
                    border: none;
                    border-radius: 4px;
                    cursor: pointer;
                    font-size: 18px;
                    text-align: center;
                    font-weight: bold;
                }
                .btn:hover {
                    background-color: #0056b3;
                }
                .footer {
                    margin-top: 30px;
                    text-align: center;
                    font-size: 14px;
                    color: #aaa;
                }
                #error-message {
                    color: red;
                    text-align: center;
                }
            </style>
        </head>
        <body>
            <div class="container">
                <h1>Reset Your Password</h1>
                <p>Please enter your new password below and confirm it.</p>
                <div id="error-message"></div>
                <form id="resetPasswordForm">
                    <input type="password" id="password" name="password" placeholder="Enter new password" class="input-box" required />
                    <input type="password" id="confirm-password" name="confirm-password" placeholder="Confirm new password" class="input-box" required />
                    <button type="submit" class="btn">Submit</button>
                </form>
                <div class="footer">
                    <p>&copy; 2024 Whatson-UP. All rights reserved.</p>
                </div>
            </div>
            <script>
                document.getElementById('resetPasswordForm').addEventListener('submit', async (event) => {
                    event.preventDefault();
                    const email = new URLSearchParams(window.location.search).get('email');
                    const recovery_token = new URLSearchParams(window.location.search).get('Token');
                    const password = document.getElementById('password').value;
                    const confirmPassword = document.getElementById('confirm-password').value;
                    const errorMessageDiv = document.getElementById('error-message');

                    // Validate that the passwords match
                    if (password !== confirmPassword) {
                        errorMessageDiv.textContent = 'Passwords do not match!';
                        return;
                    }

                    if (password.length < 6) {
                        errorMessageDiv.textContent = 'Password must be at least 6 characters long!';
                        return;
                    }

                    try {
                        // Call your backend endpoint to reset the password
                        const response = await fetch('http://localhost:8086/reset-password', {
                            method: 'POST',
                            headers: {
                                'Content-Type': 'application/json',
                            },
                            body: JSON.stringify({ email, password, recovery_token }),
                        });

                        const result = await response.json();

                        if (!response.ok) {
                            throw new Error(result.message || 'Failed to reset password');
                        } else {
                            errorMessageDiv.style.color = 'green';
                            errorMessageDiv.textContent = 'Password updated successfully!';
                        }
                    } catch (error) {
                        errorMessageDiv.style.color = 'red';
                        errorMessageDiv.textContent = "Error: " + error.message;
                    }
                });
            </script>
        </body>
        </html>

    `;
  }
  
}
