require 'points_inside_polygon'

describe Polygon do
  describe "#initialize" do
    it "should respond to new method" do
      expect(Polygon).to respond_to(:new)
    end

    it "should accept points as arguments" do
      expect(Polygon).to respond_to(:new).with(3).arguments
      expect(Polygon).to respond_to(:new).with(88).arguments
    end
  end

  describe "#vertices" do
    it "should respond to points method" do
      expect(Polygon.new).to respond_to(:vertices)
    end

    it "should return an array" do
      polygon = Polygon.new
      expect(polygon.vertices).to be_a Array
    end

    it "should return a list of vertices" do
      points = [[0,0], [0,1], [1,1], [1,0]]
      polygon = Polygon.new(*points)
      expect(polygon.vertices).to eq(points)
    end
  end

  describe "#within?" do
    let(:polygon) { Polygon.new([0,0], [0,10], [10,10], [10,0]) }

    it "should respond to within method" do
      expect(polygon).to respond_to(:within?)
    end

    it "should accept exactly two arguments" do
      expect(polygon).to respond_to(:within?).with(2).arguments
      expect(polygon).not_to respond_to(:within?).with(1).arguments
      expect(polygon).not_to respond_to(:within?).with(3).arguments
    end

    describe "points within" do
      it "should return true for integer points within" do
        (1..9).each do |x|
          (0..9).each do |y|
            expect(polygon.within?(x,y)).to be(true)
          end
        end
      end

      it "should return false for integer points outside" do
        [-2, -1, 11, 12].each do |x|
          [-2, -1, 11, 12].each do |y|
            expect(polygon.within?(x,y)).to be(false)
          end
        end
      end
    end
  end
end
