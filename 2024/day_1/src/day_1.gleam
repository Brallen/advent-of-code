import gleam/int
import gleam/io
import gleam/list
import gleam/string
import simplifile

pub fn main() {
  let filepath = "./src/input.txt"
  let contents = simplifile.read(from: filepath)

  let #(list1, list2) = case contents {
    Ok(data) -> build_lists(data)
    Error(_) -> #([], [])
  }

  let sorted1 = list.sort(list1, int.compare)
  let sorted2 = list.sort(list2, int.compare)

  let distance =
    list.zip(sorted1, sorted2)
    |> list.fold(0, fn(distance, tuple) {
      let #(val1, val2) = tuple
      distance + int.absolute_value(val1 - val2)
    })

  io.debug(distance)
}

fn build_lists(input: String) -> #(List(Int), List(Int)) {
  string.split(input, "\n")
  |> list.fold_right(#([], []), fn(tuple, row) {
    let #(list1, list2) = tuple
    let items = string.split(row, "   ")

    case items {
      [item1, item2] -> {
        let parsed_item1 = int.parse(item1)
        let parsed_item2 = int.parse(item2)
        case parsed_item1, parsed_item2 {
          Ok(val1), Ok(val2) -> #([val1, ..list1], [val2, ..list2])
          _, _ -> tuple
        }
      }
      _ -> tuple
    }
  })
}
