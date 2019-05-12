(** Precedence levels, support for pretty-printing. *)

type t = int

let parenthesize ~at_level ~max_level = max_level < at_level

type infix =
  | Infix0
  | Infix1
  | Infix2
  | Infix3
  | Infix4
  | Infix5

let highest = 1000
let least = 0

let no_parens = least

let prefix = 50
let prefix_arg = 50

let infix = function
  | Infix5 -> (200, 199, 200)
  | Infix4 -> (300, 300, 299)
  | Infix3 -> (400, 400, 399)
  | Infix2 -> (500, 499, 500)
  | Infix1 -> (600, 600, 599)
  | Infix0 -> (650, 649, 649)

let tuple = no_parens
let tuple_arg = no_parens

let constr = 150
let constr_arg = constr - 1

(* Type levels *)

let comp_ty = 800
let comp_ty_left = comp_ty - 1
let comp_ty_right = no_parens

let arr = 900
let arr_left = arr - 1
let arr_right = arr

let product = 700
let product_arg = product - 1

let comodel_ty = 750
let comodel_ty_world = product
