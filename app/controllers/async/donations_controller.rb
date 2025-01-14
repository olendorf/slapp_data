class Async::DonationsController < ApplicationController
  def index
    authorize :async, :index?
    render json: DonationData.send(params['chart'], params['ids'])
  end
end
