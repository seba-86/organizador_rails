class TasksController < ApplicationController
  load_and_authorize_resource
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  # GET /tasks
  def index
    @tasks = Task.joins(:participants).where('owner_id = ? or participants.user_id = ?', current_user.id, current_user.id).group(:id)
    # Acceder a las tareas que crea y tambien a las que hace parte 
    # Si la tarea pertenece al usuario = se muestra o si el user pertenece a la tarea = se muestra 
    # owner_id = id current_user
    # participant.user_id = current_user 
    # (owner_id, pertenece a la tabla de task ), (user_id, pertenece a la tabla de participants(participants.user_id))
    # Joins duplica los registros al encontrar una coincidencia, para eso  = .group(:id)
  end

  # GET /tasks/1
  def show
  end

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # GET /tasks/1/edit
  def edit
    
  end

  # POST /tasks
  def create
    @task = Task.new(task_params)
    @task.owner = current_user
    if @task.save
      redirect_to @task, notice: 'Task was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /tasks/1
  def update
    if @task.update(task_params)
      redirect_to @task, notice: 'Task was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /tasks/1
  def destroy
    @task.destroy
    redirect_to tasks_url, notice: 'Task was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def task_params
      params.require(:task).permit(:name, :description, :due_date, :category_id,
         participanting_users_attributes: [:user_id, :role, :id, :_destroy])
    end
end
