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
    p "------------------------------"
    p "in single drivers location"
    @driver = current_driver
    render json: @driver.location
  end

  def get_drivers_locations
    p "---------------------------"
    p "in get_drivers_locations action"
    sql = "SELECT locations.lat, locations.lng FROM drivers inner join locations on drivers.id = locations.locatable_id WHERE locatable_type = 'Driver' AND drivers.active = true"
    query = ActiveRecord::Base.connection.execute(sql)
    p "this is the query values: #{query.values}"
    if query.values == []
      p " nothing rendered --------------------------------"
      render nothing: true
    else
      p "values rendered +++++++++++++++++++++++++++++++"
      @drivers_locations = {locations: query.values}
      render json: @drivers_locations
    end
  end

  private

  def location_params
    params.permit(:lat, :lng)
  end

end
