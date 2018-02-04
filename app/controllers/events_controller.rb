class EventsController < ApplicationController

  def index
    @events = Event.all
  end

  def show
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.create(event_params)
    redirect_to events_path
  end

  def edit
  end

  def event_params
    params.permit(:title, :description, :price, :venue)
  end

end
