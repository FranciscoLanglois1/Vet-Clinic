class VetsController < ApplicationController
	before_action :authenticate_user!
	before_action :set_vet, only: [:show, :edit, :update, :destroy]
		
	after_action :verify_authorized, except: :index
	after_action :verify_policy_scoped, only: :index

	def index
    	@vets = policy_scope(Vet)
	end

	def show
    	authorize @vet
		@appointments = @vet.appointments
	end

	def new
		@vet = Vet.new
		authorize @vet
	end

	def edit
		authorize @vet
	end

	def create
		@vet = Vet.new(vet_params)
		authorize @vet
		if @vet.save
			flash[:notice] = "The vet has been created correctly"
			redirect_to vet_path(@vet)
		else
			render :new, status: :unprocessable_entity
		end
	end

	def update
		authorize @vet
		if @vet.update(vet_params)
			flash[:notice] = "The vet has been updated correctly"
			redirect_to vet_path(@vet)
		else
			render :edit, status: :unprocessable_entity
		end
	end

	def destroy
		authorize @vet
		@vet.destroy
		flash[:notice] = "The vet has been deleted correctly"
		redirect_to vets_path
	end

	private
	def set_vet
		@vet = Vet.find(params[:id])
	end

	def vet_params
    	params.require(:vet).permit(policy(@vet || Vet).permitted_attributes)
	end
end