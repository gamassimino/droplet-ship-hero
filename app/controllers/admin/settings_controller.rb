class Admin::SettingsController < AdminController
  def index
    @settings = Setting.order(:name)
  end

  def edit
    @setting = Setting.find(params[:id])
    @name = @setting.name.humanize.titleize
  end

  def update
    @setting = Setting.find(params[:id])
    @setting.update(setting_params)

    render json: { success: true }
  end

private

  def setting_params
    params.require(:setting).permit(values: {})
  end
end
