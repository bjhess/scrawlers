class RemoveFaqSubsections < ActiveRecord::Migration
  def self.up
    drop_table :faq_subsections
    add_column :faq_sections, :parent_id, :integer
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
