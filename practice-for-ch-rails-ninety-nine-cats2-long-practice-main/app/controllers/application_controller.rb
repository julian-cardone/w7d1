class ApplicationController < ActionController::Base
    helper_method :current_user

    def login!(user)
        session[:session_token] = user.reset_session_token!
    end

    def current_user
        @current_user ||= User.find_by(session_token: session[:session_token])
    end

    def require_logged_out
        if current_user
            redirect_to cats_url
        end
    end

    def require_logged_in
        unless current_user
            redirect_to new_session_url
        end
    end

    def ensure_owner
        @cat = Cat.find_by(id: params[:id])
        if owner_of_cat?.nil?
          redirect_to cat_url(@cat)
        end
    end

    def owner_of_cat?
        !!current_user.cats.find_by(id: @cat.id)
    end

end
