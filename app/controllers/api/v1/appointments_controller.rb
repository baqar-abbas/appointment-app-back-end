class Api::V1::AppointmentsController < Api::V1::ApplicationController
  # API-specific actions for appointments
  skip_before_action :verify_authenticity_token
  before_action :set_appointment, only: %i[show update destroy]

  # GET /appointments
  def index
    @appointments = Appointment.all
    render json: @appointments
  end

  # GET /appointments/:id
  def show
    render json: @appointment
  end

  # POST /appointments
  def create
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
end
