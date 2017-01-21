class Graph
  attr_accessor :data, :origin
  @@fix = 3600000

  # Example of data: [{date: Time.now, value: 50}]
  def initialize(origin, data)
    @origin = origin
    @data = data
  end

  def render
    [[@origin.to_date.to_time.to_i*1000+@@fix, 0]] + @data.map do |d|
      [d.date.to_time.to_i*1000+@@fix, d.value.to_i]
    end + [[Time.now.to_date.to_time.to_i*1000+@@fix, 0]]
  end

  def accumulation
    accumulation = 0
    [[@origin.to_date.to_time.to_i*1000+@@fix, 0]] + @data.map do |d|
      accumulation += d.value.to_i
      [d.date.to_time.to_i*1000+@@fix, accumulation]
    end + [[Time.now.to_date.to_time.to_i*1000+@@fix, accumulation]]
  end
end
