# I, Cosmin Gorgovan, wrote this script on 9 March 2011. I release it into public domain. Have fun!

require 'sinatra'
require 'json'

SUCCESS_MSG = "We've saved your email. Thanks!"

ERRORS = {}
ERRORS['EMPTY_EMAIL'] = "Sorry, you have to enter an email address."
ERRORS['INVALID_EMAIL'] = "Sorry, but the email you've entered doesn't seem to be valid."
ERRORS['GENERIC_ERROR'] = "An unknown error has occured. Please try again later."

def validate_email(email)
  # validating emails with regex is stupid, so I'm only doing a minimal check
  return email.match /.+@.+\..+/
end

def save_email(email)
  email_file = File.open('./emails.txt', 'a')
  email_file.puts(email)
  email_file.close()
end

post '/save_email' do
  result = {}
  email = params[:email]

  begin
    if email == nil
      raise 'EMPTY_EMAIL'
    end

    if !validate_email(email)
      raise 'INVALID_EMAIL'
    end
    
    save_email(email)
    result['result'] = 'ok'
    result['message'] = SUCCESS_MSG
  
  rescue =>e
     
    result['result'] = 'error'
    if ERRORS.include?(e.to_s)
      result['message'] = ERRORS[e.to_s]
    else
      result['message'] = ERRORS['GENERIC_ERROR']
    end
    
  ensure
    return result.to_json
  end
end
