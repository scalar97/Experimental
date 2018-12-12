package com.rickless137.service;

import com.rickless137.quilty.Task;
import com.rickless137.quilty.User;
import com.rickless137.dao.UserDao;
import com.rickless137.exceptions.DaoException;

import java.util.ArrayList;

public class UserService {
	UserDao dao = new UserDao();
	public User login(String username, String password) {
		User u = null;
		try {
			u = dao.findUserByUsernamePassword(username, password);
		}
		catch (DaoException e) {
			e.printStackTrace();
		}
		return u;
	}

	public ArrayList<String> listMyFriends(String myUsername) {
		ArrayList<String> myFriends = null;
		try{
			myFriends = dao.getFriendsOfMine(myUsername);
		} catch (DaoException e) {
			e.printStackTrace();
		}
		return myFriends;
	}

	public ArrayList<Task> listMyFriendStack(String theirUsername) {
		ArrayList<Task> theirStack = null;
		try{
			theirStack = dao.showMyFriendsStack(theirUsername);
		} catch (DaoException e) {
			e.printStackTrace();
		}
		return theirStack;
	}
}