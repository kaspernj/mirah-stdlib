package mirah.stdlib.test_helpers;

import java.lang.reflect.Method;

public class TestRunStatic{
  private Class<?> clazz;
  private Method method;
  private Throwable error;
  private boolean failed = false;
  
  public TestRunStatic(Class<?> clazz, Method method){
    this.clazz = clazz;
    this.method = method;
  }
  
  public void execute(){
    System.out.println("Running " + clazz.getSimpleName() + "." + method.getName() + ".");
    
    try{
      method.invoke(clazz);
    }catch(Exception e){
      this.failed = true;
      this.error = e.getCause();
    }
  }
  
  public void print_cause(){
    System.out.println("Failed (" + error.getClass().getSimpleName() + "): " + error.getMessage());
    error.printStackTrace(System.err);
  }
  
  public boolean isFailed(){
    return failed;
  }
}
