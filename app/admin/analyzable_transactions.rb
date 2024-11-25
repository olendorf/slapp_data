# frozen_string_literal: true

ActiveAdmin.register Analyzable::Transaction, as: 'Transaction' do
  decorate_with Analyzable::TransactionDecorator

  menu label: 'Transactions'

  actions :all, except: %i[new create delete destroy]

  index title: 'Transactions' do
    selectable_column
    column :amount
    column :balance
    column :previous_balance
    column :description
    column 'User' do |transaction|
      link_to transaction.user.avatar_name, admin_user_path(transaction.user)
    end
    column 'Target' do |transaction|
      target = User.find_by_avatar_key transaction.target_key
      if target
        link_to target.avatar_name, admin_user_path(target)
      else
        transaction.target_name
      end
    end
    column 'Originating object' do |transaction|
      if transaction.abstract_web_object
        web_object = transaction.abstract_web_object.actable
        object_type = web_object.class.name
                                .underscore.split('/').last
        link_to web_object.object_name, send("admin_#{object_type}_path", web_object)
      else
        'No object'
      end
    end
    column 'Object Type', &:web_object_type
    column :created_at
    column :updated_at
    actions
  end

  filter :user_avatar_name_cont, as: :string, label: 'Owner'
  filter :abstract_web_object_object_name_cont, as: :string, label: 'Object Name'
  filter :amount
  filter :target_name
  filter :description_cont, as: :string
  filter :web_object_type_cont
  filter :created_at

  show title: proc { |transaction| "#{transaction.target_name} (L$ #{transaction.amount})" } do
    attributes_table do
      row :amount
      row :balance
      row :previous_balance
      row :description
      row :transaction_type
      row 'User' do |transaction|
        link_to transaction.user.avatar_name, admin_user_path(transaction.user)
      end
      row 'Target' do |transaction|
        target = User.find_by_avatar_key transaction.target_key
        if target
          link_to target.avatar_name, admin_user_path(target)
        else
          transaction.target_name
        end
      end
      row 'Originating object' do |transaction|
        if transaction.abstract_web_object
          web_object = transaction.abstract_web_object.actable
          object_type = web_object.class.name
                                  .underscore.split('/').last
          link_to web_object.object_name, send("admin_#{object_type}_path", web_object)
        else
          'No object'
        end
      end
      row :created_at
      row :updated_at
    end
  end

  permit_params :description

  form title: proc { |transaction|
                "#{transaction.target_name} (L$ #{transaction.amount})"
              } do |f|
    f.inputs do
      f.input :description
    end
  end
end
