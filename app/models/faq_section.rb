class FaqSection < ActiveRecord::Base
  belongs_to :parent, 
             :class_name => "FaqSection",
             :foreign_key => :parent_id
  has_many :children,
           :class_name => "FaqSection",
           :foreign_key => :parent_id,
           :order => :priority,
           :dependent => :destroy
  has_many :questions, :order => :priority
end
