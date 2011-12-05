ActiveRecord::Schema.define do
  create_table(:posts, :force => true) do |t|
    t.text   :content
    t.timestamps
  end
end