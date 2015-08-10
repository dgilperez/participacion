class DebatesController < ApplicationController
  include RecaptchaHelper
  before_action :authenticate_user!, except: [:index, :show]
  load_and_authorize_resource

  def index
    if params[:tag]
      @debates = Debate.tagged_with(params[:tag]).order("created_at DESC")
      set_voted_values @debates.map(&:id)
    else
      @debates = Debate.all.order("created_at DESC")
      set_voted_values @debates.map(&:id)
    end
  end

  def show
    set_voted_values [@debate.id]
  end

  def new
    @debate = Debate.new
  end

  def edit
  end

  def create
    @debate = Debate.new(debate_params)
    @debate.author = current_user
    if verify_captcha?(@debate) and @debate.save
      redirect_to @debate, notice: t('flash.actions.create.notice', resource_name: 'Debate')
    else
      render :new
    end
  end

  def update
    @debate.update(debate_params)
    respond_with @debate
  end

  def vote
    @debate.vote_by(voter: current_user, vote: params[:value])
    set_voted_values [@debate.id]
  end


  private
    def set_debate
      @debate = Debate.find(params[:id])
    end

    def debate_params
      params.require(:debate).permit(:title, :description, :tag_list, :terms_of_service)
    end

end
