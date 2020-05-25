class UsersController < ApiController
  def auth
    #Rails.cache.clear
    auth_user = User.auth(params[:user][:email], params[:user][:password])
    session[:api_key] = auth_user[:api_key] if auth_user[:success]
    render json: {success: auth_user[:success], text_error: auth_user[:text_error]}
  end

  def registration
    Rails.cache.clear rescue nil
    auth_user = User.registration(params.merge({api_key: current_api_key}))
    session[:api_key] = auth_user[:api_key] if auth_user[:success]
    render json: {success: auth_user[:success], text_error: auth_user[:text_error]}
  end

  def sign_out
    session[:api_key] = nil
    Rails.cache.clear rescue nil
    redirect_to "/"
  end
end
