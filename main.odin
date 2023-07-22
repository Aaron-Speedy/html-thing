package main

import "core:fmt"
import "core:strings"
import "core:unicode/utf8"

TokenizeState :: enum {
  NORMAL,
  ANGLE_RUNE,
  TAG_END,
  TAG_NAME,
}

Attribute :: struct {
  name:  []string,
  value: []string,
}

StartTag :: struct {
  name:         []string,
  self_closing: bool,
  attributes:   [dynamic]Attribute,
}

EndTag :: struct {
  name:         []string,
  self_closing: bool,
  attributes:   [dynamic]Attribute,
}

Text :: struct {
  data: []string
}

EOF :: struct {}

Token :: distinct union {
  StartTag,
  EndTag,
  Text,
  EOF,
}

emit :: proc(tokens: ^[dynamic]Token, token: Token) {
  append(tokens, token)
}

main :: proc() {
  input_string := "yo <😁Body>I'm in a body</body>"

  state := TokenizeState.NORMAL
  input_index := -1
  tokens: [dynamic]Token
  current_token: Token
  quit: bool

  for !quit {
    #partial switch state {
      case .NORMAL:
        switch input_string[input_index] {
          case '<':
            state = .ANGLE_RUNE
          case:
            current_token = Text { }
        }
      case .ANGLE_RUNE:
        switch input_string[input_index] {
          case '/':
            state = .TAG_END
          case 'A'..='z':
            state = .TAG_NAME
          case:

        }
      case:
        if _, ok := current_token.(Text); ok {

        } else {
          current_token = Text { }
        }
    }
  }
  for token in tokens {
    fmt.println(token)
  }
}
