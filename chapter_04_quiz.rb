def string_shuffle(s)
  s.split('').shuffle.join
end

class String
  def shuffle
    self.split('').shuffle.join
  end
end

person1 = { :first => "Leo", :last => "Ping"}
person2 = { :first => "Meggie", :last => "Hu" }
person3 = { :first => "Tristan", :last => "Ping" }
params = { :father => person1, :mother => person2, :child => person3 }

