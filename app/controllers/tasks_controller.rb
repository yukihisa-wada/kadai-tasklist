class TasksController < ApplicationController
  before_action :require_user_logged_in
  before_action :correct_user, only: [:destroy]

  # routes: /tasks(task_path)
  # view:   /tasks/index.html.erb
  def index
    @tasks = current_user.tasks
  end
  
  
  # routes: /tasks/:id
  # @params :idは整数
  # view:   /tasks/show.html.erb
  def show
    @task = current_user.tasks.find_by(id: params[:id])
    if @task.blank?
      redirect_to root_url
    end
  end

  def new
    @task = Task.new
  end

  def create
    @task = current_user.tasks.build(task_params)

    if @task.save
      flash[:success] = 'Task が正常に投稿されました'
      redirect_to @task
    else
      flash.now[:danger] = 'Task が投稿されませんでした'
      render :new
    end
  end

  def edit
    @task = current_user.tasks.find_by(id: params[:id])
  end

  def update
    @task = current_user.tasks.find_by(id: params[:id])

    if @task.update(task_params)
      flash[:success] = 'Task は正常に更新されました'
      redirect_to @task
    else
      flash.now[:danger] = 'Task は更新されませんでした'
      render :edit
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy

    flash[:success] = 'Task は正常に削除されました'
    redirect_to tasks_url
  end
  
  private

  def task_params
    params.require(:task).permit(:content, :status)
  end
  
  def correct_user
    @task = current_user.tasks.find_by(id: params[:id])
    unless @task
      redirect_to root_url
    end
  end
end

