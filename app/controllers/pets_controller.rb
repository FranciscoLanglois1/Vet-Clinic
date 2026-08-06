class PetsController < ApplicationController
	before_action :authenticate_user!
	before_action :set_pet, only: [:show, :edit, :update, :destroy]
	
  	after_action :verify_authorized, except: :index
  	after_action :verify_policy_scoped, only: :index

	def index
		@pets = policy_scope(Pet)
	end

	def show
		authorize @pet
		@owner = @pet.owner
		@appointments = @pet.appointments
	end

	def new
		@pet = Pet.new
		authorize @pet
	end

	def edit
		puts "=" * 80
		puts "🔍 EDIT - DEBUG EXTREMO:"
		puts "  - params[:id]: #{params[:id].inspect}"
		puts "  - @pet: #{@pet.inspect}"
		puts "  - @pet.nil?: #{@pet.nil?}"
		puts "  - @pet.class: #{@pet.class if @pet}"
		puts "  - @pet.object_id: #{@pet.object_id if @pet}"
		puts "  - current_user: #{current_user.inspect}"
		puts "  - current_user.role: #{current_user.role.inspect}"
		puts "  - ¿Existe Pet.find(#{params[:id]})? #{Pet.exists?(params[:id])}"
		puts "=" * 80
		
		# Si @pet es nil, intentar buscarlo manualmente
		if @pet.nil?
		puts "❌ @pet es nil! Buscando manualmente..."
		@pet = Pet.find_by(id: params[:id])
		puts "  - Búsqueda manual: #{@pet.inspect}"
		end
		
		if @pet.nil?
		puts "❌ No se pudo encontrar el pet"
		flash[:alert] = "La mascota no existe"
		redirect_to pets_path and return
		end
		
		puts "✅ @pet encontrado: #{@pet.name} (ID: #{@pet.id})"
		puts "  - owner_id: #{@pet.owner_id}"
		puts "  - species: #{@pet.species}"
		puts "=" * 80
		
		begin
		authorize @pet
		puts "✅ Autorización exitosa!"
		rescue => e
		puts "❌ Error en authorize: #{e.class} - #{e.message}"
		puts e.backtrace.first(5)
		raise e
		end
	end

	def create
		@pet = Pet.new(pet_params)
		authorize @pet
		if current_user.owner? && @pet.owner_id.nil?
      		@pet.owner_id = current_user.owner.id
    	end
		if @pet.save
			flash[:notice] = "The pet has been created correctly"
			redirect_to pet_path(@pet)
		else
			render :new, status: :unprocessable_entity
		end
	end

	def update
		authorize @pet
		if @pet.update(pet_params)
			flash[:notice] = "The pet has been updated correctly"
			redirect_to pet_path(@pet)
		else
			render :edit, status: :unprocessable_entity
		end
	end

	def destroy
		authorize @pet
		@pet.destroy
		flash[:notice] = "The pet has been deleted correctly"
		redirect_to pets_path
	end

	private
	def set_pet
		@pet = Pet.find(params[:id])
	end

	def pet_params
		params.require(:pet).permit(policy(@pet || Pet).permitted_attributes)	
	end
end
