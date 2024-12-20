import gleam/int
import gleam/io
import gleam/list
import gleam/option
import gleam/regex
import gleam/regexp
import gleam/result
import gleam/string
import simplifile

//(XMAS)|(SAMX)|(X(?>.|\n){10}M(?>.|\n){10}A(?>.|\s){11}S)|
//(S(.|\s){10}A(.|\s){10}M(.|\s){11}X)|
//(X(?>.|\n){10}M(?>.|\n){10}A(?>.|\s){10}S)|
//S(.|\s){10}A(.|\s){10}M(.|\s){10}X

pub fn main() {
  let a = ""
  "
MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX
"
  ""
  let arr = {
    let input_file = "../test.txt"
    simplifile.read(input_file)
    |> result.map(string.trim)
    |> result.map(string.split(_, "\n"))
    |> result.unwrap([])
  }

  let horizontals = {
    arr
    |> list.map(count_xmas)
    |> list.fold(0, fn(acc, x) { acc + x })
  }

  let verticals = {
    arr
    |> list.map(string.split(_, ""))
    |> list.transpose
    |> list.map(string.join(_, ""))
    |> list.map(count_xmas)
    |> list.fold(0, fn(acc, x) { acc + x })
  }
  let diagonals = {
    arr
    |> list.map(string.split(_, ""))
    |> list.window(4)
    |> list.map(window_horiz)
  }
  horizontals + verticals |> io.debug
}

fn count_xmas(src_text: String) -> Int {
  let patterns = ["(XMAS)", "(SAMX)"]
  patterns
  |> list.map(apply_pttn(_, src_text))
  |> list.fold(0, fn(acc, x) { acc + x })
}

fn test_idea(txt_block: List(String)) {
  txt_block
  |> list.map(string.split(_, ""))
  |> redimension
  todo
}

fn redimension(array: List(List(String))) {
  array
  todo
  |> list.map(string.split(_, ""))
  |> list.window(4)
  |> list.map(list.window(_, 4))
  |> list.flatten
  |> io.debug
}

fn apply_pttn(pttn: String, str_full: String) -> Int {
  let assert Ok(re) = regexp.from_string(pttn)
  let matches = regexp.scan(with: re, content: str_full)

  list.map(matches, fn(m: regexp.Match) { option.values(m.submatches) })
  |> list.length
}

fn window_horiz(rows4: List(List(String))) -> Int {
  list.map(rows4, fn(row) { list.window(row, 4) })
  |> list.map(get_strs)
  |> io.debug
  |> todo
}

fn get_strs(strs: List(List(String))) {
  list.map(strs, string.join(_, ""))
}

fn check_diagonals(square: List(List(String))) -> Int {
  let left_n = "(X(?>.{4})M(?>.{4})A(?>.{4})S)"
  let left_r = "(S(?>.{4})A(?>.{4})M(?>.{4})X)"
  let assert Ok(re) = regexp.from_string(left_n)
  let assert Ok(re2) = regexp.from_string(left_r)
  let str_full = string.join(list.flatten(square), "")
  let matches = regexp.scan(with: re, content: str_full)
  let matches2 = regexp.scan(with: re2, content: str_full)
  list.length(matches) + list.length(matches2)
}
