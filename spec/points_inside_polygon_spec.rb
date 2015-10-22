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

end
