class Polygon
  def initialize(*points)
    @points = points
  end

  def points
    @points.dup
  end
end
