class CreateQuestions < ActiveRecord::Migration
  def self.up
    create_table :questions do |t|
      t.column :title, :string
      t.column :title, :string
      t.column :priority, :integer
      t.column :faq_subsection_id, :integer
    end
  end

  def self.down
    drop_table :questions
  end
end
