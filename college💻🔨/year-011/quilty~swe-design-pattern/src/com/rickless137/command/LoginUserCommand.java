package com.rickless137.command;

import com.rickless137.quilty.User;
import com.rickless137.service.UserService;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class LoginUserCommand implements Command {

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse repsonse) {
		UserService userService = new UserService();
		String forwardToJsp = "";

		String username = request.getParameter("username");
		String password = request.getParameter("password");

		//Check we have a username and password...
		if (username != null && password != null){
			//Make call to the 'Model' using the UserServive class to login...
			User userLoggingIn = userService.login(username, password);

			if (userLoggingIn != null){

				//If login successful, store the session id for this client...
				HttpSession session = request.getSession();
				String clientSessionId = session.getId();
				session.setAttribute("loggedSessionId", clientSessionId);

				session.setAttribute("user", userLoggingIn);

				// on success, print their friends if they have any
				forwardToJsp = (new ShowFriendsCommand()).execute(request, repsonse);
				System.out.println(forwardToJsp);
			}
			else{
				forwardToJsp = "/loginFailure.jsp";
			}
		}
		else {
			forwardToJsp = "/loginFailure.jsp";
		}
		return forwardToJsp;
	}
}