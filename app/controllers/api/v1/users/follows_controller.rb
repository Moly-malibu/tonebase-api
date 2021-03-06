class Api::V1::Users::FollowsController < Api::V1::ApiController
  before_action :set_resource, only: [:destroy]

  ASSOCIATIONS = [
    [user_followships: [followed_user: :user_profile]]
  ]

  # GET /api/v1/users/:user_id/follows
  def index
    user = User.eager_load(ASSOCIATIONS).find(resource_params[:user_id])
    render_404 unless user
    render_paginated(user.user_followships)
  end

  # DELETE /api/v1/users/:user_id/follows/:followed_user_id
  def destroy
    destroy_and_render_json(@user_followship)
  end

private

  def set_resource
    @user_followship = UserFollowship.where(resource_params).first
    render_404 unless @user_followship
  end

  def resource_params
    params.permit(:user_id, :followed_user_id)
  end
end
