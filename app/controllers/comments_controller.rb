class CommentsController < ApplicationController
  def create
  	@entry = Entry.find(params[:entry_id])
    @comment = @entry.comments.build(comment_params)
    @comment.user_id = current_user.id
    if @comment.save
      flash[:success] = "commend created!"
    else
      flash[:danger] = "commend can't be empty!"
    end
    redirect_to entry_path(@entry)
  end

  private
    def comment_params
      params.require(:comment).permit(:content,:question_id,:user_id)
    end
end
