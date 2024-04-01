class User < ApplicationRecord
    has_many :portfolios
    has_many :stocks, through: :portfolios
end
