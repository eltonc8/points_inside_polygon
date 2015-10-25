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

      elsif xs[0] == xs[1]
        #edge case 1 - the edge and x lies on the same line.
        return true if (ys.min..ys.max).cover?(y)

      elsif ys.max < y && !xs.include?(x)
        #line always crosses
        count += 1

      elsif ys[0] == ys[1] && y == ys[0]
        #edge case 2.
        return true

      else
        #find d(y) / d(x)
        slope = (ys[1] - ys[0]) / (xs[1] - xs[0]).to_f
        d_x = x - xs[0]
        p_y = slope * d_x + ys[0]
        return true if p_y == y #point x, y are at a line
        next if p_y > y
        #edge case 3. If x is aligned with a point in the polygon, count
        # only one set of lines. Use these rules:
        next if xs[0] == x && xs[0] - xs[1] > 0
        next if xs[1] == x && xs[1] - xs[0] > 0

        count += 1
      end
    end

    count.odd?
  end
end
