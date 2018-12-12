package com.rickless137.quilty;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Date;


public class Task {
	private int id;
	private String todo;
	private Date created;
	private int isPublic;
	private String owner;
	private int likes;

	public Task(ResultSet rs) throws SQLException {
		setId(rs.getInt(1));
		setTodo(rs.getString(2));
		setCreated(rs.getDate(3));
		setIsPublic(rs.getInt(4));
		setOwner(rs.getString(5));
		setLikes(rs.getInt(6));
	}
	public void setCreated(Date created) {
		this.created = created;
	}

	public void setId(int id) {
		this.id = id;
	}

	public void setIsPublic(int isPublic) {
		this.isPublic = isPublic;
	}

	public void setLikes(int likes) {
		this.likes = likes;
	}
	public void setOwner(String owner) {
		this.owner = owner;
	}
	public void setTodo(String todo) {
		this.todo = todo;
	}

	public Date getCreated() {
		return created;
	}

	public int getId() {
		return id;
	}

	public boolean getIsPublic() {
		return isPublic == 1;
	}

	public String getTodo() {
		return todo;
	}

	public int getLikes() {
		return likes;
	}
	public String getOwner() {
		return owner;
	}
}
