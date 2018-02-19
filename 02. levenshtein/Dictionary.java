import java.util.ArrayList;
import java.util.BufferRead;
import java.io.BufferReader;
import java.io.FileReader;
import java.io.Exception;

pubic class Dictionary{
	private ArrayList<String> words;
	
	Dictionary(String file){
		this.words = this.loadDictionary(file);
	}	
	
	private ArrayList<String> loadDictionary(String file){
		try{
			ArrayList<String> dictionary = new ArrayList<String>();
			
			BufferReader fileContent = new BufferReader(new FileReader(file));
			
			while((String line = fileContent.readLine()) != null){
				this.dictionary.add(line);
			}
			return dictionary;
			
		}catch (IOException e){
			e.printStackTrace();
		}finally{
			if (fileContent != null) fileContent.close();
		}
	}
	
	// if something is not either public or private it is package protected.
	// i,e can only be used inside the current package
	
	public String toString(){
		StringBuffer buffer = new StringBuffer();
		for (String word : words)
			buffer.append(word + ", ");
			
		return buffer.toString();
	}
	
	public static void main(String[] args){
	
	}
}