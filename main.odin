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
}

main :: proc() {
  html := "yo <body>I'm in a body<\body>"


}
