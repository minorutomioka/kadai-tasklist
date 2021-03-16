class TasksController < ApplicationController
    before_action :require_user_logged_in
    
  def index
       @tasks = current_user.tasks.order(id: :desc).page(params[:page])
  end

  def show
    user_task
  end

  def new
    @task = Task.new
  end

  def create
    @task = current_user.tasks.new(task_params)
    if @task.save
      flash[:success]='タスクが追加されました。'
      redirect_to @task
    else
      flash.now[:danger] ='タスクは追加できませんでした。'
      render :new
    end
  end

  def edit
    user_task
  end

  def update
    user_task
    if @task.update(task_params)
      flash[:success]='タスクが更新されました。'
      redirect_to @task
    else
      flash.now[:danger] ='タスクは更新できませんでした。'
      render :edit
    end
  end

  def destroy
    user_task
    @task.destroy
    
    flash[:success]='タスクが削除されました。'
    redirect_to tasks_url
  end

  private

  # Strong Parameter
  def task_params
    params.require(:task).permit(:content, :status)
  end

  def correct_user
    @task = current_user.tasks.find_by(id: params[:id])
    unless @task
      redirect_to root_url
    end
  end
  
  def user_task 
    @task = current_user.tasks.find(params[:id])
  end
end