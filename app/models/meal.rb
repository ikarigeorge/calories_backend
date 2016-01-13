class Meal < ActiveRecord::Base
  validates :name, :date, :time, :user_id, presence: true
  validates :calories, numericality: { greater_than_or_equal_to: 0 },
                    presence: true
  belongs_to :user

  scope :from_date, lambda { |date| 
    where("date >= ?", date) 
  }

  scope :until_date, lambda { |date| 
    where("date <= ?", date) 
  }

  scope :from_time, lambda { |time| 
    where("time >= ?", time) 
  }

  scope :until_time, lambda { |time| 
    where("time <= ?", time) 
  }

  scope :recent, -> {
    order('date DESC, time DESC')
  }


  def self.search(params = {}, current_user)
    meals = params[:meal_ids].present? ? Meal.where(id: params[:meal_ids]) : Meal.where(user_id: current_user.id)
    meals = meals.from_date(params[:from_date]) if params[:from_date]
    meals = meals.until_date(params[:until_date]) if params[:until_date]
    meals = meals.from_time(params[:from_time]) if params[:from_time]
    meals = meals.until_time(params[:until_time]) if params[:until_time]    
    meals = meals.recent

    meals
  end
end
