package mirah.stdlib.test_helpers;

import java.lang.reflect.Method;

public class TestRun{
    private Class<?> clazz;
    private Method method;
    private Throwable error;
    private boolean failed = false;

    public TestRun(Class<?> clazz, Method method){
	this.clazz = clazz;
	this.method = method;
    }

    public void execute(){
	System.out.println("Running " + clazz.getSimpleName() + "."
		+ method.getName() + ".");

	try{
	    Object testInstance = clazz.getConstructor().newInstance();
	    method.invoke(testInstance);
	}catch(Exception e){
	    this.failed = true;
	    this.error = e.getCause();
	}
    }

    public void printCause(){
	System.err.println("Failed (" + error.getClass().getSimpleName()
		+ "): " + error.getMessage());
	error.printStackTrace(System.err);
    }

    public boolean isFailed(){
	return failed;
    }
}