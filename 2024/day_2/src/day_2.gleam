import gleam/int
import gleam/io
import gleam/list
import gleam/order
import gleam/string
import simplifile

type Direction {
  Increasing
  Decreasing
  Equal
}

pub fn main() {
  let filepath = "./src/input.txt"
  let contents = simplifile.read(from: filepath)
  let data = case contents {
    Ok(raw_records) -> parse_records(raw_records)
    Error(_) -> []
  }

  let num_safes =
    list.map(data, is_safe)
    |> list.filter(fn(entry) { entry })
    |> list.length()

  io.debug(num_safes)
}

fn is_safe(record: List(Int)) -> Bool {
  let assert [first, second] = list.take(record, 2)
  let direction = get_direction(first, second)

  case direction {
    Equal -> False
    _ -> is_going_in_direction(record, direction)
  }
}

fn is_going_in_direction(record: List(Int), direction: Direction) {
  list.window_by_2(record)
  |> list.fold(True, fn(is_a_safe, tuple) {
    let #(first, second) = tuple
    case direction {
      Increasing ->
        int.compare(first, second) == order.Lt
        && int.absolute_value(first - second) < 4
        && is_a_safe
      Decreasing ->
        int.compare(first, second) == order.Gt
        && int.absolute_value(first - second) < 4
        && is_a_safe
      Equal -> False
    }
  })
}

fn get_direction(first: Int, second: Int) -> Direction {
  case first, second {
    first, second if first == second -> Equal
    first, second if first > second -> Decreasing
    _, _ -> Increasing
  }
}

fn parse_records(raw_records: String) -> List(List(Int)) {
  string.split(raw_records, "\n")
  |> list.fold_right([], fn(records, raw_record) {
    let record =
      string.split(raw_record, " ")
      |> list.map(fn(raw_level) {
        let possible_int = int.parse(raw_level)
        case possible_int {
          Ok(int_level) -> int_level
          Error(_) -> 0
        }
      })
    [record, ..records]
  })
  |> list.filter(fn(entry) { list.length(entry) > 2 })
}
