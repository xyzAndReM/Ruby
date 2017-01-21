
class Seed
  attr_accessor :value,:left,:right,:l_child,:r_child,:lazy

  def initialize(left,right)
    @left, @right, @lazy,@value  =  left, right,0,0

    if(left != right)
      @l_child = Seed.new( left , (left+right)/2 )
	  @r_child = Seed.new( (left+right)/2 + 1 , right)
    end
  end

  def fullfill(array)
    @value =  array[@left..@right].inject(0, :+)
    if(@left != @right)
      @l_child.fullfill(array)
      @r_child.fullfill(array)
    end
  end

  def sum(l_array, r_array)
    wakeup!
    flag = check_within(l_array,r_array)
    if(flag == -1)
      return @value
    elsif(flag == 1)
      return @l_child.sum(l_array, r_array) + @r_child.sum(l_array, r_array)
    else
      return 0
    end
  end

  def update(l_array,r_array,diff)
    wakeup!
    flag = check_within(l_array,r_array)
    if(flag == -1)
      @value += diff*(@right - @left + 1)
      if(@left != @right)
        @l_child.lazy += diff
        @r_child.lazy += diff
      end
    elsif(flag == 1)
      @l_child.update(l_array, r_array,diff)
      @r_child.update(l_array, r_array,diff)
      @value = @l_child.value + @r_child.value
    end
  end

  def wakeup!
    if(@lazy != 0)
      @value += @lazy*(@right - @left + 1)
      if(@left != @right)
        @l_child.lazy += @lazy
        @r_child.lazy += @lazy
      end
      @lazy = 0
    end
  end

  def check_within(l,r)
    if(@left <= r && @left >= l && @right <=r && @right >= l)
      return -1
    elsif (@left > r  || @right < l)
      return 0
    else
      return 1
    end
  end
end

# def SegTree(n)
#   r = n-1
#   tree = Seed.new(0,r)
#   tree.fullfill(array)

#   return tree
# end

array = []
gets.scan(/-{,1}[\w']+/).each {|x| array << x.to_i}
n = array[0]
array.clear
for i in 1..n
  gets.scan(/-{,1}[\w']+/).each {|x| array << x.to_i}
  m = array[0]
  k = array[1]
  array.clear
  tree = Seed.new(1,m)
  for i in 1..k
    gets.scan(/-{,1}[\w']+/).each {|x| array << x.to_i}
    if(array[0] == 0)
      tree.update(array[1],array[2],array[3])
    else
      puts "#{tree.sum(array[1],array[2])}"
    end
    array.clear
  end
end
