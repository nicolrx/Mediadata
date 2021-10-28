class AddSlugColumnToPublication < ActiveRecord::Migration[6.1]
  def change
    add_column :publications, :slug, :string
  end
end
