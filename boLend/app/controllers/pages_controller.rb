class PagesController < ApplicationController
  include HighVoltage::StaticPage
  layout :false
  skip_before_action :require_login
end
