class Api::V1::Users::SessionsController < Devise::SessionsController
  skip_before_action :verify_authenticity_token
  before_action :configure_sign_in_params, only: %i[create]
  respond_to :json

  def create
    @user = User.find_for_database_authentication(email: params[:user][:email])
    puts "Received params: #{params.inspect}"
    puts "Received sign-in request with email: #{params[:user][:email]}"

    if @user.nil?
      puts 'User not found'
      render json: { message: 'Invalid email', data: { code: 401 } }, status: :unauthorized
    elsif !@user.valid_for_authentication?
      puts 'User not valid for authentication'
      render json: { message: 'Invalid name or password', data: { code: 402 } }, status: :unauthorized
    elsif !@user.valid_password?(params[:user][:password])
      render json: { message: 'Invalid password', data: { code: 403 } }, status: :unauthorized
    elsif !@user.valid_name?(params[:user][:name])
      render json: { message: 'Invalid name', data: { code: 404 } }, status: :unauthorized
    else
      sign_in(:user, @user)
      puts 'User signed in successfully'
      jwt_token = JWT.encode({ sub: @user.id }, Rails.application.credentials.fetch(:secret_key_base))
      puts "Received JWT token: #{jwt_token}"
      render json: { message: 'Successfully Signed In', data: @user, token: jwt_token }
    end
  end

  protected

  def respond_to_on_destroy
    jwt_token = request.headers['Authorization']&.split(' ')&.last

    if jwt_token
      jwt_payload = JWT.decode(jwt_token, Rails.application.credentials.fetch(:secret_key_base)).first
      user_id = jwt_payload['sub']
      current_user = User.find_by(id: user_id)

      if current_user
        sign_out(current_user)
        render json: {
          status: {
            code: 200, message: 'User Signed Out Successfully!'
          }
        }
      else
        render json: {
          status: {
            code: 401, message: 'Cannot find user active session'
          }
        }, status: :unauthorized
      end
    else
      render json: {
        status: {
          code: 401, message: 'Unauthorized: Missing JWT token'
        }
      }, status: :unauthorized
    end
  rescue JWT::DecodeError
    render json: {
      status: {
        code: 401, message: 'Unauthorized: Invalid JWT token'
      }
    }, status: :unauthorized
  end

  def configure_sign_in_params
    params.require(:user).permit(:email, :password, :name)
  end
end
