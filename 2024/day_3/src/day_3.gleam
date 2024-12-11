import gleam/int
import gleam/io
import gleam/list
import gleam/regexp
import simplifile

pub fn main() {
  let filepath = "./src/input.txt"
  let contents = simplifile.read(from: filepath)
  let data = case contents {
    Ok(input) -> input
    Error(_) -> ""
  }

  let assert Ok(mul_re) = regexp.from_string("mul\\(\\d+,\\d+\\)")
  let assert Ok(numbers_re) = regexp.from_string("\\d+")

  let value =
    regexp.scan(with: mul_re, content: data)
    |> list.fold(0, fn(sum, match) {
      regexp.scan(with: numbers_re, content: match.content)
      |> list.fold(1, fn(product, capture) {
        let assert Ok(num) = int.parse(capture.content)
        product * num
      })
      |> int.add(sum)
    })

  io.debug(value)
}
