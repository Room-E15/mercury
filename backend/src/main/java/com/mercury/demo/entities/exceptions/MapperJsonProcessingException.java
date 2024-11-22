package com.mercury.demo.entities.exceptions;

import com.fasterxml.jackson.core.JsonProcessingException;

public class MapperJsonProcessingException extends JsonProcessingException {
    public MapperJsonProcessingException(String message) {
        super(message);
    }
}
