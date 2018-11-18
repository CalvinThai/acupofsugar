class Blockee < ApplicationRecord
  belongs_to :user
  validates_uniqueness_of :blockee_id, scope: :user_id
end
