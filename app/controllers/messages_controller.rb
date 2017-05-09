require_relative '../../lib/controller/controller_base'
require_relative '../models/message'

class MessagesController < ControllerBase
  def index
    @messages = Message.all
    render :index
  end

  def new
    render :new
  end

  def create
    message = Message.new(params["message"])
    message.insert
    redirect_to "/messages"
  end

  def show
    @message = Message.find(params["message_id"])
    render :show
  end

  def destroy
    message = Message.find(params["message_id"])
    message.destroy
    redirect_to "/messages"
  end
end
