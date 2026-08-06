class TreatmentsController < ApplicationController 
    before_action :authenticate_user!
    before_action :set_appointment
    before_action :set_treatment, only: [:edit, :update, :destroy]
    after_action :verify_authorized

    def index
        @treatments = policy_scope(Treatment)
        authorize @treatments
    end

    def show
        authorize @treatment
    end

    def new
        @treatment = @appointment.treatments.build
        authorize @treatment 
    end

    def edit
        authorize @treatment
    end

    def create
        @treatment = @appointment.treatments.build(treatment_params)
        authorize @treatment 
        if @treatment.save
            flash[:notice] = "The treatment has been created correctly"
            redirect_to appointment_path(@appointment)
        else
            render :new, status: :unprocessable_entity
        end
    end

    def update
        authorize @treatment 
        if @treatment.update(treatment_params)
            flash[:notice] = "The treatment has been updated correctly"
            redirect_to appointment_path(@appointment)
        else
            render :edit, status: :unprocessable_entity
        end
    end

    def destroy
        authorize @treatment 
        @treatment.destroy
        flash[:notice] = "The treatment has been deleted correctly"
        redirect_to appointment_path(@appointment)
    end

    private
    def set_appointment
        @appointment = Appointment.find(params[:appointment_id])
    end

    def set_treatment
        @treatment = @appointment.treatments.find(params[:id])
    end

    def treatment_params
        params.require(:treatment).permit(policy(@treatment || Treatment).permitted_attributes)
    end
end