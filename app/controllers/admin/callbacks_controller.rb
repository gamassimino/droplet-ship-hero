class Admin::CallbacksController < AdminController
  before_action :authenticate_user!
  before_action :set_callback, only: %i[show edit update]

  def index
    @callbacks = ::Callback.all.order(:name)
  end

  def show; end

  def edit; end

  def update
    if @callback.update(callback_params)
      redirect_to admin_callback_path(@callback), notice: "Callback was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def sync
    service = CallbackSyncService.new
    result = service.sync

    if result[:success]
      redirect_to admin_callbacks_path, notice: result[:message]
    else
      redirect_to admin_callbacks_path, alert: result[:message]
    end
  end

private

  def set_callback
    @callback = ::Callback.find(params[:id])
  end

  def callback_params
    params.require(:callback).permit(:name, :description, :active, :url, :timeout_in_seconds)
  end
end
