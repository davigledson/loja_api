class Api::TestController < ApplicationController
  def index
    render json: { message: "Olá, Rails API!" }
  end
end
