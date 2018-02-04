require 'mechanize'
require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new

scheduler.every '1h' do
    @events = Event.all
    @events.each do |event|
        #parse out minutes from created at time
        created = event.created_at.to_s
        created_list = created.split(' ')
        create_time = created[1].to_i

        #parse out minutes/hours from current time
        time_now = Time.now.to_s
        time_now_list = time_now.split(' ')
        current_time = time_now_list[1].to_i

        #if day is the current day test further
        if time_now_list[0] === created_list[0]
            #if difference between timeNow and created at is < 60 mins push event to websites
            difference = current_time - create_time
            if difference < 60
                #news day code
                agent = Mechanize.new { |agent|
                    agent.user_agent_alias = "Mac Safari"
                }
                page = agent.get('https://www.newsday.com/user-content/submit-an-event-1.1992168')

                form = page.forms.first
                form['fname'] = "Ted"
                form['lname'] = "Burgess"
                form['email'] = "demo@aol.com"
                form['phone'] = "222-222-2222"
                form['eventname'] = event.title
                form['eventdescription'] = event.description 
                form['eventphone1'] = "222-222-2222"
                form['eventadmission'] = event.price
                form['venueName'] = event.venue
                form['venuecity'] = "new york"
                form['venueaddress'] = "tba"
                form['zip'] = "10001"
                form['eventdate'] = "02/28/2018"

                page = form.submit

                #ctpost code
                agent = Mechanize.new { |agent|
                    agent.user_agent_alias = "Mac Safari"
                }
                page = agent.get('http://events.ctpost.com/home')
                link = page.link_with(text:'Add Event')
                page = link.click
                #--------Enter sign in credentials----------

                #enter email
                form = page.forms.first

                form['email'] = 'savemyday15@aol.com'
                #enter password
                form = page.forms[1]
                form['password'] = '1qaz2wsx!QAZ@WSX'
                page = form.submit

                #-------Create Event-------

                #fill out event form
                form = page.forms.first
                form['title'] = event.title
                form['description'] = event.description
                form['price'] = "free"
                form['phone'] = "666-666-6666"
                form['event_venue'] = event.venue
                form["Enter a start time"] = "7:00pm"

                page = form.submit


                #eventbrite code
                #navigate to sign in page
                
                mechanize = Mechanize.new { |agent|
                    agent.user_agent_alias = "Mac Safari"
                }
                page = mechanize.get('https://www.eventbrite.com/')
                puts page.uri
                link = page.link_with(text:'Sign in')
                page = link.click
                puts page.uri
                #--------Enter sign in credentials----------

                #enter email
                form = page.forms.first

                form['email'] = 'kurtzikaras@gmail.com'
                page = form.submit
                puts page.uri
                #enter password
                form = page.forms.first
                form['password'] = 'Halothedog123'
                page = form.submit
                puts page.uri

                #-------Create Event-------

                #click create event
                link = page.link_with(text:'Create Event')
                page = link.click
                puts page.uri
                #fill out event form

                event_form = page.form_with(page.css('#event_form'))

                event_form['Event Title'] = event.title
                event_form['Location'] = event.venue
                event_form['Starts'] = "03/14/2018"
                event_form['Event description'] = event.description
                ticket_link = page.link_with(page.css('#create-ticket-free-button'))
                ticket_link.click
                ticket_form = page.forms.last
                # ticket_form['ticket name'] = "General"
                ticket_form['ticket name'] = "General"
                ticket_form['Quantity available'] = "100"


                submit_link = page.link_with(:dom_class => "btn btn--epic submit-for-live")
                page = submit_link.click


                #spingo
                agent = Mechanize.new { |agent|
                    agent.user_agent_alias = "Mac Safari"
                }
                page = agent.get('https://www.spingo.com/submit/')
                puts page.uri

                form = page.forms.first
                form['title'] = event.title
                form['venue'] = event.venue
                form['date'] = "Feb 8, 2018"
                form['start']  = event.time 
                form['end'] = event.time
                form['description'] = event.description
                form['attendance'] = "100"
                form['category'] = "other"
                form['admission'] = "other"

                page = form.submit

                #redtri code
                agent = Mechanize.new { |agent|
                    agent.user_agent_alias = "Mac Safari"
                }
                page = agent.get('http://redtri.com/submit-event/')


                form = page.forms.first
                form['contact_name'] = "ted"
                form['contact_email'] = "Jones"
                form['post_title'] = event.title
                form['location'] = event.venue
                form['state'] = "ny"
                form['city'] = "new york"
                form['post_content'] = event.description
                page = form.submit
                
            end
        end
    end
end