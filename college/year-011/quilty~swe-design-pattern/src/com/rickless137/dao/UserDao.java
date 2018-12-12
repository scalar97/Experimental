package com.rickless137.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;


import com.rickless137.quilty.Task;
import com.rickless137.quilty.User;
import com.rickless137.exceptions.DaoException;


public class UserDao extends Dao {

	Connection con = null;
	PreparedStatement ps = null;
	ResultSet rs = null;
	User u = null;

	public User findUserByUsernamePassword(String uname, String pword) throws DaoException {
		try {
			con = this.getConnection();

			String query = "SELECT * FROM USERS WHERE USERNAME = ? AND PASSWORD = ?";
			ps = con.prepareStatement(query);
			ps.setString(1, uname);
			ps.setString(2, pword);

			rs = ps.executeQuery();
			if (rs.next()) {
				String username = rs.getString("USERNAME");
				String password = rs.getString("PASSWORD");
				u = new User(username, password);
			}
		} catch (SQLException e) {
			throw new DaoException("findUserByUsernamePassword " + e.getMessage());
		} finally {
			try {
				this.close();
			} catch (SQLException e) {
				throw new DaoException("findUserByUsernamePassword" + e.getMessage());
			}
		}
		// this user might not exist as there will be no row
		// this could be handled in an exception UserNotFound and redirect them to a signupPage
		// Something like Throws UserNotFoundException
		return u;
	}

	public ArrayList<String> getFriendsOfMine(String myUsername) throws DaoException {
		ArrayList<String> myFriends = null;
		try {
			con = this.getConnection();
			String query = "SELECT FRIEND_WITH FROM FRIENDS WHERE SOMEONE = ?";
			ps = con.prepareStatement(query);
			ps.setString(1, myUsername);

			rs = ps.executeQuery();

			myFriends = new ArrayList<>();
			while (rs.next()){
				myFriends.add(rs.getString(1));
			}
			while (rs.next()) {
				myFriends.add(rs.getString(1));
			}
		} catch (SQLException e) {
			throw new DaoException("getFriendsOfMine " + e.getMessage());
		} finally {
			try {
				this.close();
			} catch (SQLException e) {
				throw new DaoException("getFriendsOfMine" + e.getMessage());
			}
		}
		return myFriends; // I might have 0 friends
	}

	// the tasks that this friend has
	public ArrayList<Task> showMyFriendsStack(String myFriendUsername) throws DaoException {
		ArrayList<Task> myFriendsStack = null;
		try {
			con = this.getConnection();
			String query = "select TASKS.*, count(LIKED_BY)" +
					       "from TASKS left join LIKES_TASK USING(TASK_ID) " +
					       "where task_is_public=1 and task_owner =? group by TASK_TODO";

			ps = con.prepareStatement(query);
			ps.setString(1, myFriendUsername);
			rs = ps.executeQuery();

			myFriendsStack = new ArrayList<>();


			while (rs.next()){
				// instantiate the task object given the current row
				myFriendsStack.add(new Task(rs));
			}
		} catch (SQLException e) {
			throw new DaoException("showMyFriendsStack " + e.getMessage());
		} finally {
			try {
				this.close();
			} catch (SQLException e) {
				throw new DaoException("showMyFriendsStack" + e.getMessage());
			}
		}
		return myFriendsStack; // they might not have a any tasks
	}

	protected void close() throws SQLException {
		if (rs != null) {
			rs.close();
		}
		if (ps != null) {
			ps.close();
		}
		if (con != null) {
			freeConnection(con);
		}
	}
}