# frozen_string_literal: true

RSpec.shared_examples 'it has a rezzable policy' do |model_name|
  subject { described_class }

  let(:user) { build(:user, expiration_date: 1.week.from_now) }
  let(:inactive_user) { build(:user, expiration_date: 1.week.ago) }
  let(:owner) { build(:owner) }

  let(:web_object) { build(model_name.to_sym) }
  permissions :show? do
    it 'allows an owner' do
      expect(subject).to permit(owner, web_object)
    end

    it 'allows an active user' do
      expect(subject).to permit(user, web_object)
    end

    it 'does not allow an active user' do
      expect(subject).to permit(inactive_user, web_object)
    end
  end

  permissions :index? do
    it 'allows an owner' do
      expect(subject).to permit(owner, web_object)
    end

    it 'allows an active user' do
      expect(subject).to permit(user, web_object)
    end

    it 'does not allow an active user' do
      expect(subject).to permit(inactive_user, web_object)
    end
  end

  permissions :create? do
    it 'allows an owner' do
      expect(subject).to permit(owner, web_object)
    end

    it 'allows an active user' do
      expect(subject).to permit(user, web_object)
    end

    it 'does not allow an active user' do
      expect(subject).not_to permit(inactive_user, web_object)
    end
  end

  permissions :update? do
    it 'allows an owner' do
      expect(subject).to permit(owner, web_object)
    end

    it 'allows an active user' do
      expect(subject).to permit(user, web_object)
    end

    it 'does not allow an active user' do
      expect(subject).not_to permit(inactive_user, web_object)
    end
  end

  permissions :destroy? do
    it 'allows an owner' do
      expect(subject).to permit(owner, web_object)
    end

    it 'allows an active user' do
      expect(subject).to permit(user, web_object)
    end

    it 'does not allow an active user' do
      expect(subject).to permit(inactive_user, web_object)
    end
  end
end
