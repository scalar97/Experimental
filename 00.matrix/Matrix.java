// package 00.matrix;
// class definition
// this means that this class can be used outside of the Matrix class
public class Matrix
{
	// making the fieds private garentees that it can only be accessed inside the class
	// encapsulating a matrix iside the class 
	private int rows;
	private int cols;
	// making a 2 D array to encapsulate the matrix
	private double[][] elements;

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
		/** Returns a copy of the calling Matrix */
		Matrix newMatrix = new Matrix(this.getRows(), this.getCols());
		
		for(int i=0; i< newMatrix.getRows(); i++)
			for(int j=0; j< newMatrix.getCols(); j++)
				newMatrix.elements[i][j] = this.elements[i][j];
		
		return newMatrix;
	}
	
	public void identity(){
		/** Trnasforms a square matrix into an identity or throws an exception
		  *	for a non square matrix */
		if (this.isSquare())
			for(int i = 0; i < this.getRows(); i++)
				elements[i][i] = 1;
		else
			throw new IllegalArgumentException("The matrix is not Square");
	}
	
	public String toString(){
		/** Returns a string representation of the matrix */
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
	
	public Matrix add(Matrix other){
		/** Adds two matrices of the same size. 
		  * Throws an exception if the sizes are different */
		if(this.isSize(other)){
			for(int i=0; i< this.getRows(); i++){
				for (int j=0; j< this.getCols(); j++){
					this.elements[i][j] += other.elements[i][j];
				}
			}
			return this;
		}
		else
			throw new IllegalArgumentException("Matrix incompatible for addition");
	}

	// a static method is a method that you call on a class rather than the object
	public static Matrix add(Matrix matrix1, Matrix matrix2){
		return matrix1.clone().add(matrix2);
	}
	
	public Matrix scalarMul(double scalar){
		/** Returns the original matrix multiplied by a scalar */	
		for(int i=0; i< this.getRows(); i++){
			for (int j=0; j< this.getCols(); j++)
				this.elements[i][j] *= scalar;
		}
		return this;
	}
	
	public Matrix sub(Matrix other){
		/**Substractes a matrix using the rule A-B = A+(-B) */
		return this.add(other.clone().scalarMul(-1));
	}

	private double getsum_helper(Matrix other, int start, int end){
		/** Helper function to get the partial sum for matrix multiplication method */
		double sum = 0;
		int i=0;
		while(i < this.getCols()){
			sum += this.elements[start][i] * other.elements[i][end];
			i++;
		}
		return sum;
	}
	
	public Matrix mul(Matrix other){
		/** Returns a Matrix product of two matrices compatible for multiplication
		  * Throws an error if they are not compatible. */
		if (this.isMulCompatible(other)){
			Matrix answer = new Matrix(this.getRows(), other.getCols());
			for (int x = 0; x < answer.getRows(); x++){
				for(int y = 0; y< answer.getCols(); y++){
					answer.elements[x][y] = this.getsum_helper(other,x,y);
				} 
			}
			return answer;
		}
		throw new IllegalArgumentException("Matrix incompatible for multiplication");
	}
}

/* OUTPUT

Matrix 1: 
[ 2.0, 1.0 ]
[ 3.0, 0.0 ]

Matrix 2: 
[ 1.0 ]
[ 5.0 ]

Matrix 3: 
[ 0.0, 3.0 ]
[ 3.0, 6.0 ]

Matrix 1 * Matrix 2: 
[ 7.0 ]
[ 3.0 ]

Matrix 1 * Matrix 3: 
[ 3.0, 12.0 ]
[ 0.0, 9.0 ]

Matrix 3 + Matrix 1: 
[ 2.0, 4.0 ]
[ 6.0, 6.0 ]

Matrix 3 - Matrix 1: 
[ 0.0, 3.0 ]
[ 3.0, 6.0 ]

Matrix 2 * 3 (Multiplication by scalar): 
[ 3.0 ]
[ 15.0 ]

Matrix 3 and Matrix 1 have the same size:true
Matrix 3 and Matrix 2 have the same size:false
Matrix 3 and Matrix 2 are compatible for multiplication:true
Matrix 2 frist and Matrix 1 second are compatible for multiplication:false
Matrix 1 is a Square Matrix:true
Matrix 2 is a Square Matrix:false

Matrix 1's clone:
[ 2.0, 1.0 ]
[ 3.0, 0.0 ]

*/
