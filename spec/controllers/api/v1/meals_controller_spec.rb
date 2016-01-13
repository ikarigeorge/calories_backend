require 'rails_helper'

RSpec.describe Api::V1::MealsController, type: :controller do
  describe "GET #show" do
    before(:each) do
      @user = FactoryGirl.create :user
      @meal = FactoryGirl.create(:meal, :user_id => @user.id)      
      request.headers['Authorization'] =  @user.auth_token

      get :show, id: @meal.id, format: :json 
    end

    it "returns the meal info" do
      meal_response = json_response[:meal]
      expect(meal_response[:name]).to eql @meal.name
    end

    it { should respond_with 200 }
  end

  describe "GET #index" do
    before(:each) do
      @user = FactoryGirl.create :user
      4.times { FactoryGirl.create(:meal, :user_id => @user.id) }     
      request.headers['Authorization'] =  @user.auth_token

      get :index, format: :json
    end

    it "returns 4 records from the database" do
      meals_response = json_response
      expect(meals_response[:meals].size).to eq(4)
    end

    it { should respond_with 200 }
  end

  describe "POST #create" do
    context "when is successfully created" do
      before(:each) do
        @user = FactoryGirl.create :user
        @meal_attributes = FactoryGirl.attributes_for :meal
        request.headers['Authorization'] =  @user.auth_token
        post :create, { meal: @meal_attributes }, format: :json
      end

      it "renders the json representation for the meal record just created" do
        meal_response = json_response[:meal]
        expect(meal_response[:name]).to eql @meal_attributes[:name]
        expect(meal_response[:user_id]).to eql @user[:id]
      end

      it { should respond_with 201 }
    end

    context "when is not created" do
      before(:each) do
        @user = FactoryGirl.create :user
        @invalid_meal_attributes = { name: "coke", calories: "Twelve kcal" }
        request.headers['Authorization'] =  @user.auth_token
        post :create, { meal: @invalid_meal_attributes }
      end

      it "renders an errors json" do
        meal_response = json_response
        expect(meal_response).to have_key(:errors)
      end

      it "renders in 		the json errors why the meal could not be created" do
        meal_response = json_response
        expect(meal_response[:errors][:calories]).to include "is not a number"
      end

      it { should respond_with 422 }
    end
  end

  describe "PUT/PATCH #update" do
    before(:each) do
      @user = FactoryGirl.create :user
      @meal = FactoryGirl.create :meal, user: @user
      request.headers['Authorization'] =  @user.auth_token
    end

    context "when is successfully updated" do
      before(:each) do
        patch :update, { id: @meal.id,
              meal: { name: "Cheeseburguer" } }
      end

      it "renders the json representation for the updated meal" do
        meal_response = json_response[:meal]
        expect(meal_response[:name]).to eql "Cheeseburguer"
      end

      it { should respond_with 200 }
    end

    context "when is not updated" do
      before(:each) do
        patch :update, { id: @meal.id,
              meal: { calories: "two hundred kcal" } }
      end

      it "renders an errors json" do
        meal_response = json_response
        expect(meal_response).to have_key(:errors)
      end

      it "renders the json errors on whye the meal could not be updated (not a number)" do
        meal_response = json_response
        expect(meal_response[:errors][:calories]).to include "is not a number"
      end

      it { should respond_with 422 }
    end
  end

  describe "DELETE #destroy" do
    before(:each) do
      @user = FactoryGirl.create :user
      @meal = FactoryGirl.create :meal, user: @user
      request.headers['Authorization'] =  @user.auth_token
      delete :destroy, { id: @meal.id }
    end

    it { should respond_with 204 }
  end
end
