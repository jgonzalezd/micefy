# == Schema Information
#
# Table name: indications
#
#  id         :integer          not null, primary key
#  content    :text
#  kind       :string(255)
#  event_id   :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Indication do
  pending "add some examples to (or delete) #{__FILE__}"
end
