class Polygon
  def initialize(*vertices)
    vertices.each do |el|
      unless el.is_a?(Array) && el.length == 2 && el.all? {|i| i.is_a? Numeric}
        raise ArgumentError.new "expected argument format: [x, y]"
      end
    end
    if vertices.length < 3
      raise ArgumentError.new("at least three vertices expected")
    end

    @vertices = vertices
  end

  def vertices
    @vertices.map(&:dup)
  end

  def within?(x, y)
    #method - is the number of line crossings odd?
    count = 0

    #test each line to see if the point (x, y) lies to right of it.
    @vertices.length.times do |idx|
      pt1, pt2 = @vertices[idx], @vertices[(idx + 1) % @vertices.length]
      xs = [pt1[0], pt2[0]]
      ys = [pt1[1], pt2[1]]

      if !(xs.min..xs.max).cover?(x) || ys.min > y
        next #line never crosses

      elsif xs[0] == xs[1] && xs[0] == x
        #edge case 1 - the edge and x lies on the same line.
        return true if (ys.min..ys.max).cover?(y)

      elsif ys.max < y
        #line always crosses
        count += 1

      elsif ys[0] == ys[1]
        #edge case 2. previous conditions imply that y == ys[0] == ys[1]
        return true

      else
        #find d(x) / d(y)
        slope = (xs[0] - xs[1].to_f) / (ys[0] - ys[1].to_f)
        d_x = pt1[0] + x.to_f
        p_y = slope * d_x + pt1[0]
        return true if p_y == y
        count += 1 if p_y < y
      end
    end

    count.odd?
  end
end
