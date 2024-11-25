package com.mercury.demo.entities.exceptions;

public class DatabaseStateException  extends RuntimeException {
    public DatabaseStateException(String message) {
        super(message);
    }
}
