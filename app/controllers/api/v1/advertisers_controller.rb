class Api::V1::AdvertisersController < Api::V1::ApiController
  before_action :set_advertiser, only: [:show, :update, :destroy]

  # GET /api/v1/advertisers
  def index
    advertisers = Advertiser.all
    render_paginated(advertisers)
  end

  # GET /api/v1/advertisers/:id
  def show
  end

  # POST /api/v1/advertisers
  def create
    advertiser = Advertiser.new(advertiser_params)
    save_and_render_json(advertiser)
  end

  # PUT /api/v1/advertisers/:id
  def update
    update_and_render_json(@advertiser, advertiser_params)
  end

  # DELETE /api/v1/advertisers/:id
  def destroy
    destroy_and_render_json(@advertiser)
  end

private

  def set_advertiser
    @advertiser = Advertiser.find(params[:id])
  end

  def advertiser_params
    params.require(:advertiser).permit(:name, :description, :url)
  end
end
