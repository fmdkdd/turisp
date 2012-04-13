;; Copyright (C) 2011 fmdkdd <fmdkdd@gmail.com>
;;
;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;; n -> n+1
(run-machine (make-machine '(#(0 "#" 1 0 "R")
                             #(0 0 0 0 "R")) 0)
             (make-tape '(0 0 0)))

;; n -> n-1
> (run-machine (make-machine '(#(0 0 1 "#" "R")) 0)
               (make-tape '(0 0 0)))
"00"

;; n -> 0 (n=0) | 1
> (run-machine (make-machine '(#(0 0 1 0 "R")
                               #(1 0 1 "#" "R")) 0)
               (make-tape '(0 0)))
"0"

;; n -> 1 (n=0) | 0
> (run-machine (make-machine '(#(0 0 1 "#" "R")
                               #(0 "#" 1 0 "R")
                               #(1 0 1 "#" "R")) 0)
               (make-tape '(0 0)))
""

;; x -> x mod 2
> (run-machine (make-machine '(#(0 0 1 "#" "R")
                               #(1 0 0 "#" "R")
                               #(1 "#" 0 0 "R")) 0)
               (make-tape '(0 0 0 0 0)))
"0"

;; (x,y) -> x
> (run-machine (make-machine '(#(0 0 0 0 "R")
                               #(0 1 1 "#" "R")
                               #(1 0 1 "#" "R")) 0)
               (make-tape '(0 0 1 0 0 0)))
"00"

;; (x,y) -> y
> (run-machine (make-machine '(#(0 0 0 "#" "R")
                               #(0 1 1 "#" "R")) 0)
               (make-tape '(0 0 1 0 0 0)))
"000"

;; (x,y) -> x+y
> (run-machine (make-machine '(#(0 0 1 "#" "R")
                               #(0 1 1 "#" "R")
                               #(1 1 1 0 "R")
                               #(1 0 1 0 "R")) 0)
               (make-tape '(0 0 1 0 0 0)))
"00000"

;; n -> even(n) = (n+1) mod 2
;; n is in binary little-endian.
> (run-machine (make-machine '(#(0 0 1 0 "R")
                               #(0 1 1 1 "R")
                               #(1 "#" 2 "#" "L")
                               #(2 0 2 1 "R")
                               #(2 1 2 0 "R")
                               #(1 0 3 0 "L")
                               #(1 1 3 1 "L")
                               #(3 0 0 "#" "R")
                               #(3 1 0 "#" "R")) 0)
               (make-tape '(1)))
"0"

;; Accept every word of L = { a^n b^n | n > 0 }.
> (run-machine (make-machine '(#(0 "a" 1 "A" "R")
                               #(1 "a" 1 "a" "R")
                               #(1 "B" 1 "B" "R")
                               #(1 "b" 2 "B" "L")
                               #(2 "a" 2 "a" "L")
                               #(2 "B" 2 "B" "L")
                               #(2 "A" 0 "A" "R")
                               #(0 "B" 3 "B" "R")
                               #(3 "B" 3 "B" "R")
                               #(3 "#" 4 "#" "R")) 0 '(4))
               (make-tape '("a" "a" "b" "b")))
"Calcul acceptant"
"AABB"
