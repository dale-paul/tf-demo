{
    "swagger": "2.0",
    "info": {
        "version": "1.0",
        "title": "pssst"
    },
    "schemes": [
        "https"
    ],
    "paths": {
        "/": {
            "post": {
                "consumes": [
                    "application/json"
                ],
                "produces": [
                    "application/json"
                ],
                "responses": {
                    "200": {
                        "description": "200 response",
                        "schema": {
                            "$ref": "#/definitions/Empty"
                        }
                    }
                },
                "x-amazon-apigateway-integration": {
                    "responses": {
                        "default": {
                            "statusCode": "200"
                        }
                    },
                    "uri": "${invoke_arn}",
                    "passthroughBehavior": "when_no_match",
                    "httpMethod": "POST",
                    "contentHandling": "CONVERT_TO_TEXT",
                    "type": "aws_proxy"
                }
            },
            "options": {
                "consumes": [
                    "application/json"
                ],
                "produces": [
                    "application/json"
                ],
                "responses": {
                    "200": {
                        "description": "200 response",
                        "schema": {
                            "$ref": "#/definitions/Empty"
                        },
                        "headers": {
                            "Access-Control-Allow-Methods": {
                                "type": "string"
                            },
                            "Access-Control-Allow-Origin": {
                                "type": "string"
                            },
                            "Access-Control-Allow-Headers": {
                                "type": "string"
                            }
                        }
                    }
                },
                "x-amazon-apigateway-integration": {
                    "responses": {
                        "default": {
                            "statusCode": "200",
                            "responseParameters": {
                                "method.response.header.Access-Control-Allow-Methods": "'POST,OPTIONS'",
                                "method.response.header.Access-Control-Allow-Origin": "'*'",
                                "method.response.header.Access-Control-Allow-Headers": "'Authorization,Content-Type,X-Amz-Date,X-Amz-Security-Token,X-Api-Key'"
                            }
                        }
                    },
                    "requestTemplates": {
                        "application/json": "{\"statusCode\": 200}"
                    },
                    "passthroughBehavior": "when_no_match",
                    "type": "mock",
                    "contentHandling": "CONVERT_TO_TEXT"
                }
            }
        },
        "/{key}": {
            "get": {
                "consumes": [
                    "application/json"
                ],
                "produces": [
                    "application/json"
                ],
                "responses": {
                    "200": {
                        "description": "200 response",
                        "schema": {
                            "$ref": "#/definitions/Empty"
                        }
                    }
                },
                "x-amazon-apigateway-integration": {
                    "responses": {
                        "default": {
                            "statusCode": "200"
                        }
                    },
                    "uri": "${invoke_arn}",
                    "passthroughBehavior": "when_no_match",
                    "httpMethod": "POST",
                    "contentHandling": "CONVERT_TO_TEXT",
                    "type": "aws_proxy"
                },
                "parameters": [
                    {
                        "name": "key",
                        "in": "path",
                        "required": true,
                        "type": "string"
                    }
                ]
            },
            "options": {
                "consumes": ["application/json"],
                "produces": ["application/json"],
                "responses": {
                    "200": {
                        "description": "200 response",
                        "schema": {
                            "$ref": "#/definitions/Empty"
                        },
                        "headers": {
                            "Access-Control-Allow-Methods": {
                                "type": "string"
                            },
                            "Access-Control-Allow-Origin": {
                                "type": "string"
                            },
                            "Access-Control-Allow-Headers": {
                                "type": "string"
                            }
                        }
                    }
                },
                "x-amazon-apigateway-integration": {
                    "responses": {
                        "default": {
                            "statusCode": "200",
                            "responseParameters": {
                                "method.response.header.Access-Control-Allow-Methods": "'GET,OPTIONS'",
                                "method.response.header.Access-Control-Allow-Origin": "'*'",
                                "method.response.header.Access-Control-Allow-Headers": "'Authorization,Content-Type,X-Amz-Date,X-Amz-Security-Token,X-Api-Key'"
                            }
                        }
                    },
                    "requestTemplates": {
                        "application/json": "{\"statusCode\": 200}"
                    },
                    "passthroughBehavior": "when_no_match",
                    "type": "mock",
                    "contentHandling": "CONVERT_TO_TEXT"
                }
            }
        },
        "/totp": {
            "post": {
                "consumes": [
                    "application/json"
                ],
                "produces": [
                    "application/json"
                ],
                "responses": {
                    "200": {
                        "description": "200 response",
                        "schema": {
                            "$ref": "#/definitions/Empty"
                        }
                    }
                },
                "x-amazon-apigateway-integration": {
                    "responses": {
                        "default": {
                            "statusCode": "200"
                        }
                    },
                    "uri": "${invoke_arn}",
                    "passthroughBehavior": "when_no_match",
                    "httpMethod": "POST",
                    "contentHandling": "CONVERT_TO_TEXT",
                    "type": "aws_proxy"
                }
            },
            "options": {
                "consumes": [
                    "application/json"
                ],
                "produces": [
                    "application/json"
                ],
                "responses": {
                    "200": {
                        "description": "200 response",
                        "schema": {
                            "$ref": "#/definitions/Empty"
                        },
                        "headers": {
                            "Access-Control-Allow-Methods": {
                                "type": "string"
                            },
                            "Access-Control-Allow-Origin": {
                                "type": "string"
                            },
                            "Access-Control-Allow-Headers": {
                                "type": "string"
                            }
                        }
                    }
                },
                "x-amazon-apigateway-integration": {
                    "responses": {
                        "default": {
                            "statusCode": "200",
                            "responseParameters": {
                                "method.response.header.Access-Control-Allow-Methods": "'POST,OPTIONS'",
                                "method.response.header.Access-Control-Allow-Origin": "'*'",
                                "method.response.header.Access-Control-Allow-Headers": "'Authorization,Content-Type,X-Amz-Date,X-Amz-Security-Token,X-Api-Key'"
                            }
                        }
                    },
                    "requestTemplates": {
                        "application/json": "{\"statusCode\": 200}"
                    },
                    "passthroughBehavior": "when_no_match",
                    "type": "mock",
                    "contentHandling": "CONVERT_TO_TEXT"
                }
            }
        },
        "/slack/events": {
            "post": {
                "consumes": [
                    "application/x-www-form-urlencoded",
                    "application/json"
                ],
                "produces": [
                    "application/json"
                ],
                "responses": {
                    "200": {
                        "description": "200 response",
                        "schema": {
                            "$ref": "#/definitions/Empty"
                        }
                    }
                },
                "x-amazon-apigateway-integration": {
                    "responses": {
                        "default": {
                            "statusCode": "200"
                        }
                    },
                    "uri": "${invoke_arn}",
                    "passthroughBehavior": "when_no_match",
                    "httpMethod": "POST",
                    "contentHandling": "CONVERT_TO_TEXT",
                    "type": "aws_proxy"
                }
            }
        }
    },
    "definitions": {
        "Empty": {
            "type": "object",
            "title": "Empty Schema"
        }
    },
    "x-amazon-apigateway-binary-media-types": [
        "application/octet-stream",
        "application/x-tar",
        "application/zip",
        "audio/basic",
        "audio/ogg",
        "audio/mp4",
        "audio/mpeg",
        "audio/wav",
        "audio/webm",
        "image/png",
        "image/jpg",
        "image/jpeg",
        "image/gif",
        "video/ogg",
        "video/mpeg",
        "video/webm"
    ]
}