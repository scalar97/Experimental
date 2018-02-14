package ie.dit;

public class Main
{
	public void editDistance(){
		String sa = "I love DIT";
		String sb = "I love cats, all cats!";
		System.out.println("Edit distance between: " + sa + " and: " + sb + " is " + EditDistance.MinimumEditDistance(sa, sb));

		sa = "Dummy word";
		sb = "Imagine Cup";
		System.out.println("Edit distance between: " + sa + " and: " + sb + " is " + EditDistance.MinimumEditDistance(sa, sb));
	}

	public void dictionary(){
		Dictionary d = new Dictionary();
		System.out.println(d);

		System.out.println(d.findClosest("bread"));
		System.out.println(d.findClosest("militarry"));
		
	}
	public void strings(){
		String s = "I love Star Trek";

		System.out.println(s.length());
		System.out.println(s.contains("love"));
		System.out.println(s.contains("hate"));
		System.out.println(s.startsWith("I love"));
		System.out.println(s.endsWith("cats"));
		System.out.println(s.equals("Hello"));
		
		String ss = s.substring(7);

		System.out.println(ss);
		// Incorrect way to compare strings
		if (ss == "Star Trek"){
			System.out.println("Same");
		}else{
			System.out.println("Different");
		}
		// Correct way to compare strings
		if(ss.equalsIgnoreCase("Star Trek")){
			System.out.println("Same");
		}else{
			System.out.println("Different");
		}

		String dummyString = ss.substring(0, 5);
		System.out.println(ss.toUpperCase());

	}
	
	public void  matrixTest()
    {    
        Matrix m1 = new Matrix(2,2);
        Matrix m2 = new Matrix(2,1);
        Matrix m3 = new Matrix(2,2);
        m1.setElement(0,0,2);
        m1.setElement(0,1,1);
        m1.setElement(1,0,3);
        m1.setElement(1,1,0);

        m2.setElement(0,0,1);
        m2.setElement(1,0,5);
        
        for(int i=0; i< m3.getRows(); i++)
            for (int j=0; j< m3.getCols(); j++)
                m3.setElement(i,j,(j+i) * 3);
                
        System.out.println("Matrix 1: \n" + m1);
        System.out.println("Matrix 2: \n" + m2);
        System.out.println("Matrix 3: \n" + m3);
        System.out.println("Matrix 1 * Matrix 2: \n" + m1.mul(m2));
        System.out.println("Matrix 1 * Matrix 3: \n" + m1.mul(m3));
        System.out.println("Matrix 3 + Matrix 1: \n" + m3.add(m1));
        System.out.println("Matrix 3 - Matrix 1: \n" + m3.sub(m1));
        System.out.println("Matrix 2 * 3 (Multiplication by scalar): \n" + m2.scalarMul(3));
        System.out.print  ("Matrix 3 and Matrix 1 have the same size:" + m3.isSize(m1));
        System.out.print  ("\nMatrix 3 and Matrix 2 have the same size:" + m3.isSize(m2));
        System.out.print  ("\nMatrix 3 and Matrix 2 are compatible for multiplication:" + m3.isMulCompatible(m2));
        System.out.print  ("\nMatrix 2 frist and Matrix 1 second are compatible for multiplication:" + m2.isMulCompatible(m1));
        System.out.print  ("\nMatrix 1 is a Square Matrix:" + m1.isSquare());
        System.out.println("\nMatrix 2 is a Square Matrix:" + m2.isSquare());
        System.out.println("\nMatrix 1's clone:\n" + m1.clone());
    }

	public static void main(String[] args){
		Main main = new Main();
		//main.matrixMultiplication();
		//main.editDistance();
		main.strings();
		//main.dictionary();
	}
}
