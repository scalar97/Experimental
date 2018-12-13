package test;

import net.sourceforge.argparse4j.ArgumentParsers;
import net.sourceforge.argparse4j.inf.*;

class Parser {
	private ArgumentParser parser;
	private String[] args;

	Parser(String[] args) {
		init();
		this.args = args;
	}

	private void init() {
		parser = ArgumentParsers.newFor("quilty")
				.build()
				.defaultHelp(true)
				.description("Attempts to stop procrastination.");

		ArgumentGroup addTask = parser.addArgumentGroup("add task operation");
		addTask.addArgument("-c", "--category")
				.nargs(1)
				.choices("c", "u")
				.setDefault("c")
				.help("categories to classify the task in.");
		addTask.addArgument("-d", "--description")
				.nargs("*")
				.help("The description of the task being added.");


		MutuallyExclusiveGroup operation = parser.addMutuallyExclusiveGroup().required(true);
		operation.addArgument("-l", "--last")
				.dest("--operation")
				.nargs("?")
				.setConst("-l")
				.help("displays the latest procrastinated task.");
		operation.addArgument("-p", "--pop")
				.dest("--operation")
				.setConst("-p")
				.nargs("?")
				.help("removes the latest task from the procrastination stack and displays it.");
		operation.addArgument("-a", "--add")
				.dest("--operation")
				.setConst("-a")
				.nargs("?")
				.help("add a task.");
		parser.setDefault("--operation", "-l");
	}

	Namespace parse() throws ArgumentParserException {
		return this.parser.parseArgs(this.args);
	}
}