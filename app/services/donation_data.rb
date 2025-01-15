# frozen_string_literal: true

# Handles data processing for parcels
class DonationData
  # include DataHelper

  def self.donations_timeline(ids)
    data = Analyzable::Transaction.where(abstract_web_object_id: ids)
                                  .group_by_day(:created_at).sum(:amount)
    [data.keys.map { |k| k }, data.collect { |_k, v| v }]
  end

  def self.donation_count_histogram(ids)
    Analyzable::Transaction.where(abstract_web_object_id: ids).collect(&:amount)
  end

  def self.donor_count_histogram(ids)
    Analyzable::Transaction.where(abstract_web_object_id: ids)
                           .group(:target_key).sum(:amount).collect do |_k, v|
      v
    end
  end

  def self.donor_amount_count_scatter(ids)
    counts = Analyzable::Transaction.where(abstract_web_object_id: ids)
                                    .group(:target_key).count
    Analyzable::Transaction.where(abstract_web_object_id: ids)
                           .group(:target_key, :target_name).sum(:amount).collect do |k, v|
      { target_name: k.last, target_key: k.first, y: v, x: counts[k.first] }
    end
  end
end
