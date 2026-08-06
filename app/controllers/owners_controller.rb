class OwnersController < ApplicationController
	
  	before_action :authenticate_user!
	before_action :set_owner, only: [:show, :edit, :update, :destroy]
	after_action :verify_authorized, except: :index
  	after_action :verify_policy_scoped, only: :index

	def index
    	@owners = policy_scope(Owner)
	end

	def show
    	authorize @owner
		@pets = @owner.pets
	end

	def new
    	@owner = Owner.new
    	authorize @owner
  	end

  	def create
    	@owner = Owner.new(owner_params)
    	authorize @owner
    	if @owner.save
			flash[:notice] = "The owner has been created correctly"
      		redirect_to @owner
    	else
      		render :new, status: :unprocessable_entity
    	end
  	end

  	def edit
		authorize @owner
  	end

  	def update
    	authorize @owner
    	if @owner.update(owner_params)
			flash[:notice] = "The owner has been updated correctly"
      		redirect_to @owner
    	else
      		render :edit, status: :unprocessable_entity
    	end
  	end

  	def destroy
    	authorize @owner
    	@owner.destroy
		flash[:notice] = "The owner has been deleted correctly"
    	redirect_to owners_url
  	end

  	private
  	def set_owner
    	@owner = Owner.find(params[:id])
  	end

  	def owner_params
    	params.require(:owner).permit(policy(@owner || Owner).permitted_attributes)
  	end
end
