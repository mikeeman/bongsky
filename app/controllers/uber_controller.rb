require 'uri'
require 'net/http'
require 'net/https'
require 'json'

class UberController < ApplicationController
  
  def send(variable)

    if(params.has_key?(:uberPickup))
      uberPickup = params[:uberPickup]
    end

    if(params.has_key?(:uberPickupOther))
      uberPickupOther = params[:uberPickupOther]
      #Get longitude and latitude
      #if(params[:uberPickupOther] == "attending")
      #  @attending = true
      #else
      #  @attending = false
      #end
    end

    if(params.has_key?(:uberDestination))
      uberDestination = params[:uberDestination]
    end

    if(params.has_key?(:uberDestinationOther))
      uberDestinationOther = params[:uberDestinationOther]
      #Get longitude and latitude
      #if(params[:uberPickupOther] == "attending")
      #  @attending = true
      #else
      #  @attending = false
      #end
    end

    #Get latitude and longitude of pickup
    case uberPickup
    when "1"
      #Ceremony 43.8824525,-78.8565288
      uberPickupLat = 43.8824525
      uberPickupLon = -78.8565288
    when "2"
      #Reception 44.0434385,-79.0188748
      uberPickupLat = 44.0434385
      uberPickupLon = -79.0188748
    when "3"
      #Accomodations 43.8683646,-78.9346927
      uberPickupLat = 43.8683646
      uberPickupLon = -78.9346927
    when "4"
      #Other - lookup place in google places
      if (params.has_key?(:uberPickupOther) && !params[:uberPickupOther].blank?)
        #puts uberPickupOther
        locpickup = Uberlocation.new(:address => uberPickupOther)
        #puts locpickup
        #puts locpickup.address
        locpickup.geocode
        #puts locpickup.latitude
        #puts locpickup.longitude
        uberPickupLat = locpickup.latitude
        uberPickupLon = locpickup.longitude
      else
        redirect_to '/pages/uber/#error', :flash => { :notice => "Please specify a Destination location." } and return
      end
    else
      redirect_to '/pages/uber/#error', :flash => { :notice => "Please specify a Pickup location." } and return
    end

    #Get latitude and longitude of destination
    case uberDestination
    when "1"
      #Ceremony 43.8824525,-78.8565288
      uberDestinationLat = 43.8824525
      uberDestinationLon = -78.8565288
    when "2"
      #Reception 44.0434385,-79.0188748
      uberDestinationLat = 44.0434385
      uberDestinationLon = -79.0188748
    when "3"
      #Accomodations 43.8683646,-78.9346927
      uberDestinationLat = 43.8683646
      uberDestinationLon = -78.9346927
    when "4"
      #Other - lookup place in google places
      if (params.has_key?(:uberDestinationOther) && !params[:uberDestinationOther].blank?)
        #puts uberDestinationOther
        locdestination = Uberlocation.new(:address => uberDestinationOther)
        #puts locdestination
        #puts locdestination.address
        locdestination.geocode
        #puts locdestination.latitude
        #puts locdestination.longitude
        uberDestinationLat = locdestination.latitude
        uberDestinationLon = locdestination.longitude
      else
        redirect_to '/pages/uber/#error', :flash => { :notice => "Please specify a Destination location." } and return
      end
    else
      redirect_to '/pages/uber/#error', :flash => { :notice => "Please specify a Destination location." } and return
    end

    if ((uberPickupLat == uberDestinationLat) && (uberPickupLon == uberDestinationLon))
      redirect_to '/pages/uber/#error', :flash => { :notice => "Please specify a different Pickup and Destination location." } and return
    else
      client = Uber::Client.new do |config|
        config.server_token  = ENV['UBER_TOKEN']
      end
    
      price = client.price_estimations(start_latitude: uberPickupLat,
                                       start_longitude: uberPickupLon,
                                       end_latitude: uberDestinationLat,
                                       end_longitude: uberDestinationLon).to_json
      time = client.time_estimations(start_latitude: uberPickupLat,
                                     start_longitude: uberPickupLon).to_json
    

      JSON.parse(price).each do |option|
        if (option['display_name'] == 'UberX')
          @uberprice = option['estimate']
          @uberpriceexists = true
        end
      end
    
      JSON.parse(time).each do |option|
        if (option['display_name'] == 'UberX')
          @uberwaittime = option['estimate']
        end
      end

      print @uberprice
      print @uberwaittime

      if (@uberpriceexists == true)
        # Save to Dynamo
        timestamp = Time.now.strftime("%m-%d-%Y %I:%M%p")
        userIpAddress = request.remote_ip
        
        print userIpAddress
        print uberPickup
        print uberDestination
        print uberPickupLat
        print uberPickupLon
        print uberDestinationLat
        print uberDestinationLon
        print @uberprice
        print @uberwaittime
        print timestamp
        
        itemhash = {
                      'ip' => userIpAddress, 
                      'pickup' => uberPickup,
                      'destination' => uberDestination,
                      'pickup_other' => uberPickupOther,
                      'destination_other' => uberDestinationOther,
                      'pickup_lat' => uberPickupLat,
                      'pickup_lon' => uberPickupLon,
                      'destination_lat' => uberDestinationLat,
                      'destination_lon' => uberDestinationLon,
                      'price' => @uberprice,
                      'wait_time' => @uberwaittime,
                      'timestamp' => timestamp
                    }
        begin
          resp = $ddb.put_item({
            table_name: 'bongsky-fare-estimator',
            item: itemhash
          })
          resp.successful?
        rescue Aws::DynamoDB::Errors::ServiceError => e
          false
        end
        redirect_to '/pages/uber/#calculated', :flash => { :notice => "Your uber will cost " + @uberprice} and return
      else
        redirect_to '/pages/uber/#error', :flash => { :notice => "Unfortunately, your destination is too far away from the pickup point." } and return
      end

    end
  
  end

end
