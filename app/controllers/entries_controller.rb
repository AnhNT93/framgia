class EntriesController < ApplicationController
  before_action :logged_in_user, only: [:new, :destroy]
  before_action :correct_user,   only: :destroy
  def index
  	@entries =  Entry.all.paginate(page: params[:page], :per_page => 4 )
  end
  def new
  	@entry  = current_user.entries.build
  	
  end
  def create
    @entry = current_user.entries.build(entry_params)
    if @entry.save
      flash[:success] = "entry created!"
      redirect_back_or current_user
    else

      render 'new'
    end
  end
  
  def show
    @entry = Entry.find(params[:id])
    @comments = @entry.comments.paginate(page: params[:page],:per_page => 5)
    @comment = @entry.comments.build
  end

  def destroy
    @entry.destroy
    flash[:success] = "Entry deleted"
    redirect_to request.referrer || root_url
  end

  private

    def entry_params
      params.require(:entry).permit(:title, :body)
    end

    def correct_user
      @entry = current_user.entries.find_by(id: params[:id])
      redirect_to root_url if @entry.nil?
    end
end
