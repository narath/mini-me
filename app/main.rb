# Click the Run game! button to execute the code.

WIDTH = 1280
HEIGHT = 720

class Person
    attr_accessor :infected, :change_x, :change_y
    attr_reader :show_infected_for
    attr_sprite
    
    PREVALENCE = 7
    SIZE = 25
    SHOW_INFECTED_FOR = 10
    
    def initialize
        @x = rand(WIDTH)
        @y = rand(HEIGHT)
        @w = SIZE
        @h = SIZE
        @infected = rand(100) < PREVALENCE
        @change_x = rand(5) - 2
        @change_y = rand(5) - 2
        @path = 'sprites/person.png'
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
        @path = "sprites/person-exposed.png"
        @show_infected_for = @show_infected_for - 1
      else
        if @infected
          @path = "sprites/person-infected.png"
        else
          @path = "sprites/person.png"
        end
      end
      outputs.sprites << self
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

    # check if I have been infected
    def check(people)
      return if @infected

      if people.any? { |other| other.infected and other.intersect_rect?(self) }
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

      # let people move smoothly, only check for collision after they have moved a max of 8 pixels
      # you can miss some, but only if they have "grazed each other" which could be considered realistic
      if args.state.tick_count % 4 == 0
        p.check(args.state.people)
      end
    end
end



