# == Schema Information
#
# Table name: cities
#
#  id         :integer          not null, primary key
#  country_id :integer
#  name       :string(255)      not null
#  longitude  :decimal(10, 6)
#  latitude   :decimal(9, 6)
#  region     :string(255)
#

require 'spec_helper'

describe City do
  pending "add some examples to (or delete) #{__FILE__}"
end
