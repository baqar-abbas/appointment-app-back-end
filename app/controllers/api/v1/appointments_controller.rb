class Api::V1::AppointmentsController < Api::V1::ApplicationController

  # API-specific actions for appointments
  skip_before_action :verify_authenticity_token
  # before_action :authenticate_user!
  before_action :set_appointment, only: %i[show update destroy]

  # GET /appointments
  def index
      # @appointments = Appointment.find_by(patient_id: 8)
    @appointments = Appointment.all
    # if current_user
    #   @appointments = if current_user.doctor?
    #                     current_user.doctor_appointments
    #                   elsif current_user.patient?
    #                     current_user.patient_appointments
    #                   elsif current_user.super_admin? || current_user.admin?
    #                     Appointment.all
    #                   else
    #                     []
    #                   end
    # else
    #   render json: { error: 'User not authenticated' }, status: :unauthorized
    #   return
    # end

    render json: @appointments
  end

  # GET /appointments/:id
  def show
    render json: @appointment
  end

  # POST /appointments
  def create
    # appointment_params = appointment_params_with_role_check

    @appointment = Appointment.new(appointment_params)

    if @appointment.save
      render json: @appointment, status: :created
    else
      render json: @appointment.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /appointments/:id
  def update
    if @appointment.update(appointment_params)
      render json: @appointment
    else
      render json: @appointment.errors, status: :unprocessable_entity
    end
  end

  # DELETE /appointments/:id
  def destroy
    @appointment.destroy
    head :no_content
  end

  private

  def set_appointment
    @appointment = Appointment.find(params[:id])
  end

  def appointment_params
    params.require(:appointment).permit(
      :appointment_date,
      :patient_id,
      :doctor_id,
      status: %i[active expire cancel],
      location: %i[street state city zip_code]
    )
  end

  # def appointment_params_with_role_check
  #   appointment_params = appointment_params()
  #   # Check if the user is a doctor or patient and set the corresponding user_id
  #   if current_user.doctor?
  #     appointment_params[:doctor_id] = current_user.id
  #   elsif current_user.patient?
  #     appointment_params[:patient_id] = current_user.id
  #   end

  #   appointment_params
  # end
end
