ActiveAdmin.register Product do
  index title: "All Products " do
    selectable_column
    id_column
  
    column "Image" do |image|
      
      image_tag(image.image, style: 'width: 100px; height: 100px;') if image.image.attached?
    end

    column 'Download CSV' do |resource|
      link_to 'Download', download_csv_admin_product_path(resource)
    end
    
    actions
  end

  show title: "Products details" do
    attributes_table do
      row :title
 
      row "Image" do |image|
        image_tag(image.image, style: 'width: 100px; height: 100px;') if image.image.attached?
      end 
      
    end
  end

  
  filter :title

  permit_params  :image

  form title: "Product Form" do |f|
    f.inputs "Product" do
    
      f.input :image, as: :file
    end
    f.actions
  end



  action_item :import_csv, only: :index do
    link_to 'Import CSV', action: 'import_csv'
  end
  collection_action :import_csv do
    render 'admin/import_csv'
  end
  collection_action :process_csv, method: :post do
  
    csv_file = params[:csv_file].tempfile
    CSV.foreach(csv_file.path, headers: true) do |row|
      Product.create!(row.to_hash)
    end
    redirect_to admin_products_path, notice: 'CSV imported successfully!'
  end



  member_action :download_csv, method: :get do
    csv_data = CSV.generate(headers: true) do |csv|
      csv << ['title']
      csv << [resource.title]
    end
    send_data csv_data, filename: "client_#{resource.id}_data.csv"
  end
end
 