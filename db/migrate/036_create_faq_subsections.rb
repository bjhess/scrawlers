class CreateFaqSubsections < ActiveRecord::Migration
  def self.up
    create_table :faq_subsections do |t|
      t.column :title, :string
      t.column :priority, :integer
      t.column :faq_section_id, :integer
    end
  end

  def self.down
    drop_table :faq_subsections
  end
end
