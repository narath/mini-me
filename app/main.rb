# Click the Run game! button to execute the code.

WIDTH = 1280
HEIGHT = 720

class Person
    attr_accessor :x, :y, :infected, :change_x, :change_y
    attr_reader :show_infected_for
    attr_sprite
    
    PREVALENCE = 7
    SIZE = 25
    SHOW_INFECTED_FOR = 10
    
    def initialize(x: nil, y: nil, infected: nil, change_x: nil, change_y: nil)
        @x = x || rand(WIDTH)
        @y = y || rand(HEIGHT)
        @infected = infected || rand(100) < PREVALENCE
        @change_x = change_x || rand(10) - 5
        @change_y = change_y || rand(10) - 5
        self.path = 'sprites/person.png'
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

    def show(outputs)
      if @show_infected_for > 0
        outputs.sprites << [@x, @y, SIZE, SIZE, "sprites/person-exposed.png"]
        @show_infected_for = @show_infected_for - 1
      else
        if @infected
          outputs.sprites << [@x, @y, SIZE, SIZE, "sprites/person-infected.png"]
        else
          outputs.sprites << [@x, @y, SIZE, SIZE, "sprites/person.png"]
        end
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

      if people.any? { |other| other.infected and other.rect.intersect_rect?(self.rect) }
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



