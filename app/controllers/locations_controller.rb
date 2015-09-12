class LocationsController < ApplicationController
   # before_action :location_params
  def set_passenger_location
    @passenger = current_passenger
    if @passenger.location.nil?
      @passenger.create_location(location_params)
    else
      @passenger.location.update_attributes(location_params)
    end
    render json: @passenger.location
  end

  def set_driver_location
    @driver = current_driver
    if @driver.location.nil?
      @driver.create_location(location_params)
    else
      @driver.location.update_attributes(location_params)
    end
    render json: @driver.location
  end

  def get_passenger_location
    @passenger = current_passenger
    render json: @passenger.location
  end

  def get_driver_location
    @driver = current_driver
    render json: @driver.location
  end

  def get_drivers_locations
    sql = "SELECT locations.lat, locations.lng FROM drivers inner join locations on drivers.id = locations.locatable_id AND locatable_type = 'Driver'"
    query = ActiveRecord::Base.connection.execute(sql)
    @drivers_locations = {locations: query.values}
    render json: @drivers_locations
  end

  private

  def location_params
    params.permit(:lat, :lng)
  end

end
