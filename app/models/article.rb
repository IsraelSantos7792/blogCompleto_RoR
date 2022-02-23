# model Article using validates
class Article < ApplicationRecord
  validates :title, presence: true, length: { minimum: 10 }
  validates :body, presence: true, length: { minimum: 10 }
end
