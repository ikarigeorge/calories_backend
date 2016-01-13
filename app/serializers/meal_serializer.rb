class MealSerializer < ActiveModel::Serializer
  attributes :id, :name, :date, :time, :calories, :user_id
end
