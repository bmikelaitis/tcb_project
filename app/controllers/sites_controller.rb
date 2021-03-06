class SitesController < ApplicationController 
	
	
	before_filter :assign_function

def assign_function
@var = 0
end
	def index
		@sites = Site.all
		if params[:search]
    		@sites = Site.search(params[:search]).order("created_at DESC")
		else
    		@sites = Site.all.order('created_at DESC')
		end
	end

	def new
		@site = Site.new
	end

	def create 
		@site = Site.new(site_params)
		if @site.save
			flash[:success] = "The site has been created succesfully"
			if @site.subtype == 'Street'
				redirect_to new_street_path(param_1: @site.id)
			elsif @site.subtype == 'Wash'
				redirect_to new_wash_path(param_1: @site.id)
			else 
				redirect_to new_park_path(param_1: @site.id)
			end
			
		else
			render 'new'
		end
	end

	def edit
		@site = Site.find(params[:id])
	end

	def update
		@site = Site.find(params[:id])
		if @site.update(site_params)
			flash[:success] = "The site has been updated succesfully"
			if @site.subtype == 'Street'
				redirect_to edit_street_path(param_1: @site.id)
			elsif @site.subtype == 'Wash'
				redirect_to edit_wash_path(param_1: @site.id)
			else 
				redirect_to edit_park_path(param_1: @site.id)
			end
			#redirect_to receipts_path(@user) #TODO change to users_path
		else
			render 'edit'
		end
	end

	def show
		@site = Site.find(params[:id])
		@subtype = @site.subtype
		if @subtype == 'Street'
		@street = Site.street.find(params[:id])
			if @site.street == nil
				@site.destroy
				redirect_to root_path
			end
		elsif @subtype == 'Wash'
			if @site.wash == nil
				@site.destroy
				redirect_to root_path
			end
		else @subtype == 'Park'
			if @site.park == nil
				@site.destroy
				redirect_to root_path
			end
		end
		
		@projects = @site.projects.order("updated_at DESC")

	end

private
	def site_params
		params.require(:site).permit(:id, :subtype, :siteStreet, :siteCrossStreets, :siteCounty, :siteZip, :status, :cityWardNumber, :countyDistrict, :permitRequired, :permitInPlace)
	end

end