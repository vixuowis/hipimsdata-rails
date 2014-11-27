class SessionsController < ApplicationController
  # skip_before_filter :verify_authenticity_token, :only => [:create, :destroy]
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      sign_in user
      redirect_to items_path+"?o=n_asc"
      # Sign the user in and redirect to the user's show page.
    else
      flash.now[:danger] = '请输入正确的邮箱 / 密码' # Not quite right! render 'new'
      render 'home/index'
      # Create an error message and re-render the signin form.
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end
end
