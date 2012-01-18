class CreateFaqSections < ActiveRecord::Migration
  def self.up
    create_table :faq_sections do |t|
      t.column :title, :string
      t.column :priority, :integer
    end
  end

  def self.down
    drop_table :faq_sections
  end
end
