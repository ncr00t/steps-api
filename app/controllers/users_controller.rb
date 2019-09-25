class UsersController < ApplicationController
  before_action :authorize_request, except: :create
  before_action :find_user, except: %i[create index]

  # GET /users
  def index
    @users = User.all
    unless @users.blank?
      @users = User.order(steps: :desc)
      @users = @users.each_with_index { |user, index| user[:position] = index + 1 }
      users = @users.limit(params[:amount]) if params[:amount]
      users_json = users.as_json
      unless params[:amount].blank?
        unless users.include?(@current_user)
          users_json.pop
          users_json << @users.find { |user| user if current_user?(user) }
        end
      end
      users_json = @users.as_json if params[:amount].blank?
      render json: users_json.each_with_index {|user, index| user[:position] = index + 1 unless current_user?(user)}
    end
  end

  # GET /users/{name}
  def show
    unless @user
      render text:"page not found", status: 404
    end
  end

  # POST /users
  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user, status: :created
    else
      render_error(@user.errors.full_messages, :unprocessable_entity)
    end
  end

  # PUT /users/{name}
  def update
    return if @user.update(user_params)
    render_error(@user.errors.full_messages,:unprocessable_entity)
  end

  # DELETE /users/{name}
  def destroy
    @user.destroy
  end

  def set_steps
    if current_user?(@user)
      @user.update(steps_param)
      render json: @user
    else
      render_error('No rights to change', :unprocessable_entity)
    end
  end

  private

  def find_user
    @user = User.find_by_name(params[:name])
  rescue ActiveRecord::RecordNotFound
    render_error('User not found', :not_found)
  end

  def user_params
    params.permit(
        :name, :email, :password, :password_confirmation
    )
  end

  def steps_param
    params.permit(:steps)
  end
end
