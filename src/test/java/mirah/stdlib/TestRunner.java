package mirah.stdlib;

import org.junit.Test;

public class TestRunner{
  @Test
  public void testMethod() throws Exception{
    MirahTester.executeMirahTestsForPackage("mirah.stdlib");
  }
}
