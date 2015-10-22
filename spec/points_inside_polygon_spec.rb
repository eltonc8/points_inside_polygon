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
end
