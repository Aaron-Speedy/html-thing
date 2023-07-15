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

main :: proc() {
  html := "yo <body>I'm in a body<\body>"


}
