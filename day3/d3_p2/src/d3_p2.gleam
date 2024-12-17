import gleam/int
import gleam/io
import gleam/list
import gleam/option
import gleam/regexp
import gleam/result
import gleam/string
import simplifile

///((^|do\(\))((.*?(?:mul\((\d+),(\d+)\)).*?))?(don\'t\(\)|$))/gm
pub fn main() {
  let input_file = "../input.txt"
  simplifile.read(input_file)
  |> result.map(string.trim)
  |> result.map(string.replace(_, each: "\n", with: ""))
  |> result.map(get_good_strings)
  |> result.map(count_valids("(mul)\\((\\d+),(\\d+)\\)", _))
  |> result.map(io.debug)
}

fn count_valids(pattn: String, src_text: String) -> Int {
  let assert Ok(re) = regexp.from_string(pattn)
  regexp.scan(with: re, content: src_text)
  |> list.map(process_mul)
  |> list.fold(0, fn(acc, x) { acc + x })
}

fn get_good_strings(full_str: String) -> String {
  let assert Ok(re) = regexp.from_string("(?>do\\(\\))(.*?)(?>don\\'t\\(\\)|$)")
  regexp.scan(with: re, content: full_str)
  |> list.map(fn(op: regexp.Match) -> String {
    let args = string.join(option.values(op.submatches), "")
    args
  })
  |> string.concat
}

fn process_mul(operation: regexp.Match) -> Int {
  let args = option.values(operation.submatches)
  args
  |> list.map(int.parse)
  |> result.values
  |> list.fold(1, fn(a, b) { a * b })
}
