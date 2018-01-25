//package 00.matrix;

public class Main
{
	public static void main(String[] args)
    {    
        Matrix m1 = new Matrix(2,2);
        Matrix m2 = new Matrix(2,1);
        Matrix m3 = new Matrix(2,2);
        m1.setElements(0,0,2);
        m1.setElements(0,1,1);
        m1.setElements(1,0,3);
        m1.setElements(1,1,0);

        m2.setElements(0,0,1);
        m2.setElements(1,0,5);
        
        for(int i=0; i< m3.getRows(); i++)
            for (int j=0; j< m3.getCols(); j++)
                m3.setElements(i,j,(j+i) * 3);
                
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
}
