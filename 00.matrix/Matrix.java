//package 00.matrix;

// class definition
// this means that this class can be used outside of the Matrix class
public class Matrix
{
    // making the fieds private garentees that it can only be accessed inside this class
    // as well as inherited classes.
    // encapsulating a matrix inside the class 
    private int rows;
    private int cols;
    private double[][] elements;
    
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
          *    for a non square matrix */
        if (this.isSquare())
            for(int i = 0; i < this.getRows(); i++)
                elements[i][i] = 1;
        else
            throw new IllegalArgumentException("The matrix is not Square");
    }
    
    public String toString(){
        /** Returns a string representation of the matrix */
        StringBuilder ret= new StringBuilder();
        
        for(int i = 0; i< this.getRows(); i++){
            ret.append("[ ");
            for(int j = 0; j< this.getCols(); j++){
                if(j < this.getCols()-1)
                    ret.append(this.elements[i][j]).append(", ");
                else
                    ret.append(this.elements[i][j]).append(" ]\n");
            }
        }
        return ret.toString();
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
        
        for(int i=0;i < this.getCols(); i++) {
            sum += this.elements[start][i] * other.elements[i][end];
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
