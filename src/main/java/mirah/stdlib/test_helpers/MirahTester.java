package mirah.stdlib.test_helpers;

import static org.junit.Assert.assertTrue;

import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.Set;
import org.reflections.Reflections;

public class MirahTester{
  public static void executeMirahTestsForPackage(String pkg){
    Reflections reflections = new Reflections(pkg);
    Set<Class<? extends TestClass>> annotated = reflections.getSubTypesOf(TestClass.class);
    
    if (annotated.isEmpty()) throw new RuntimeException("No test-classes were found.");
    
    int countTests = 0;
    int failedTests = 0;
    boolean allPassed = true;
    
    // The test class- and method can be given as an env-variable.
    String mirahTest = System.getenv("MIRAHTEST");
    String testClassName = null;
    String testMethodName = null;
    
    if (mirahTest != null){
      String[] splitted = mirahTest.split("\\.");
      if (splitted.length == 1) testClassName = splitted[0];
      if (splitted.length == 2) testMethodName = splitted[1];
    }
    
    ArrayList<TestRunClass> testRunClasses = new ArrayList<TestRunClass>();
    
    System.err.println("Looking for test-classes.");
    for(Class<?> clazz: annotated){
      ArrayList<Method> methodsToRun = new ArrayList<Method>();
      scanMethods(testClassName, testMethodName, methodsToRun, clazz);
      
      if (methodsToRun.size() > 0){
        TestRunClass runClass = new TestRunClass(clazz, methodsToRun);
        testRunClasses.add(runClass);
      }
    }
    
    // Run the tests.
    for(TestRunClass testRunClass: testRunClasses){
      countTests += testRunClass.methodsLength();
      testRunClass.execute();
      failedTests += testRunClass.failedMethodsLength();
    }
    
    if (countTests <= 0){
      throw new RuntimeException("No tests were found to be executed.");
    }else{
      System.out.println("MirahTester: " + (countTests - failedTests) + "/" + countTests + " tests.");
    }
    
    assertTrue("All tests must pass.", allPassed);
  }
  
  private static void scanMethods(String testClassName, String testMethodName, ArrayList<Method> methodsToRun, Class<?> clazz){
    for(Method method: clazz.getMethods()){
      boolean run = false;
      
      System.out.println("Running: " + clazz.getSimpleName() + "." + method.getName());
      if (method.getName().length() >= 5 && method.getName().substring(0, 5).equals("test_")) run = true;
      
      if (run && testClassName != null && !clazz.getSimpleName().equals(testClassName)){
        System.out.println("Classname did not match: '" + clazz.getSimpleName() + "', '" + testClassName + "'.");
        run = false;
      }else if (run && testMethodName != null && !method.getName().equals(testMethodName)){
        System.out.println("Methodname did not match: '" + method.getName() + "', '" + testMethodName + "'.");
        run = false;
      }
      
      if (run) methodsToRun.add(method);
    }
  }
}