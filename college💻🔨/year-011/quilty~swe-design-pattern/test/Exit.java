package test;


public class Exit {
	public static void main(String[] args) {
		//DO SOMETHING: write the last task ID, or check if always returns last first?
		//DO SOMETHING: how to parse proprietary files in java?
		Runtime.getRuntime().addShutdownHook(new Thread(() -> System.out.println("\nDO SOMETHING: Exit..")));
	}
}