class Group < ActiveRecord::Base

  has_many :members
  belongs_to :owner, class_name: 'Member'

end
