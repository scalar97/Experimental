package com.rickless137.quilty;

public class User {
	private String username; // the username is the ID and it is meant to be unique
	private String password;

	public User(String username, String password) {
		setUsername(username);
		setPassword(password);
	}
	public String getPassword() {
		return password;
	}

	public void setUsername(String username) {
		this.username = username;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public String getUsername() {
		return username;
	}
}
