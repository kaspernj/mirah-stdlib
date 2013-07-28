package mirah.stdlib

import org.junit.Test
import org.junit.Assert

$TestClass
class TestArray
  $Test
  def testAdd_and_basics:void
    num_2 = Integer.new(2)
    
    arr = Array.new
    arr.push(Integer.new(1))
    arr.push(num_2)
    arr.push(Integer.new(3))
    arr.push(Integer.new(4))
    arr[4] = Integer.new(5)
    #arr[] = Integer.new(6)
    
    Assert.assertEquals(arr.length, 5)
    Assert.assertEquals(1, arr.count(num_2))
    Assert.assertEquals(arr[2], Integer.new(3))
    Assert.assertEquals(arr[4], Integer.new(5))
    
    
    #Test include.
    Assert.assertTrue(arr.include?(num_2))
    Assert.assertFalse(arr.include?(Integer.new(99)))
    
    
    #Test slicing.
    sliced_arr = arr.slice(0, 2)
    sliced_arr2 = arr[0, 2]
    
    Assert.assertEquals(sliced_arr.length, sliced_arr2.length)
    Assert.assertEquals(sliced_arr.length, 2)
    Assert.assertEquals(sliced_arr.fetch(0), Integer.new(1))
    Assert.assertEquals(sliced_arr.fetch(1), Integer.new(2))
    
    begin
      sliced_arr.fetch(2)
      raise "This should have failed."
    rescue IndexOutOfBoundsException
      #Ignore - expected.
    end
    
    sliced_arr[2] #This should not fail opposite to "fetch".
    
    
    #Test deletion of elements.
    num_2_again = arr.delete(num_2)
    Assert.assertEquals(4, arr.length)
    Assert.assertEquals(num_2, num_2_again)
    
    
    #Test shifting and popping.
    num_1 = Integer(arr.shift)
    Assert.assertEquals(1, num_1.intValue)
    Assert.assertEquals(3, arr.length)
    
    shift_arr = arr.shift(2)
    Assert.assertEquals(1, arr.length)
    Assert.assertEquals(2, shift_arr.length)
    Assert.assertEquals(3, Integer(shift_arr.fetch(0)).intValue)
    Assert.assertEquals(4, Integer(shift_arr.fetch(1)).intValue)
    Assert.assertEquals(5, Integer(arr.fetch(0)).intValue)
  end
  
  $Test
  def test_collect:void
    arr = Array.new
    arr[0] = "0"
    arr[1] = "1"
    arr[2] = "2"
    arr[3] = "3"
    arr[4] = "4"
    
    collect_arr = arr.collect do |obj|
      obj_str = String(obj)
      return obj_str + "!"
    end
    
    Assert.assertEquals("0!", collect_arr[0])
    Assert.assertEquals("4!", collect_arr[4])
    Assert.assertEquals(5, collect_arr.length)
  end
  
  $Test
  def test_compact:void
    arr = Array.new
    arr[0] = "0"
    arr[1] = nil
    arr[2] = "2"
    arr[3] = "3"
    arr[4] = nil
    
    compact_arr = arr.compact
    
    Assert.assertEquals(5, arr.length)
    Assert.assertEquals(3, compact_arr.length)
    Assert.assertEquals(arr[0], compact_arr[0])
    Assert.assertEquals("2", compact_arr[1])
    Assert.assertEquals("3", compact_arr[2])
    Assert.assertEquals(nil, compact_arr[3])
  end
  
  $Test
  def test_pop:void
    arr = Array.new([:a, :b, :c, :d, :e, :f])
    
    pop1_val = arr.pop
    pop2_val = arr.pop
    Assert.assertEquals(:f, pop1_val)
    Assert.assertEquals(:e, pop2_val)
    
    pop1_multi = arr.pop(2)
    Assert.assertEquals(2, pop1_multi.length)
    Assert.assertEquals(:d, pop1_multi[0])
    Assert.assertEquals(:c, pop1_multi[1])
    
    pop2_multi = arr.pop(1)
    Assert.assertEquals(1, pop2_multi.length)
    Assert.assertEquals(:b, pop2_multi.first)
    
    Assert.assertEquals(1, arr.length)
    Assert.assertEquals(:a, arr.first)
  end
  
  $Test
  def test_delete_and_keep_if:void
    arr = Array.new([:a, :b, :c, :d, :e, :f])
    Assert.assertEquals(6, arr.length)
    
    keep_if_res = arr.keep_if do |ele|
      return true if !ele.equals(:c)
      return false
    end
    
    Assert.assertEquals(5, arr.length)
    Assert.assertFalse(arr.include?(:c))
    Assert.assertTrue(arr.include?(:b))
    Assert.assertEquals(1, keep_if_res.length)
    Assert.assertEquals(:c, keep_if_res[0])
    
    delete_if_res = arr.delete_if do |ele|
      return true if ele.equals(:d)
      return false
    end
    
    Assert.assertEquals(4, arr.length)
    Assert.assertFalse(arr.include?(:d))
    Assert.assertTrue(arr.include?(:b))
    Assert.assertEquals(1, delete_if_res.length)
    Assert.assertEquals(:d, delete_if_res[0])
  end
  
  $Test
  def test_eql:void
    arr1 = Array.new([:a, :b, :c])
    arr2 = Array.new([:a, :b, :c])
    arr3 = Array.new([:a, :b])
    arr4 = Array.new([:f, :g])
    
    Assert.assertTrue(arr1.eql?(arr2))
    Assert.assertTrue(arr2.eql?(arr1))
    Assert.assertFalse(arr1.eql?(arr3))
    Assert.assertFalse(arr1.eql?(arr4))
    Assert.assertFalse(arr3.eql?(arr1))
    Assert.assertFalse(arr4.eql?(arr1))
  end
  
  $Test
  def test_replace:void
    arr1 = Array.new([:a, :b, :c])
    arr1.replace(Array.new([:d, :e, :f, :g]))
    
    Assert.assertEquals(4, arr1.length)
    Assert.assertEquals(:d, arr1.first)
    Assert.assertEquals(:g, arr1.last)
  end
  
  $Test
  def test_join:void
    Assert.assertEquals("a;b;c", Array.new([:a, :b, :c]).join(";"))
  end
  
  $Test
  def test_sort:void
    arr = Array.new([:b, :c, :a])
    sarr = arr.sort
    
    Assert.assertEquals(:a, sarr[0])
    Assert.assertEquals(:b, sarr[1])
    Assert.assertEquals(:c, sarr[2])
    Assert.assertNull(sarr[3])
    
    
    arr = Array.new([Integer.new(2), Integer.new(3), Integer.new(1)])
    sarr = arr.sort do |ar, br|
      a = Integer(ar).intValue
      b = Integer(br).intValue
      
      if a < b
        return -1
      elsif a == b
        return 0
      else
        return 1
      end
    end
    
    Assert.assertEquals(Integer.new(1), sarr[0])
    Assert.assertEquals(Integer.new(2), sarr[1])
    Assert.assertEquals(Integer.new(3), sarr[2])
  end
  
  $Test
  def test_uniq:void
    arr = Array.new([:a, :a, :b, :b, :c])
    uarr = arr.uniq
    
    Assert.assertEquals(3, uarr.length)
    Assert.assertEquals(:a, uarr[0])
    Assert.assertEquals(:b, uarr[1])
    Assert.assertEquals(:c, uarr[2])
  end
  
  $Test
  def test_unshift:void
    arr = Array.new([:b, :c])
    arr.unshift(:a)
    
    Assert.assertEquals(3, arr.length)
    Assert.assertEquals(:a, arr[0])
    Assert.assertEquals(:b, arr[1])
    Assert.assertEquals(:c, arr[2])
  end
  
  $Test
  def test_shuffle:void
    arr1 = Array.new([:a, :b, :c, :d, :e, :f, :g, :h, :i, :l, :m])
    
    arr2 = Array.new
    arr1.each do |obj|
      arr2.push(obj)
    end
    
    arr3 = arr1.shuffle
    
    Assert.assertTrue(arr1.eql?(arr2))
    Assert.assertFalse(arr1.eql?(arr3))
    Assert.assertEquals(arr1.length, arr3.length)
    
    arr1.each do |obj|
      Assert.assertTrue(arr3.include?(obj))
    end
  end
end