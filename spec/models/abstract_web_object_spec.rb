require 'rails_helper'

RSpec.describe AbstractWebObject, type: :model do
    it { expect(AbstractWebObject).to be_actable }
    it { should belong_to(:user).
                dependent(:destroy).
                touch(true).
                required(false)
    }
end
