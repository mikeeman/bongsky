class RsvpController < ApplicationController
	def send(variable)
      
      @vegetarians = ""
      @guests = ""

  	  if(params.has_key?(:name))
  	    @name = params[:name]
  	  end

  	  if(params.has_key?(:attending))
        if(params[:attending] == "attending")
          @attending = true
        else
          @attending = false
        end
  	  end

      if(params.has_key?(:vegetarian))
        @vegetarians += "1"
      else
        @vegetarians += "0"
      end

      if(params.has_key?(:email))
      	@email = params[:email]
      end

      if(params.has_key?(:code))
        @code = params[:code]
      end

  	  if(params.has_key?(:guest1))
  	  	@guests += params[:guest1]
        if (params.has_key?(:vegetarianguest1))
          @vegetarians += ",1"
        else
          @vegetarians += ",0"
        end
  	  end

      if(params.has_key?(:guest2) && !params[:guest2].blank?)
        @guests += ", " + params[:guest2]
        if (params.has_key?(:vegetarianguest2))
          @vegetarians += ",1"
        else
          @vegetarians += ",0"
        end
      end

      if(params.has_key?(:guest3) && !params[:guest3].blank?)
        @guests += ", " + params[:guest3]
        if (params.has_key?(:vegetarianguest3))
          @vegetarians += ",1"
        else
          @vegetarians += ",0"
        end
      end

      if(params.has_key?(:guest4) && !params[:guest4].blank?)
        @guests += ", " + params[:guest4]
        if (params.has_key?(:vegetarianguest4))
          @vegetarians += ",1"
        else
          @vegetarians += ",0"
        end
      end

      if(params.has_key?(:guest5) && !params[:guest5].blank?)
        @guests += ", " + params[:guest5]
        if (params.has_key?(:vegetarianguest5))
          @vegetarians += ",1"
        else
          @vegetarians += ",0"
        end
      end

      if(params.has_key?(:guest6) && !params[:guest6].blank?)
        @guests += ", " + params[:guest6]
        if (params.has_key?(:vegetarianguest6))
          @vegetarians += ",1"
        else
          @vegetarians += ",0"
        end
      end

      if(params.has_key?(:guest7) && !params[:guest7].blank?)
        @guests += ", " + params[:guest7]
        if (params.has_key?(:vegetarianguest7))
          @vegetarians += ",1"
        else
          @vegetarians += ",0"
        end
      end
      
      if(params.has_key?(:guest8) && !params[:guest8].blank?)
        @guests += ", " + params[:guest8]
        if (params.has_key?(:vegetarianguest8))
          @vegetarians += ",1"
        else
          @vegetarians += ",0"
        end
      end

      if(params.has_key?(:guest9) && !params[:guest9].blank?)
        @guests += ", " + params[:guest9]
        if (params.has_key?(:vegetarianguest9))
          @vegetarians += ",1"
        else
          @vegetarians += ",0"
        end
      end

      if(params.has_key?(:guest10) && !params[:guest10].blank?)
        @guests += ", " + params[:guest10]
        if (params.has_key?(:vegetarianguest10))
          @vegetarians += ",1"
        else
          @vegetarians += ",0"
        end
      end

      if(@code.upcase == ENV['RSVP_CODE'])
        #Happy path: guest has answered correct RSVP code
        @timestamp = Time.now.strftime("%m-%d-%Y %I:%M%p")
        if(params.has_key?(:attending))
          if(!@email.blank?)
            if(!@guests.blank?)
              @itemhash = {
                  'name' => @name, 
                  'attending' => @attending ? 1 : 0,
                  'email' => @email,
                  'guests' => @guests,
                  'vegetarians' => @vegetarians,
                  'timestamp' => @timestamp
                  #t.strftime(“Printed on %m/%d/%Y”) #=> “Printed on 04/09/2003”
                  #t.strftime(“at %I:%M%p”) #=> “at 08:56AM”
                  }
            else
              @itemhash = {
                  'name' => @name, 
                  'attending' => @attending ? 1 : 0,
                  'email' => @email,
                  'vegetarians' => @vegetarians,
                  'timestamp' => @timestamp
                  }
            end
          else
            if(params.has_key?(:guest1))
              @itemhash = {
                  'name' => @name, 
                  'attending' => @attending ? 1 : 0,
                  'guests' => @guests,
                  'vegetarians' => @vegetarians,
                  'timestamp' => @timestamp
                  }
            else
              @itemhash = {
                  'name' => @name, 
                  'attending' => @attending ? 1 : 0,
                  'vegetarians' => @vegetarians,
                  'timestamp' => @timestamp
                  }
            end
          end

          # Save to Dynamo
          begin
            resp = $ddb.put_item({
              table_name: 'bongsky-rsvp',
              item: @itemhash
                })
            resp.successful?
          rescue Aws::DynamoDB::Errors::ServiceError => e
            false
          end

          RsvpMailer.rsvp_email(@name, @email, @attending, @guests, @vegetarians).deliver
        else
          if(!@email.blank?)
            if(!@guests.blank?)
              @itemhash = {
                  'name' => @name, 
                  'attending' => -1,
                  'email' => @email,
                  'guests' => @guests,
                  'vegetarians' => @vegetarians,
                  'error' => "did not select attending or not attending",
                  'timestamp' => @timestamp
                  }
            else
              @itemhash = {
                  'name' => @name, 
                  'attending' => -1,
                  'email' => @email,
                  'vegetarians' => @vegetarians,
                  'error' => "did not select attending or not attending",
                  'timestamp' => @timestamp
                  }
            end
          else
            if(params.has_key?(:guest1))
              @itemhash = {
                  'name' => @name, 
                  'attending' => -1,
                  'guests' => @guests,
                  'vegetarians' => @vegetarians,
                  'error' => "did not select attending or not attending",
                  'timestamp' => @timestamp
                  }
            else
              @itemhash = {
                  'name' => @name, 
                  'attending' => -1,
                  'vegetarians' => @vegetarians,
                  'error' => "did not select attending or not attending",
                  'timestamp' => @timestamp
                  }
            end
          end
          # Save to Dynamo with error
          begin
            resp = $ddb.put_item({
              table_name: 'bongsky-rsvp',
              item: @itemhash
            })
            resp.successful?
          rescue Aws::DynamoDB::Errors::ServiceError => e
            false
          end

          RsvpMailer.rsvp_email(@name, @email, @attending, @guests, @vegetarians, "did not select attending or not attending").deliver
        end

      

        if(params.has_key?(:attending))
      	  if (@attending)
  	  	    redirect_to '/pages/rsvp/#sent', :flash => { :notice => "See you soon!  If anything changes, just RSVP again." } and return
  	      else
  	  	    redirect_to '/pages/rsvp/#sent', :flash => { :notice => "Aww shucks!  If you change your mind just RSVP again." } and return
          end
        else
      	  redirect_to '/pages/rsvp/#error', :flash => { :notice => "Please let us know if you can make it or not." } and return
        end
      end
    
    else
      #guest has entered incorrect RSVP code
      RsvpMailer.rsvp_email(@name, @email, @attending, @guests, @vegetarians, "entered incorrect rsvp code: " + @code).deliver
      
      redirect_to '/pages/rsvp/#error', :flash => { :notice => "Oops! RSVP Code entered did not match."} and return
    end

    def number_of_days_until_the_wedding
      @numdays = (Time.now - "2018-08-18 15:00:00") / 86400
    end

end
