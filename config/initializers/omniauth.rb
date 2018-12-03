OmniAuth.config.logger = Rails.logger
Rails.application.config.middleware.use OmniAuth::Builder do
 provider :facebook, Rails.application.secrets.facebook_app_id, Rails.application.secrets.facebook_app_secret, 
 scope: 'public_profile', info_fields: 'uid,first_name,link,last_name, email'
end