require 'points_inside_polygon'
require 'byebug'
describe Polygon do
  describe "#initialize" do
    it "should respond to new method" do
      expect(Polygon).to respond_to(:new)
    end

    it "should accept points as arguments" do
      expect(Polygon).to respond_to(:new).with(3).arguments
      expect(Polygon).to respond_to(:new).with(88).arguments
    end

    it "should raise error to non array inputs" do
      expect{Polygon.new("abc")}.to raise_error(ArgumentError)
    end

    it "should raise error to fewer than three inputs" do
      expect{Polygon.new([0,0], [0,10])}.to raise_error(ArgumentError)
    end
  end

  describe "#vertices" do
    let(:polygon) { Polygon.new([0,0], [0,10], [10,10], [10,0]) }

    it "should respond to vertices method" do
      expect(polygon).to respond_to(:vertices)
    end

    it "should return an array" do
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
          (1..9).each do |y|
            expect(polygon.within?(x,y)).to be(true)
          end
        end
      end

      it "should return true for any decimal points within" do
        100.times {|| expect(polygon.within?(rand * 10, rand * 10)).to be(true)}
      end

      it "should return true for integer points at the border - vertical" do
        [0, 10].each do |border|
          (0..10).each do |int|
            expect(polygon.within?(border, int)).to be(true)
          end
        end
      end

      it "should return true for integer points at the border - horizontal" do
        [0, 10].each do |border|
          (0..10).each do |int|
            expect(polygon.within?(int, border)).to be(true)
          end
        end
      end

      it "should return true for decimal points at the border - vertical" do
        [0, 10].each do |border|
          expect(polygon.within?(border, rand * 10)).to be(true)
        end
      end

      it "should return true for decimal points at the border - horizontal" do
        [0, 10].each do |border|
          expect(polygon.within?(rand * 10, border)).to be(true)
        end
      end
    end

    describe "points outside" do
      it "should return false for integer points outside" do
        [-2, -1, 11, 12].each do |x|
          [-2, -1, 11, 12].each do |y|
            expect(polygon.within?(x,y)).to be(false)
          end
        end
      end

      it "should return false for decimal points just outside - vertical" do
        [0, 10].each do |border|
          10.times do
            offset = (border == 0 ? -1 : 1 ) * rand / 1000
            expect(polygon.within?(border + offset, rand * 10)).to be(false)
          end
        end
      end

      it "should return false for decimal points just outside - horizontal" do
        [0, 10].each do |border|
          10.times do
            offset = (border == 0 ? -1 : 1 ) * rand / 1000
            expect(polygon.within?(rand * 10, border + offset)).to be(false)
          end
        end
      end

      it "should return false for points inline with a border - vertical" do
        expect(polygon.within?( 0, 11)).to be(false)
        expect(polygon.within?(10, 11)).to be(false)
        expect(polygon.within?( 0, -1)).to be(false)
        expect(polygon.within?(10, -1)).to be(false)
      end

      it "should return false for points outside but inline with a border - vertical" do
        [0, 10].each do |border|
          10.times do
            offset = (border == 0 ? -1 : 1 ) * rand / 1000
            expect(polygon.within?(border, border)).to be(true)
            expect(polygon.within?(border, border + offset)).to be(false)
          end
        end
      end

      it "should return false for points inline with a border - horizontal" do
        expect(polygon.within?(11,  0)).to be(false)
        expect(polygon.within?(11, 10)).to be(false)
        expect(polygon.within?(-1,  0)).to be(false)
        expect(polygon.within?(-1, 10)).to be(false)
      end

      it "should return false for points outside but inline with a border - horizontal" do
        [0, 10].each do |border|
          10.times do
            offset = (border == 0 ? -1 : 1 ) * rand / 1000
            expect(polygon.within?(border, border)).to be(true)
            expect(polygon.within?(border + offset, border)).to be(false)
          end
        end
      end
    end
  end

  describe "#within? complex cases" do
    describe "simple 1 - right isosceles triangle" do
      let(:polygon) { Polygon.new([0,0], [10,10], [10,0]) }

      it "should return true for integer points at corners" do
        expect(polygon.within?(0, 0)).to be(true)
        expect(polygon.within?(10, 10)).to be(true)
        expect(polygon.within?(10, 0)).to be(true)
      end

      it "should return true for integer points within" do
        (1..9).each do |x|
          (1..x-1).each do |y|
            expect(polygon.within?(x, y)).to be(true)
          end
        end
      end

      it "should return true for integer points on diagonal" do
        (1..9).each do |x|
          expect(polygon.within?(x, x)).to be(true)
        end
      end

      it "should return false for integer points not within" do
        (1..9).each do |x|
          (x+1..10).each do |y|
            expect(polygon.within?(x, y)).to be(false)
          end
        end
      end
    end

    describe "simple 2 - right isosceles triangle" do
      let(:polygon) { Polygon.new([10,0], [0,10], [10,10]) }

      it "should return true for integer points at corners" do
        expect(polygon.within?(10, 10)).to be(true)
        expect(polygon.within?(0, 10)).to be(true)
        expect(polygon.within?(10, 0)).to be(true)
      end

      it "should return true for integer points within" do
        (1..9).each do |x|
          (10-x..9).each do |y|
            expect(polygon.within?(x, y)).to be(true)
          end
        end
      end

      it "should return true for integer points on diagonal" do
        (1..9).each do |x|
          expect(polygon.within?(x, 10-x)).to be(true)
        end
      end
    end

    describe "complex 3 - right triangle" do
      let(:polygon) { Polygon.new([0,0], [12,9], [12,0]) }

      it "should return true for integer points at corners" do
        expect(polygon.within?(0, 0)).to be(true)
        expect(polygon.within?(12, 9)).to be(true)
        expect(polygon.within?(12, 0)).to be(true)
      end

      it "should return true for decimal points on diagonal" do
        (0..12).each do |x|
          expect(polygon.within?(x, x / 4 * 3)).to be(true)
        end
      end
    end

    describe "complex 4 - diamond" do
      let(:polygon) { Polygon.new([0,5], [-5, 0], [0,-5], [5,0]) }

      it "should return true for integer points at corners" do
        expect(polygon.within?( 0,  5)).to be(true)
        expect(polygon.within?( 0, -5)).to be(true)
        expect(polygon.within?( 5,  0)).to be(true)
        expect(polygon.within?(-5,  0)).to be(true)
      end

      it "should return true for the origin 0, 0" do
        expect(polygon.within?(0, 0)).to be(true)
      end

      it "should return true for these unit positions" do
        expect(polygon.within?(0,  1)).to be(true)
        expect(polygon.within?(0, -1)).to be(true)
        expect(polygon.within?(-1, 0)).to be(true)
        expect(polygon.within?( 1, 0)).to be(true)
      end

      it "should return true for points lying on the x-axis" do
        (-12..12).each do |x|
          expect(polygon.within?(x / 3.0, 0)).to be(true)
        end
      end

      it "should return true for points lying on the y-axis" do
        (-12..12).each do |y|
          expect(polygon.within?(0, y / 3.0)).to be(true)
        end
      end

      it "should return true for any circular points lying inside" do
        radius = Math.sqrt((5 * 5) / 2)
        (0...360).each do |d|
          x = Math.cos(Math::PI * d / 180) * 1
          y = Math.sin(Math::PI * d / 180) * 1
          expect(polygon.within?(x, y)).to be(true)
        end
      end

      it "should return false for any circular points lying outside" do
        radius = 5.000000001
        (0...360).each do |d|
          x = Math.cos(Math::PI * d / 180) * radius
          y = Math.sin(Math::PI * d / 180) * radius
          expect(polygon.within?(x, y)).to be(false)
        end
      end
    end

    describe "complex 5 - boat" do

    end
  end
end
