package mirah.stdlib.test_helpers;

import java.lang.reflect.Method;
import java.lang.reflect.Modifier;
import java.util.ArrayList;
import java.util.List;

public class TestRunClass{
  private Class<?> clazz;
  private List<Method> methods;
  private int failedMethods = 0;
  private ArrayList<Method> beforeMethods;
  private ArrayList<Method> afterMethods;
  
  public TestRunClass(Class<?> clazz, List<Method> methods){
    this.clazz = clazz;
    this.methods = methods;
    
    this.beforeMethods = new ArrayList<Method>();
    this.afterMethods = new ArrayList<Method>();
    findBeforeAndAfterMethods();
  }
  
  private void findBeforeAndAfterMethods(){
    for(Method method: clazz.getMethods()){
      if (!Modifier.isStatic(method.getModifiers())) continue;
      
      if (method.getName().length() >= 13 && method.getName().substring(0, 13).equals("before_class_")){
        beforeMethods.add(method);
      }
      
      if (method.getName().length() >= 12 && method.getName().substring(0, 12).equals("after_class_")){
        afterMethods.add(method);
      }
    }
  }
  
  public void execute(){
    try{
      runBefores();
      
      for(Method method: methods){
        executeMethod(method);
      }
    }finally{
      runAfters();
    }
  }
  
  private void executeMethod(Method method){
    TestRun run = new TestRun(clazz, method);
    run.execute();
    
    if (run.isFailed()){
      run.printCause();
      failedMethods += 1;
    }
  }
  
  public int methodsLength(){
    return methods.size();
  }
  
  public int failedMethodsLength(){
    return failedMethods;
  }
  
  private void runAfters(){
    for(Method method: afterMethods){
      System.out.println("Running after " + clazz.getSimpleName() + "." + method.getName() + "().");
      TestRunStatic run = new TestRunStatic(clazz, method);
      run.execute();
      
      if (run.isFailed()) run.print_cause();
    }
  }
  
  private void runBefores(){
    for(Method method: beforeMethods){
      System.out.println("Running before " + clazz.getSimpleName() + "." + method.getName() + "().");
      TestRunStatic run = new TestRunStatic(clazz, method);
      run.execute();
      
      if (run.isFailed()) run.print_cause();
    }
  }
}
