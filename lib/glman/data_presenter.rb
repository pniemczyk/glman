require 'awesome_print'

module Glman
  class DataPresenter
    def self.show(object, options)
      ap object, options
    end
  end
end