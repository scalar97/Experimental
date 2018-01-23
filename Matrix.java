package ie.dit;
// class definition
// this means that this class can be used outside of the Matrix class
public class Matrix implements Cloneable
{
	// making the fieds private garentees that it can only be accessed inside the class
	// encapsulating a matrix iside the class 
	private int rows;
	private int cols;
	// making a 2 D array to encapsulate the matrix
	private double [][] elements;
	
	// accessors are like getters and setters they use the private data that has been encacpsulated
	
	// Accessor
	public int getRows(){
		return rows;
	}

	public int getCols(){
		return cols;
	}
	
	// setters
	public void setElements(int row, int col, double val){
		elements[row][col] = val;
	}
	public void getElements(int row, int col, double val){
		return elements[row][col] = val;
	}
	
	// Constructor
	public Matrix (int rows, int cols){
		this.rows = rows;
		this.cols = cols;
		elements = new double[rows][cols];
	}
	
	public void identity(){
		if (this.isSquare())
			for(int i = 0; i < this.getRows(); i++)
				elements[i][i] = 1;
		else
			throw new IllegalArgumentException("The matrix is not Square");
	}
	
	public void toString(){
		String ret="";
		
		for(int i = 0; i< this.getRows(); i++)
		{
			ret = "[ ";
			for(int j =0; j< this.getCols(); j++){
				if(j < cols-1)
					ret += elements[rows][cols] + ",\t";
				else
					ret += elements[rows][cols] + " ]\n";
			}
		}
		return ret;
	}
	
	public boolean isSize(Matrix other){
		return this.getRows() == other.getRows() && this.getCols() == other.getCols();
	}
	
	public boolean isSquare(){
		return this.getRows() == this.getCols();
	}
	
	public boolean isMulCompatible(Matrix other){
		return this.getCols() == other.getRows();
	}
	
	public void add(Matrix other)
	{
		if(this.isSize(other)){
			for(int i=0, i< this.getRows(); i++){
				for (int j=0; j< this.getCols; j++){
					this.elements[i][j] += other.elements[i][j];
				}
			}
		}
		else
			throw new IllegalArgumentException("Matrix incompatible for addition");
	}
	
	public scalarMul(double scalar)
	{
		for(int i=0, i< this.getRows(); i++){
			for (int j=0; j< this.getCols(); j++)
				this.elements[i][j] *= scalar;
		}
	}
	
	public void sub(Matrix other)
	{
		this.add(other.clone().scalarMul(-1));
	}
	
	public Matrix mul(Matrix other)
	{
		if (this.isMulCompatible(other))
		{
			Matrix answer = new Matrix(this.getRows, other.getCols);
			
			double sum = 0;
			for (int col = 0; col < answer.s
			for (int i = 0; i< this.getRows(); i++){
				for (int j = i ; j< other.getCols(); j++){
					answer[i][col] += this.elements[i][j] * other.elements[i][j];
				}
			}
		}
	}
	// a static method is a method that you call on a class rather than 
	// calling it on an object
	// this is called on two matrices.
	public static Matrix add(Matrix matrix1, Matrix matrix2)
	{
		return matrix1.clone().add(matrix2); 
	}	
}



public class Main
{
	public static void main(String[] args)
	{
		
		Matrix matrix = new Matrix(3,3);
		matrix.identity();
		System.out.println(matrix);
		
		Matrix matrix2 = new Matrix(3,2);
		matrix2.setElement(2,1,100);
		matrix2.setElement(1,1,8);
		System.out.println(matrix2.getElemts(2,1));
		System.out.println(matrix2);
		
	}
}


// to compile this use 
$javac ie.dit/*.java
$java ie.dit.Main
