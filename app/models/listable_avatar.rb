# frozen_string_literal: true

# Avatars that can be listed in lists such as access, managers etc.
class ListableAvatar < ApplicationRecord
  belongs_to :listable, polymorphic: true
  
end
