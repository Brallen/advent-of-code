import gleam/io
import simplifile

pub fn main() {
  let filepath = "./src/input.txt"
  let contents = simplifile.read(from: filepath)
  let data = case contents {
    Ok(input) -> input
    Error(_) -> ""
  }

  string

  io.debug(data)
}
