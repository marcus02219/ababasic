ActiveAdmin.register User do
  permit_params :email, :name, :user_type, :birthday, :diagnosis, :school, :photo

  index do
    selectable_column
    id_column
    column :email
    column :name
    column :user_type
    column :birthday
    column :diagnosis
    column :school
    column :photo
    column :created_at
    actions
  end

  filter :email
  filter :name
  filter :user_type
  filter :created_at

  form do |f|
    f.inputs "Admin Details" do
      f.input :email
      f.input :name
      f.input :user_type
    end
    f.actions
  end

end
