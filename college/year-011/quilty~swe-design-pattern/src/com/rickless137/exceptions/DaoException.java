package com.rickless137.exceptions;

import java.sql.SQLException;


public class DaoException extends SQLException {

	private static final long serialVersionUID = 1L;

	public DaoException() {
	}

	public DaoException(String message) {
		super(message);
	}
}