class ChangeQuestionsAndAnswersToText < ActiveRecord::Migration
  def self.up
    change_column :questions, :title, :text
    change_column :questions, :answer, :text
  end

  def self.down
    change_column :questions, :title, :string
    change_column :questions, :answer, :string
  end
end
