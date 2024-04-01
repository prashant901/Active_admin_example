class ProductsController < ApplicationController
    private
    def product_params
        params.require(:product).permit(:title ,:image)
      end

      
end
