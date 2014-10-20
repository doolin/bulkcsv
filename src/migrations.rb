class UserNodeScores < ActiveRecord::Migration
  def self.up
    create_table :user_node_scores do |t|
      t.float :score
      t.datetime :updated_at
      t.integer :node_id
      t.integer :user_id
    end
  end

  def self.down
    drop_table :user_node_scores
  end
end

unless UserNodeScores.table_exists?(:user_node_scores)
  ActiveRecord::Migrator.migrate(UserNodeScores.up)
end
