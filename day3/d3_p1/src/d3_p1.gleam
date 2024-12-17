import gleam/int
import gleam/io
import gleam/list
import gleam/option
import gleam/regexp
import gleam/result
import gleam/string
import simplifile

pub fn main() {
  let input_file = "../input.txt"
  simplifile.read(input_file)
  |> result.map(string.trim)
  |> result.map(count_valids("(mul)\\((\\d+),(\\d+)\\)", _))
  |> result.map(io.debug)
}

fn count_valids(pattn: String, src_text: String) -> Int {
  let assert Ok(re) = regexp.from_string(pattn)
  regexp.scan(with: re, content: src_text)
  |> list.map(process_mul)
  |> list.fold(0, fn(acc, x) { acc + x })
}

fn process_mul(operation: regexp.Match) -> Int {
  let args = option.values(operation.submatches)
  case string.join(list.take(args, 1), "") {
    "mul" -> {
      list.drop(args, 1)
      |> list.map(int.parse)
      |> result.values
      |> list.fold(1, fn(a, b) { a * b })
    }
    _ -> 0
  }
}
