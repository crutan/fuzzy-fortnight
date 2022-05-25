class Trim < ApplicationRecord
  belongs_to :car

  def wheels_that_fit
    Wheel.where(
      bolt_pattern: bolt_pattern, 
      offset: (min_offset..max_offset), 
      diameter: (min_diameter..max_diameter), 
      width: (min_width..max_width)
    )
  end
end
