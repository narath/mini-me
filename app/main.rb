# Click the Run game! button to execute the code.

WIDTH = 1280
HEIGHT = 720

class Color
    attr_accessor :r, :g, :b
    
    def initialize(r = 0, g = 0, b = 0)
        @r = r
        @g = g
        @b = b
    end
    
    def self.Red
        Color.new(255,0,0)
    end

    def self.Orange
      Color.new(255,127,80)
    end
    
    def self.Green
        Color.new(0,255,0)
    end

    def self.Black
      Color.new(0,0,0)
    end
    
end

class Person
    attr_accessor :x, :y, :infected, :change_x, :change_y
    attr_reader :show_infected_for
    
    PREVALENCE = 7
    SIZE = 25
    SHOW_INFECTED_FOR = 10
    
    def initialize(x: nil, y: nil, infected: nil, change_x: nil, change_y: nil)
        @x = x || rand(WIDTH)
        @y = y || rand(HEIGHT)
        @infected = infected || rand(100) < PREVALENCE
        @change_x = change_x || rand(10) - 5
        @change_y = change_y || rand(10) - 5
    end

    def serialize
      { x: @x, y: @y, infected: @infected, change_x: @change_x, change_y: @change_y, infected_at: @infected_at }
    end
    
    def inspect
      serialize.to_s
    end

    def to_s
      serialize.to_s
    end
    
    def color
        if @infected
            Color.Red
        else
            Color.Green
        end
    end
    
    def shape(grow=0, new_color=nil)
      c = new_color || color
      [@x, @y, SIZE+grow, SIZE+grow, c.r, c.g, c.b]
    end

    def border
      [@x, @y, SIZE, SIZE, Color.Black.r, Color.Black.g, Color.Black.b]
    end

    def show(outputs)
      if @show_infected_for > 0
        outputs.solids << shape(5, Color.Orange)
        @show_infected_for = @show_infected_for - 1
      else
        outputs.solids << shape
      end
    end

    def move!
      @x = @x + @change_x
      @y = @y + @change_y
      if @x<0
        @x = 0
        @change_x = @change_x * -1
      end
      if @x>WIDTH
        @x = WIDTH
        @change_x = @change_x * -1
      end
      if @y<0
        @y = 0
        @change_y = @change_y * -1
      end
      if @y>HEIGHT
        @y = HEIGHT
        @change_y = @change_y * -1
      end
    end

    def rect
      [@x, @y, SIZE, SIZE]
    end

    # check if I have been infected
    def check(people)
      return if @infected

      if people.any? { |other| other.rect.intersect_rect?(self.rect) and other.infected }
        @show_infected_for = SHOW_INFECTED_FOR
        @infected = true
      end
    end

end

def tick args
    args.state.people ||= Array.new(50) { Person.new }
    args.state.paused ||= false
    
    args.outputs.labels << [10,30, "People  = #{args.state.people.count}"]

    args.state.people.each do |p|
      p.show(args.outputs)
      p.move!
      p.check(args.state.people)
    end
end



