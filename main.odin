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
  MARKUP_DECLARATION_OPEN,
  END_TAG_OPEN,
  TAG_NAME,
  BOGUS_COMMENT,
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
  data: string,
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
  input_string := "yo <body>I'm in a body</body>"
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
        if input_index >= input_len {
          current_token.type_name = .EOF
          break
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
              data = "\U00000000"
            }
            emit(&tokens, current_token)
         case:
            current_token.type_name = .CHARACTER
            current_token.type = CommentOrCharacter {
              data = input_string[input_index:input_index + 1] // I'm new to Odin so I have no idea if there's a better way to do this
            }
            emit(&tokens, current_token)
        }
      case .CHARACTER_REFERENCE:
        panic("CHARACTER_REFERENCE not implemented")
      case .TAG_OPEN:
        input_index += 1
        if input_index >= input_len {
          current_token.type_name = .CHARACTER
          current_token.type = CommentOrCharacter {
            data = "<"
          }
          emit(&tokens, current_token)
          current_token.type_name = .EOF
          emit(&tokens, current_token)
          quit = true
          break
        }
        switch input_string[input_index] {
          case '!':
            current_state = .MARKUP_DECLARATION_OPEN
          case '/':
            current_state = .END_TAG_OPEN
          case 'a'..='z', 'A'..='Z':
            input_index -= 1
            current_token.type_name = .START_TAG
            current_token.type = Tag {
              name = ""
            }
            current_state = .TAG_NAME
          case '?':
            input_index -= 1
            current_token.type_name = .COMMENT
            current_token.type = CommentOrCharacter {
              data = ""
            }
            current_state = .BOGUS_COMMENT
         case:
           current_token.type_name = .CHARACTER
           current_token.type = CommentOrCharacter {
            data = "<"
          }
          input_index -= 1
          current_state = .DATA
        }
      case .MARKUP_DECLARATION_OPEN:
        panic("MARKUP_DECLARATION_OPEN_STATE not implemented")
      case .END_TAG_OPEN:
        panic("END_TAG_OPEN not implemented")
      case .TAG_NAME:
        panic("TAG_NAME not implemented")
      case .BOGUS_COMMENT:
        panic("BOGUS_COMMENT not implemented")
    }
  }
  for token in tokens {
    fmt.println(token)
  }
}
