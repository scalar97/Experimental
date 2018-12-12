package com.rickless137.command;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public interface Command {
	// every class realising this interface has to implement the logic of execute
	// this execute is bound to execute http services only.
	String execute(HttpServletRequest request, HttpServletResponse response);
}
