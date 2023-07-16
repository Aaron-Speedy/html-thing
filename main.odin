package main

import "core:fmt"
import "core:strings"

TokenType :: enum {
  DOCTYPE,
  START_TAG,
  END_TAG,
  COMMENT,
  CHARACTER,
  EOF,
}

TokenizeState :: enum {
  DATA,
  CHARACTER_REFERENCE,
  TAG_OPEN,
}

Attribute :: struct {
  name: string,
  value: string,
}

DocType :: struct {
  name: string,
  public_ident: string,
  system_ident: string,
  force_quirks: bool,
  public_ident_found: bool,
  system_ident_found: bool,
}

Tag :: struct {
  name: string,
  self_closing: bool,
  attributes: [dynamic]Attribute,
}

CommentOrCharacter :: struct {
  data: u8,
}

Token :: struct {
  type_name: TokenType,
  type: union {
    Attribute,
    DocType,
    Tag,
    CommentOrCharacter,
  }
}

emit :: proc(tokens: ^[dynamic]Token, token: Token) {
  append(tokens, token)
}

main :: proc() {
  input_string := "yo <body>I'm in a body<\body>"
  input_len := len(input_string)

  current_state := TokenizeState.DATA
  return_state := TokenizeState.DATA
  input_index := -1
  tokens: [dynamic]Token
  current_token: Token
  quit: bool;

  for !quit {
    switch current_state {
      case .DATA:
        input_index += 1
        if(input_index >= input_len) {
          current_token.type_name = .EOF
        }
        switch input_string[input_index] {
          case '&':
            return_state = .DATA
            current_state = .CHARACTER_REFERENCE
          case '<':
            current_state = .TAG_OPEN
          case '\U00000000':
            current_token.type_name = .CHARACTER
            current_token.type = CommentOrCharacter {
              data = input_string[input_index]
            }
            emit(&tokens, current_token)
         case:
            current_token.type_name = .CHARACTER
            current_token.type = CommentOrCharacter {
              data = input_string[input_index]
            }
            emit(&tokens, current_token)
        }
      case .CHARACTER_REFERENCE:
        panic("CHARACTER_REFERENCE unimplemented")
      case .TAG_OPEN:
        panic("TAG_OPEN unimplemented")
    }
  }
  for token in tokens {
    fmt.println(token)
  }
}
