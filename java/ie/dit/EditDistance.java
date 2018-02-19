package ie.dit;

public class EditDistance{

	// this function is static because it does not make sense
	// for the object to have it but the class itself
    private static double min3(double one, double two, double three){
        //return Math.min(Math.min(a, b), c);
        if ((one <= two) && (one <= three)){
            return one;
        }else if ((two <= one) && (two <= three)){
            return two;
        }else{
            return three;
        }
    }

    public static int MinimumEditDistance(String a, String b){
        int rows = a.length() + 1;
        int cols = b.length() + 1;
        Matrix m = new Matrix(rows, cols);

        for (int row = 0 ; row < rows ; row ++){
            m.setElement(row, 0, row);
        }
        for (int col = 0 ; col < cols ; col ++){
            m.setElement(0, col, col);
        }

        for(int row = 1; row < rows ; row ++){
            for (int col = 1 ; col < cols; col++){
                if (a.charAt(row - 1) == b.charAt(col - 1)){
                    m.setElement(row, col, m.getElement(row - 1, col -1));
                }else{
                    double min = min3( m.getElement(row-1,col)
                        , m.getElement(row-1, col-1)
                        , m.getElement(row,col-1));
					
                    m.setElement(row,col,min+1);
                }
            }
        }
        return (int) m.getElement(rows-1, cols-1);
    }
}
