class UsersController < ApplicationController
  before_action :authorize_request, except: :create
  before_action :find_user, except: %i[create index]

  # GET /users
  def index
    @users = User.all
    unless @users.blank?
      amount = (params[:amount].blank?) ? @users.size
                                        : params[:amount].to_i
      top_users = sort_users_by_desc.take(amount)
      top_users_with_current = top_users.include?(@current_user) ? top_users :
                                                                   top_users.take(amount - 1)
                                                                            .push(@current_user)
      render json: top_users_with_current, status: :ok
    end
  end

  # GET /users/{name}
  def show
    render json: @user, status: :ok
  end

  # POST /users
  def create
    @user = User.new(user_params)
    if @user.save
      sort_users_by_desc
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
    @users = User.all
    defaults = {steps: Random.rand(100...5000),
                position: (@users.blank?) ? 1 : 0}
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

  def sort_users_by_desc
    @users = User.all
    unless @users.blank?
      sorted_users = @users.sort { |current_user, next_user |
        next_user[:steps] <=> current_user[:steps]
      }
      assign_user_positions(sorted_users)
    end
  end

  def assign_user_positions(sorted_users)
    position = 0
    sorted_users.each do |user|
      position += 1
      user[:position] = position
      update_user_position(user)
    end
    sorted_users
  end

  def update_user_position(user)
    user.update(position: user[:position])
  end
end
