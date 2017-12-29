class RsvpController < ApplicationController
	def send(variable)

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

      if(params.has_key?(:email))
      	@email = params[:email]
      end

  	  if(params.has_key?(:guest1))
  	  	@guests += params[:guest1]
  	  end

      if(params.has_key?(:guest2) && !params[:guest2].blank?)
        @guests += ", " + params[:guest2]
      end

      if(params.has_key?(:guest3) && !params[:guest3].blank?)
        @guests += ", " + params[:guest3]
      end

      if(params.has_key?(:guest4) && !params[:guest4].blank?)
        @guests += ", " + params[:guest4]
      end

      if(params.has_key?(:guest5) && !params[:guest5].blank?)
        @guests += ", " + params[:guest5]
      end

      if(params.has_key?(:guest6) && !params[:guest6].blank?)
        @guests += ", " + params[:guest6]
      end

      if(params.has_key?(:guest7) && !params[:guest7].blank?)
        @guests += ", " + params[:guest7]
      end
      
      if(params.has_key?(:guest8) && !params[:guest8].blank?)
        @guests += ", " + params[:guest8]
      end

      if(params.has_key?(:guest9) && !params[:guest9].blank?)
        @guests += ", " + params[:guest9]
      end

      if(params.has_key?(:guest10) && !params[:guest10].blank?)
        @guests += ", " + params[:guest10]
      end

      if(params.has_key?(:attending))
        if(!@email.blank?)
          if(!@guests.blank?)
            @itemhash = {
                  'name' => @name, 
                  'attending' => @attending ? 1 : 0,
                  'email' => @email,
                  'guests' => @guests
                }
          else
            @itemhash = {
                  'name' => @name, 
                  'attending' => @attending ? 1 : 0,
                  'email' => @email
                }
          end
        else
          if(params.has_key?(:guest1))
            @itemhash = {
                  'name' => @name, 
                  'attending' => @attending ? 1 : 0,
                  'guests' => @guests
                }
          else
            @itemhash = {
                  'name' => @name, 
                  'attending' => @attending ? 1 : 0
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

        RsvpMailer.rsvp_email(@name, @email, @attending, @guests).deliver
      else
        if(!@email.blank?)
          if(!@guests.blank?)
            @itemhash = {
                  'name' => @name, 
                  'attending' => -1,
                  'email' => @email,
                  'guests' => @guests,
                  'error' => "did not select attending or not attending"
                }
          else
            @itemhash = {
                  'name' => @name, 
                  'attending' => -1,
                  'email' => @email,
                  'error' => "did not select attending or not attending"

                }
          end
        else
          if(params.has_key?(:guest1))
            @itemhash = {
                  'name' => @name, 
                  'attending' => -1,
                  'guests' => @guests,
                  'error' => "did not select attending or not attending"
                }
          else
            @itemhash = {
                  'name' => @name, 
                  'attending' => -1,
                  'error' => "did not select attending or not attending"
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

        RsvpMailer.rsvp_email(@name, @email, @attending, @guests, "did not select attending or not attending").deliver
      end

      

      if(params.has_key?(:attending))
      	if (@attending)
  	  	  redirect_to '/pages/rsvp/#sent', :flash => { :notice => "See you soon!  If anything changes, just RSVP again." }
  	    else
  	  	  redirect_to '/pages/rsvp/#sent', :flash => { :notice => "Aww shucks!  If you change your mind just RSVP again." }
        end
      else
      	redirect_to '/pages/rsvp/#error', :flash => { :notice => "Please let us know if you can make it or not." }
      end
    end

    def number_of_days_until_the_wedding
      @numdays = (Time.now - "2018-08-18 15:00:00") / 86400
    end

end
