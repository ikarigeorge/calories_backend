class Api::V1::MealsController < ApplicationController
  before_action :authenticate_with_token!
  respond_to :json
  
  def show
    respond_with current_user.meals.find(params[:id])
  end

  def index
    respond_with Meal.search(params, current_user)
  end

  def create
    meal = current_user.meals.build(meal_params)
    if meal.save
      render json: meal, status: 201, location: [:api, :v1, meal]
    else
      render json: { errors: meal.errors }, status: 422
    end
  end

  def update
    meal = current_user.meals.find(params[:id])
    if meal.update(meal_params)
      render json: meal, status: 200, location: [:api, :v1, meal]
    else
      render json: { errors: meal.errors }, status: 422
    end
  end

  def destroy
    meal = current_user.meals.find(params[:id])
    meal.destroy
    head 204
  end

  private

    def meal_params
      params.require(:meal).permit(:name, :date, :time, :calories)
    end
end
