package com.rickless137.command;

import com.rickless137.quilty.User;
import com.rickless137.service.UserService;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;

public class ShowFriendsCommand implements Command {

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) {
		UserService userService = new UserService();

		// get the currently logged in user's username from the session
		User loggedInUser = (User) request.getSession(false).getAttribute("user");
		ArrayList<String> myFriends = userService.listMyFriends(loggedInUser.getUsername());

		request.getSession().setAttribute("myFriends", myFriends);

		return "/logginSuccess.jsp"; // when the user logs in they see their friends
	}
}
