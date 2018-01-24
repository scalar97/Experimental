//package intro.oop;
// class definition
// this means that this class can be used outside of the Matrix class
public class Matrix
{
	// making the fieds private garentees that it can only be accessed inside the class
	// encapsulating a matrix iside the class 
	private int rows;
	private int cols;
	// making a 2 D array to encapsulate the matrix
	private double [][] elements;



	public static void main(String[] args)
	{	
		Matrix matrix = new Matrix(3,3);
		matrix.identity();
		matrix.scalarMul(2);
		System.out.println(matrix);
	}



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
		this.elements[row][col] = val;
	}
	public double getElements(int row, int col){
		return this.elements[row][col];
	}
    // Constructor
	public Matrix (int rows, int cols){
		this.rows = rows;
		this.cols = cols;
		elements = new double[rows][cols];
	}

	public Matrix clone(){
		Matrix newMatrix = new Matrix(this.getRows(), this.getCols());
		
		for(int i=0; i< newMatrix.getRows(); i++)
			for(int j=0; j< newMatrix.getCols(); j++)
				newMatrix.elements[i][j] = this.elements[i][j];
		
		return newMatrix;
	}
	
	public void identity(){
		if (this.isSquare())
			for(int i = 0; i < this.getRows(); i++)
				elements[i][i] = 1;
		else
			throw new IllegalArgumentException("The matrix is not Square");
	}
	
	public String toString(){
		String ret="";
		
		for(int i = 0; i< this.getRows(); i++){
			ret += "[ ";
			for(int j = 0; j< this.getCols(); j++){
				if(j < this.getCols()-1)
					ret += this.elements[i][j] + ", ";
				else
					ret += this.elements[i][j] + " ]\n";
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
			for(int i=0; i< this.getRows(); i++){
				for (int j=0; j< this.getCols(); j++){
					this.elements[i][j] += other.elements[i][j];
				}
			}
		}
		else
			throw new IllegalArgumentException("Matrix incompatible for addition");
	}
	
	public void scalarMul(double scalar)
	{
		for(int i=0; i< this.getRows(); i++){
			for (int j=0; j< this.getCols(); j++)
				this.elements[i][j] *= scalar;
		}
	}
	
	public void sub(Matrix other)
	{
		Matrix newM = other.clone();
		newM.scalarMul(-1);
		this.add(newM);
	}

	private double getsum(Matrix other, int start, int end){
		double sum = 0;
		int i=0;
		while(i < this.getCols()){
			sum += this.elements[start][i] * other.elements[i][end];
			i++;
		}
		return sum;
	}
	
	public Matrix mul(Matrix other)
	{
		if (this.isMulCompatible(other)){
			Matrix answer = new Matrix(this.getRows(), other.getCols());
			for (int x = 0; x < answer.getRows(); x++){
				for(int y = x; y< answer.getCols(); y++){
					answer.elements[x][y] = answer.getsum(other,x,y);
				} 
			}
			return answer;
		}
		throw new IllegalArgumentException("Matrix incompatible for multiplication");
	}

	
	// a static method is a method that you call on a class rather than 
	// calling it on an object
	// this is called on two matrices.
	public static Matrix add(Matrix matrix1, Matrix matrix2)
	{
		Matrix newM = matrix2.clone();
		newM.add(matrix2);
		return newM;
	}	
}


//compile
//$javac ie.dit/*.java && java ie.dit.Main
