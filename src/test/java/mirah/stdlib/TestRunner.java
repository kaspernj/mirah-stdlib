package mirah.stdlib;

import org.junit.Test;

import mirah.stdlib.test_helpers.MirahTester;

public class TestRunner{
  @Test
  public void testMethod() throws Exception{
    MirahTester.executeMirahTestsForPackage("mirah.stdlib");
  }
}
