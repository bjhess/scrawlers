class Favorite < ActiveRecord::Base
  belongs_to :user
  belongs_to :favoritable, :polymorphic => true

  def validate
    if ('User' == favoritable_type) && (user_id == favoritable_id)
      errors.add_to_base("Can't favorite oneself!")
    elsif ('Story' == favoritable_type) && (user_id == Story.find(favoritable_id).user_id)
      errors.add_to_base("Can't favorite one's own stories!")
    end
  end
end
