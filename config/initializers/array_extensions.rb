class Array
  def first!(count)
    return_value = self.first(count)
    0.upto(count-1) do
      break if self.empty?
      self.shift
    end
    return return_value
  end
end