package com.rickless137.command;

import com.rickless137.exceptions.CommandCreationException;

public class CommandFactory {

	private static CommandFactory factory = null;

	private CommandFactory() {
	}

	/**
	 * Get an instance of the CommandFactory
	 * @return The singleton CommandFactory object
	 */
	public synchronized static CommandFactory getInstance() {
		if (factory == null) {      // first time

			factory = new CommandFactory();
		}
		return factory;
	}

	/**
	 *
	 * @param commandStr Identifier for the exact Command object required
	 * @return The specific Command object requested
	 * @throws CommandCreationException
	 */
	public synchronized Command createCommand(String commandStr) throws CommandCreationException {
		// factory to return the apporiate command specified by the front controller.
		Command command = null;
		String packageName = "com.rickless137.command.";

		try {
			commandStr = packageName + commandStr + "Command";

			// Instantiate 'a class object' that matches to the string class name constructed
			Class<?> theClass = Class.forName(commandStr);

			// Use 'the created class' above and create an object (instance of its type)
			// Unless an exception occurred, the returned object casted to (Command)
			// should be able to realise the Command interface by implementing execute
			Object theObject = theClass.newInstance();

			command = (Command) theObject;
		} catch (InstantiationException e) {
			throw new CommandCreationException("CommandFactory: " + e);
		} catch (IllegalAccessException e) {
			throw new CommandCreationException("CommandFactory: " + e);
		} catch (ClassNotFoundException e) {
			throw new CommandCreationException("CommandFactory: " + e);
		}

		//Return the instantiated Command object to the calling code...
		return command;		// may be null
	}
}
