class Polygon
  def initialize(*vertices)
    @vertices = vertices
  end

  def vertices
    @vertices.map(&:dup)
  end
end
