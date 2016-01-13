require 'rails_helper'

RSpec.describe Meal, type: :model do
  let(:meal) { FactoryGirl.build :meal }
  subject { meal }
  before { @user = FactoryGirl.build(:user) }

  it { should respond_to(:name) }
  it { should respond_to(:date) }
  it { should respond_to(:time) }
  it { should respond_to(:calories) }
  it { should respond_to(:user_id) }

  it { should belong_to :user }

  it { should validate_presence_of :name }
  it { should validate_presence_of :date }
  it { should validate_presence_of :time }
  it { should validate_presence_of :calories }
  it { should validate_numericality_of(:calories).is_greater_than_or_equal_to(0) }
  it { should validate_presence_of :user_id }

  describe "date filtering" do
  	before(:each) do
  	  @meal1 = FactoryGirl.create :meal, date: "2015-12-24"
  	  @meal2 = FactoryGirl.create :meal, date: "2015-12-26"
  	  @meal3 = FactoryGirl.create :meal, date: "2016-01-15"
  	  @meal4 = FactoryGirl.create :meal, date: "2015-11-10"	
  	end

  	it "returns meals from specific date" do
  	  expect(Meal.from_date("2016-01-01").sort).to match_array([@meal3])	
  	end

  	it "returns meals until specific date" do
  	  expect(Meal.until_date("2016-01-01").sort).to match_array([@meal1, @meal2, @meal4])	
  	end
  end

  describe "time filtering" do
  	before(:each) do
  	  @meal1 = FactoryGirl.create :meal, time: "08:00"
  	  @meal2 = FactoryGirl.create :meal, time: "12:34"
  	  @meal3 = FactoryGirl.create :meal, time: "22:40"
  	  @meal4 = FactoryGirl.create :meal, time: "17:09"	
  	end

  	it "returns meals from specific time" do
  	  expect(Meal.from_time("13:00").sort).to match_array([@meal3, @meal4])	
  	end

  	it "returns meals until specific time" do
  	  expect(Meal.until_time("13:00").sort).to match_array([@meal1, @meal2])	
  	end
  end

  describe ".recent" do
    before(:each) do
      @meal1 = FactoryGirl.create :meal, date: "2015-12-24", time: "18:00"
  	  @meal2 = FactoryGirl.create :meal, date: "2015-12-24", time: "02:34"
  	  @meal3 = FactoryGirl.create :meal, date: "2016-01-15", time: "22:40"

    end

    it "returns the meals in order" do
      expect(Meal.recent).to match_array([@meal3, @meal2, @meal1])
    end
  end

  describe ".search" do
    before(:each) do
      @user.save
      @meal1 = FactoryGirl.create :meal, date: "2015-12-24", time: "08:00", user: @user
  	  @meal2 = FactoryGirl.create :meal, date: "2015-12-26", time: "12:34", user: @user
  	  @meal3 = FactoryGirl.create :meal, date: "2016-01-15", time: "22:40", user: @user
  	  @meal4 = FactoryGirl.create :meal, date: "2015-11-10", time: "17:09", user: @user
    end

    context "when date of 24th dec 2015 and time until 07:00 are set" do
      it "returns an empty array" do
        search_hash = { from_date: "2015-12-24", until_date: "2015-12-24", until_time: "07:00" }
        expect(Meal.search(search_hash, @user)).to be_empty
      end
    end

    context "when date of 24th dec 2015 and time from 07:00 are set" do
      it "returns the product1" do
        search_hash = { from_date: "2015-12-24", until_date: "2015-12-24", from_time: "07:00" }
        current_user = { id: 1}
        expect(Meal.search(search_hash, @user)).to match_array([@meal1]) 
      end
    end

    context "when an empty hash is sent" do
      it "returns all the products" do
        current_user = { id: 1}
        expect(Meal.search({}, @user)).to match_array([@meal1, @meal2, @meal3, @meal4])
      end
    end

    context "when product_ids is present" do
      it "returns the product from the ids" do
        search_hash = { meal_ids: [@meal3.id, @meal4.id]}
        expect(Meal.search(search_hash, @user)).to match_array([@meal3, @meal4])
      end
    end
  end
end
