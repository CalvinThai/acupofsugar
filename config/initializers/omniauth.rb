OmniAuth.config.logger = Rails.logger
Rails.application.config.middleware.use OmniAuth::Builder do
 provider :facebook, ENV['477340166122034'], ENV['555b5083af0f4f19110959973c86b040']
end