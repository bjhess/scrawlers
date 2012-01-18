class ChangeQuestionForeignKey < ActiveRecord::Migration
  def self.up
    rename_column :questions, :faq_subsection_id, :faq_section_id
  end

  def self.down
    rename_column :questions, :faq_section_id, :faq_subsection_id
  end
end
