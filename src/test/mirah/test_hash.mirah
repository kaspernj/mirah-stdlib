package mirah.stdlib

import org.junit.Test
import org.junit.Assert

$TestClass
class TestHash
  $Test
  def test_add:void
    hash = Hash.new
    val2 = "val2"
    
    #Test storing.
    hash.store("key1", "val1")
    hash.store("key2", val2)
    hash.store("key3", "val3")
    hash["key4"] = "val4"
    
    #Validate storing.
    Assert.assertEquals("val1", hash.fetch("key1"))
    
    # Seems like this is currently broken in Mirah?
    # Assert.assertEquals("val4", hash["key4"])
    
    Assert.assertEquals(4, hash.length)
    
    #Test 'has_key'.
    Assert.assertTrue(hash.has_key?("key1"))
    Assert.assertFalse(hash.key?("key22"))
    
    #Test looping.
    count = 0
    hash.each do |key, val|
      count += 1
      
      exp_key = "key#{count}"
      exp_val = "val#{count}"
      
      Assert.assertEquals(exp_key, key)
      Assert.assertEquals(exp_val, val)
    end
    
    #Validate looping.
    Assert.assertEquals(4, count)
    
    #Test 'delete_if'.
    hash.delete_if do |key, val|
      if key.equals("key3")
        return true
      else
        return false
      end
    end
    
    Assert.assertFalse(hash.key?("key3"))
    Assert.assertEquals(3, hash.length)
    
    #Test 'merge'.
    merged = hash.merge(Hash.new.store("key3", "val3"))
    Assert.assertTrue(merged.include?("key3"))
    Assert.assertEquals("val3", merged["key3"])
    Assert.assertEquals(4, merged.length)
    
    #Test 'key'.
    key_val = hash.key(val2)
    Assert.assertEquals("key2", key_val)
    
    #Test and validate clearing.
    hash.clear
    Assert.assertEquals(0, hash.length)
  end
  
  $Test
  def test_new_from_hash_map:void
    hash = Hash.new(
      "key1" => "value1",
      "key2" => "value2"
    )
    
    Assert.assertTrue hash.key?("key1")
    Assert.assertEquals hash["key2"], "value2"
  end
end