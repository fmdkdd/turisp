;; Turing machine simulator in Common Lisp.
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

;;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;; Tape functions.

;; Return an infinite one-dimensional tape with 'contents' placed at
;; its origin.
(defun make-tape (contents)
  (make-array (length contents) :initial-contents contents
				  :adjustable t :fill-pointer t))

;; Return the symbol of 'tape' at 'index'. If 'index' is outside the
;; tape bounds, the machine special blank symbol is returned.
(defun get-symbol (machine tape index)
  (if (< index (length tape))
		(elt tape index)
	 (machine-blank machine)))

;; Set 'x' to be the symbol of 'tape' at 'index', and return
;; 'tape'. 'index' should have a value not greater than the tape
;; length.
(defun set-symbol (tape index x)
  (progn
	 (if (< index (length tape))
		  (setf (elt tape index) x)
		(vector-push-extend x tape))
	 tape))

;; Move 'index' according to 'switch' direction (either "L" or "R"),
;; and return the new index.
(defun move-head (index switch)
  (if (equal "L" switch)
		(if (= 0 index)
			 "Error - can't go left of origin."
		  (- index 1))
	 (+ index 1)))

;;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;; Rules functions.

;; Return a Turing machine rule with given 'from state', 'from
;; symbol', 'next state', 'next symbol' and direction 'switch'.
(defun make-rule (from-state from-symbol next-state next-symbol switch)
  (vector state symbol next-state next-symbol switch))

;; Return the 'rule' 'from state'.
(defun rule-from-state (rule)
  (elt rule 0))

;; Return the 'rule' 'from symbol'.
(defun rule-from-symbol (rule)
  (elt rule 1))

;; Return the 'rule' 'next state'.
(defun rule-next-state (rule)
  (elt rule 2))

;; Return the 'rule' 'next symbol'.
(defun rule-next-symbol (rule)
  (elt rule 3))

;; Return the 'rule' direction switch ("L" or "R").
(defun rule-switch (rule)
  (elt rule 4))

;;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;; Machine functions.

;; Return a Turing machine with the given rules, initial state,
;; final states and 'blank' symbol (default to "#" if absent).
(defun make-machine (rules initial-state &optional (final-states '()) (blank "#"))
  (vector rules initial-state final-states blank))

;; Return a list of the 'machine' rules.
(defun machine-rules (machine)
  (elt machine 0))

;; Return the 'machine' initial state.
(defun machine-initial-state (machine)
  (elt machine 1))

;; Return a list of the 'machine' final states.
(defun machine-final-states (machine)
  (elt machine 2))

;; Return the special blank symbol of 'machine'.
(defun machine-blank (machine)
  (elt machine 3))

;; Return a rule of the given Turing machine applicable to the current
;; state and symbol.
(defun find-rule (machine state symbol)
  (find (list state symbol) (machine-rules machine)
		  :test 'equal
		  :key (lambda (rule) (list (rule-from-state rule) (rule-from-symbol rule)))))

;; Whether 'state' is a final state of 'machine'.
(defun is-final-state? (machine state)
  (not (null (find state (machine-final-states machine)
						 :test 'equal))))

;; The simulator function. Takes a machine and a tape as arguments.
(defun run-machine (machine tape
									 &optional (state (machine-initial-state machine))
									 (tape-head 0))
  (let* ((symbol (get-symbol machine tape tape-head))
			(rule (find-rule machine state symbol)))
	 (when (is-final-state? machine state)
		(print "Calcul acceptant"))
	 (if (null rule) (pretty-print tape (machine-blank machine))
		(run-machine machine
						 (set-symbol tape tape-head (rule-next-symbol rule))
						 (rule-next-state rule)
						 (move-head tape-head (rule-switch rule))))))

;;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;; Main course !

;; Transform a list tape into a string, with the special blank symbol
;; (default to '#') trimmed.
(defun pretty-print (tape blank)
  (string-trim blank
					(reduce (lambda (a b)
								 (concatenate 'string
												  (format nil "~a" a)
												  (format nil "~a" b)))
							  tape)))
