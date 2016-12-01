class DepartureController < ApplicationController
  # Run this on http://localhost:3000/welcome/index
  def index
    # ----- Task 1. Get all route names -----
    if current_user
      @pref = Preference.where(user_id: current_user.id)
    end

    # Time.zone.now.strftime("%Y%m%d")
    byebug

    routes = getRoutes
    @route_values = []
    routes.each do |route|
      name_and_id = []
      name_and_id += [route['long_name'], route['id']]
      @route_values << name_and_id
    end

    # ----- Task 2. Get stops from route and date -----

    # ----- Task 3. Get stop_times from toStop, fromStop, date, and time -----

  end

  def getUserDateAndRoute
    @userSelectedDate = params['start_date']['year'] + params['start_date']['month'] + params['start_date']['day']
    @userSelectedRoute = params['select_route']
    # redirect_to controller: 'welcome', action: 'index', param1: @userSelectedRoute
    @routeVariants = getRouteVariants(@userSelectedDate, @userSelectedRoute)
    render 'route-variant'
  end

  def getRouteVariant
    @userSelectedDate = params['select_date']
    @userSelectedRoute = params['select_route']
    @userSelectedRouteVariant = params['select_route_variant']
    stops = getStops(getTrips(@userSelectedDate, @userSelectedRoute, @userSelectedRouteVariant)[0])
    @stop_values = []
    stops.each do |stop|
      name_and_id = []
      name_and_id += [stop['name'], stop['id']]
      @stop_values << name_and_id
    end
    render 'from-to-stops'
  end

  def getFromToStops
    @userSelectedDate = params['select_date']
    @userSelectedRoute = params['select_route']
    @userSelectedRouteVariant = params['select_route_variant']
    @userSelectedToStop = params['select_to_stop']
    @userSelectedFromStop = params['select_from_stop']
    @arrivalTimes = getArrivalTimes(@userSelectedDate, @userSelectedRoute, @userSelectedRouteVariant, @userSelectedToStop, @userSelectedFromStop)
    @departureTimes = getDepartureTimes(@userSelectedDate, @userSelectedRoute, @userSelectedRouteVariant, @userSelectedToStop, @userSelectedFromStop)

    @allTrainsNotDeparted, @allTrains = getFirstThreeTrains(@arrivalTimes, @userSelectedDate)
    render 'arrival-times'
  end

  # helper functions
  def getRoutes
    routeNames = []
    url = 'https://getgo-api.herokuapp.com/agencies/GO/routes/'
    response = HTTParty.get(url)
    routesHash = JSON.parse(response.body)
    routesArray = routesHash['routes']

    puts "---------- Task 1: Route names ----------"
    routesArray.each do |route|
      routeNames << route
    end
    return routeNames
  end

  def getRouteVariants (date, route_id)
    url = 'https://getgo-api.herokuapp.com/routes/' + route_id + '/trips?date=' + date
    # https://getgo-api.herokuapp.com/routes/258-MI/trips?date=20161202
    response = HTTParty.get(url)
    tripsHash = JSON.parse(response.body)
    tripsArray = tripsHash['trips']

    tripsArrayRouteVariants = []
    tripsArray.each do |trip|
      tripsArrayRouteVariants << trip['route_variant']
    end

    return tripsArrayRouteVariants.uniq
  end

  def getTrips (date, route_id, route_variant)
    #  First, get all the trips
    url = 'https://getgo-api.herokuapp.com/routes/' + route_id + '/trips?date=' + date
    # https://getgo-api.herokuapp.com/routes/258-MI/trips?date=20161202
    response = HTTParty.get(url)
    tripsHash = JSON.parse(response.body)
    tripsArray = tripsHash['trips']

    tripsWithCorrectVariant = tripsArray.find_all {
      |trip| trip['route_variant'] == route_variant
    }

    puts "---------- Task 2a: Trips under the specified route variant ----------"
    tripsWithCorrectVariant.each do |trip|
      print "Trip_id: ", trip['id'], ",  Route Variant: ", + trip['route_variant'] + ",  Direction: " + trip['direction_id'] + "\n"
    end
    return tripsWithCorrectVariant
  end

  def getStops (trip)
    # Second, from the first trip, get the stops
    # ASSUMPTION: any given trip for the same route variant always returns the same stops
    # so we can just pick any trip (the first trip) from the route variant to obtain the stops
    url = 'https://getgo-api.herokuapp.com/' + '/trips/' + trip['id'] + '/stops'
    # https://getgo-api.herokuapp.com/trips/6179-Fri-21865/stops
    response = HTTParty.get(url)
    stopsHash = JSON.parse(response.body)
    stopsArray = stopsHash['stops']

    stopNames = []
    puts "---------- Task 2b: Stops names under the specified route variant ----------"
    puts stopNames
    stopsArray.each do |stop|
      stopNames << stop
    end

    return stopNames
    # TODO: order the stop names in order of stop sequence (need stop_times table for this)
  end

  def getDirection (trip, toStop, fromStop)

    url = 'https://getgo-api.herokuapp.com/' + 'trips/' + trip['id']
    # https://getgo-api.herokuapp.com/trips/6239-Fri-167/stop_times
    response = HTTParty.get(url)
    stopTimesHash = JSON.parse(response.body)
    stopTimesArray = stopTimesHash['stops']

    # stopTimesHash['trip']['direction_id']  # "1"
    # stopTimesHash['trip']['stops'].class  # array
    # stopTimesHash['trip']['stops'].find { |s| s['id'] == 'UN' }  # {"id"=>"UN", "name"=>"Union Station", ...}
    # stopTimesHash['trip']['stop_times'].class  # array
    toStop_sequence = stopTimesHash['trip']['stop_times'].find { |st| st['stop_id'] == toStop}['stop_sequence'] #1
    fromStop_sequence = stopTimesHash['trip']['stop_times'].find { |st| st['stop_id'] == fromStop}['stop_sequence'] #6


    if fromStop_sequence < toStop_sequence
       direction_id = stopTimesHash['trip']['direction_id'].to_i
    else
       direction_id = 1 - stopTimesHash['trip']['direction_id'].to_i # swapping 0 and 1
    end

    return direction_id
  end

  def getArrivalTimes (date, route_id, route_variant, toStop, fromStop)

    tripsArray = getTrips(date, route_id, route_variant)

    direction_id = getDirection(tripsArray[0], toStop, fromStop)

    # get the stop_times from these trips

    puts "---------- Task 3d: direction ----------"
    puts "direction_id = " + direction_id.to_s

    # Second, get all the trips with the correct direction_id
    tripsWithCorrectDirection = tripsArray.find_all {
      |trip| trip['direction_id'] == direction_id.to_s
    }

    puts "---------- Task 3d: trips with correct direction_id ----------"
    # puts tripsWithCorrectDirection

    departureTimes = [];
    arrivalTimes = []
    # Third, for each trip, get the departure_time for the desired stop (by referencing stop_id)
    tripsWithCorrectDirection.each do |trip|
      url = 'https://getgo-api.herokuapp.com/' + '/trips/' + trip['id'] + '/stop_times'
      # https://getgo-api.herokuapp.com/trips/6239-Fri-167/stop_times
      response = HTTParty.get(url)
      stopTimesHash = JSON.parse(response.body)
      stopTimesArray = stopTimesHash['stop_times']

      departureTimes << stopTimesArray.find { |st| st['stop_id'] == fromStop}['departure_time']
    end
    return departureTimes

  end

  def getDepartureTimes (date, route_id, route_variant, toStop, fromStop)
    tripsArray = getTrips(date, route_id, route_variant)

    direction_id = getDirection(tripsArray[0], toStop, fromStop)
    # get the stop_times from these trips
    puts "---------- Task 3d: direction ----------"
    puts "direction_id = " + direction_id.to_s
    # Second, get all the trips with the correct direction_id
    tripsWithCorrectDirection = tripsArray.find_all {
      |trip| trip['direction_id'] == direction_id.to_s
    }
    puts "---------- Task 3d: trips with correct direction_id ----------"
    # puts tripsWithCorrectDirection
    arrivalTimes = [];
    tripId = [];
    # Third, for each trip, get the departure_time for the desired stop (by referencing stop_id)
    tripsWithCorrectDirection.each do |trip|
        url = 'https://getgo-api.herokuapp.com/' + '/trips/' + trip['id'] + '/stop_times'
      # https://getgo-api.herokuapp.com/trips/6239-Fri-167/stop_times
      response = HTTParty.get(url)
      stopTimesHash = JSON.parse(response.body)
      stopTimesArray = stopTimesHash['stop_times']
      tripId << trip['id']
      arrivalTimes << stopTimesArray.find { |st| st['stop_id'] == toStop}['arrival_time']
    end
    puts "---------- Task dc: arrivalTimes times ----------"
    puts arrivalTimes
    puts tripId
    return arrivalTimes
  end

  def getFirstThreeTrains(arrivalTimes, userSelectedDate)

    Time.zone = 'Eastern Time (US & Canada)'

    allTrains = []
    allTrainsNotDeparted = []

    arrivalTimes.each do |arrive|

      arriveSplit = arrive.split(":")  # "21:00:00" -> ["21", "00", "00"]
      if (arriveSplit[0].to_i >= 24)
        arrive24 = []
        arrive24[0] = (arriveSplit[0].to_i - 24).to_s
        arrive24[1] = arriveSplit[1]
        arrive24[2] = arriveSplit[2]
        arrive24join = arrive24.join(":")
        arriveDT = Time.zone.strptime(arrive24join, "%H:%M:%S") + 1.days
      else
        arriveDT = Time.zone.strptime(arrive, "%H:%M:%S")
      end

      # arriveDT = (DateTime.strptime(arrive, "%H:%M:%S") + 5.hours).in_time_zone("Eastern Time (US & Canada)")
      allTrains << arriveDT
      if arriveDT > Time.zone.now
        allTrainsNotDeparted << arriveDT
      end
    end

    return allTrainsNotDeparted.reverse, allTrains.reverse

    # Time.zone.now
    # Time.zone.strptime("21:00:00", "%H:%M:%S")
  end
end
