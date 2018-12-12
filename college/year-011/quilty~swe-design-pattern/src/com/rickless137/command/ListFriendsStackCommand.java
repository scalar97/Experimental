package com.rickless137.command;

import com.rickless137.quilty.Task;
import com.rickless137.service.UserService;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.util.ArrayList;

public class ListFriendsStackCommand implements Command {

@Override
public String execute(HttpServletRequest request, HttpServletResponse response) {
		UserService userService = new UserService();
		// get their name from the request
		String friend_username = request.getParameter("friend_username");

		ArrayList<Task> theirStack = userService.listMyFriendStack(friend_username);
		request.getSession().setAttribute("theirStack", theirStack);
		request.getSession().setAttribute("last_friend_viewed", friend_username);

		return "/friendStack.jsp"; // forward to jsp file
	}
}
