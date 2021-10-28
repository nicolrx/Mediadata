class CreateArticles < ActiveRecord::Migration[6.1]
  def change
    create_table :articles do |t|
      t.references :publication, null: false, foreign_key: true
      t.references :author, null: false, foreign_key: true
      t.string :title
      t.string :url
      t.string :premium
      t.datetime :publication_date

      t.timestamps
    end
  end
end
