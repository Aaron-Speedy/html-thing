package main

import "core:fmt"
import "core:strings"
import "core:unicode/utf8"

emit :: proc(partitions: ^[dynamic]int, partition: int) {
  append(partitions, partition)
}

main :: proc() {
  input_string := "yo<Body>I'm in a body</body>"

  PartitionType :: enum {
    SYMBOL,
    ALPHA,
    WHITE_SPACE,
    OTHER_TEXT,
  }
  partitions: [dynamic]int
  current_partition: int
  current_type: PartitionType

  for codepoint in input_string {
    switch codepoint {
      case '<', '>', '/':
        emit(&partitions, current_partition)
        emit(&partitions, 1)
        current_type = .SYMBOL
        current_partition = 0
      case '\t', '\n', '\f', ' ':
        emit(&partitions, current_partition)
        emit(&partitions, 1)
        current_type = .WHITE_SPACE
        current_partition = 0
      case 'A'..='z':
        if current_type != .OTHER_TEXT {
          current_type = .ALPHA
        }
        current_partition += 1
      case:
        current_type = .OTHER_TEXT
        current_partition += 1
    }
  }

  current_index := 0
  for partition in partitions{
    fmt.println(input_string[current_index : current_index + partition])
    current_index += partition
  }
}
