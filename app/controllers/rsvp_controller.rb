class RsvpController < ApplicationController
	def send(variable)

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

  	  if(params.has_key?(:guest))
  	  	@guest = params[:guest]
  	  end
      
      # Save to Dynamo
      begin
        resp = $ddb.put_item({
          table_name: 'bongsky-rsvp',
          item: {
                  'name' => @name, 
                  'attending' => @attending ? 1 : 0
                }
        })
        resp.successful?
      rescue Aws::DynamoDB::Errors::ServiceError => e
        false
      end

      if(params.has_key?(:attending) || params.has_key?(:notattending))
      	if (@attending)
  	  	  redirect_to '/pages/rsvp/#sent', :flash => { :notice => "See you soon!  If anything changes, just RSVP again." }
  	    else
  	  	  redirect_to '/pages/rsvp/#sent', :flash => { :notice => "Aww shucks!  If you change your mind just RSVP again." }
        end
      else
      	redirect_to '/pages/rsvp/#error', :flash => { :notice => "Please let us know if you can make it or not." }
      end
    end
end
