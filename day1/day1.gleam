import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import simplifile

pub fn main() {
  let input_file = "../input.txt"
  simplifile.read(input_file)
  |> result.map(string.trim)
  |> result.map(string.split(_, "\n"))
  |> result.map(to_ints)
}

fn to_ints(content: List(String)) {
  list.index_map(content, fn(nums, _index) {
    string.split(nums, "   ")
    |> list.index_map(fn(num, _index) { int.parse(num) })
    |> result.values
  })
  |> list.transpose
  |> list.index_map(fn(num_list, _index) { list.sort(num_list, int.compare) })
  |> list.transpose
  |> list.map(criteria)
  |> result.values
  |> list.reduce(fn(acc, x) { x + acc })
  |> result.map(io.debug)
}

fn criteria(nums: List(Int)) {
  list.reduce(nums, fn(acc, num) { int.absolute_value(num - acc) })
}
