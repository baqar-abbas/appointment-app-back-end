class Api::V1::ApplicationController < ApplicationController
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in, keys: %i[email password name])
  end
end
