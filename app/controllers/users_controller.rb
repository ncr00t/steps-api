class UsersController < ApplicationController
  before_action :authorize_request, except: :create
  before_action :find_user, except: %i[create index]

  # GET /users
  def index
    @users = User.all
    render json: @users
  end

  # GET /users/{name}
  def show
    render json: @user, status: :ok
  end

  # POST /users
  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user, status: :created
    else
      render json: { errors: @user.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  # PUT /users/{name}
  def update
    unless @user.update(user_params)
      render json: { errors: @user.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  # DELETE /users/{name}
  def destroy
    @user.destroy
  end

  def set_steps
    if current_user?(@user)
       @current_user.update(steps_param)
      render json: @current_user, status: :ok
    else
      render json: { errors: 'No rights to change' },
             status: :unprocessable_entity
    end

  end

  private

  def find_user
    @user = User.find_by_name(params[:name])
  rescue ActiveRecord::RecordNotFound
    render json: { errors: 'User not found' }, status: :not_found
  end

  def user_params
    defaults = {steps: Random.rand(100...500), position:  0}
    params.permit(
        :name, :email, :password, :password_confirmation
    ).reverse_merge(defaults)
  end

  def steps_param
    params.permit(:steps)
  end

  def steps_update
    if Time.now > Time.now + 2.seconds.to_i
      @current_user.update(steps: 0)
    end
  end

end
