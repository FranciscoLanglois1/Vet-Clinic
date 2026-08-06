class AppointmentsController < ApplicationController
	before_action :authenticate_user!
	before_action :set_appointment, only: [:show, :edit, :update, :destroy]
		
	after_action :verify_authorized, except: :index
	after_action :verify_policy_scoped, only: :index

	def index
    	@appointments = policy_scope(Appointment)
	end

	def show
    	authorize @appointment
		@pet = @appointment.pet
		@vet = @appointment.vet
		@treatments = @appointment.treatments.with_rich_text_notes
	end

	def new
		@appointment = Appointment.new
    	authorize @appointment
		if current_user.owner? && params[:pet_id]
      		@appointment.pet_id = params[:pet_id]
    	end
	end

	def edit
		authorize @appointment
	end

	def create
		@appointment = Appointment.new(appointment_params)
    	authorize @appointment
		if @appointment.save
			flash[:notice] = "The appointment has been created correctly"
			redirect_to appointment_path(@appointment)
		else
			render :new, status: :unprocessable_entity
		end
	end

	def update
    	authorize @appointment
		if @appointment.update(appointment_params)
			flash[:notice] = "The appointment has been updated correctly"
			redirect_to appointment_path(@appointment)
		else
			render :edit, status: :unprocessable_entity
		end
	end

	def destroy
    	authorize @appointment
		@appointment.destroy
		flash[:notice] = "The appointment has been deleted correctly"
		redirect_to appointments_path
	end

	private
	def set_appointment
		@appointment = Appointment.find(params[:id])
	end

	def appointment_params
    params.require(:appointment).permit(policy(@appointment || Appointment).permitted_attributes)
	end
end