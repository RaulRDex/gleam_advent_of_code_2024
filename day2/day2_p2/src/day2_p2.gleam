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
    string.split(nums, " ")
    |> list.index_map(fn(num, _index) { int.parse(num) })
    |> result.values
  })
  |> list.filter(is_report_safe(_, 1))
  |> list.length
  |> io.debug
}

fn get_diffs(report: List(Int)) {
  list.window_by_2(report)
  |> list.map(get_diff)
}

fn get_diff(nums: #(Int, Int)) -> Int {
  nums.0 - nums.1
}

fn is_report_safe(report: List(Int), level: Int) -> Bool {
  let nums = get_diffs(report)
  let len: Int = list.length(report) - 1
  let all_rising = !list.any(nums, fn(x) { x < 0 })
  let all_falling = !list.any(nums, fn(x) { x > 0 })
  let all_in_range =
    !list.any(nums, fn(x) {
      let a = int.absolute_value(x)
      a < 1 || a > 3
    })

  case all_in_range && { all_rising || all_falling } {
    True -> True
    False -> {
      case level {
        1 -> {
          list.combinations(report, len)
          |> list.any(is_report_safe(_, 2))
        }
        _ -> {
          False
        }
      }
    }
  }
}
