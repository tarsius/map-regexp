;;; map-regexp.el --- map over matches of a regular expression

;; Copyright (C) 2013  Jonas Bernoulli

;; Author: Jonas Bernoulli <jonas@bernoul.li>
;; Created: 20130424
;; Version: 0.1.0
;; Status: experimental
;; Package-Requires: ((cl-lib "0.2"))
;; Keywords: convenience
;; Homepage: https://github.com/tarsius/map-regexp

;; This file is not part of GNU Emacs.

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; For a full copy of the GNU General Public License
;; see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; This library defines several forms that search forward from
;; point for a regular expression and call a function for each
;; match to do something with the match data.

;; Equivalents of `mapc', `mapcar', and `cl-mapcan' are defined.
;; If that isn't enough use `mr-loop-regexp' which supports all
;; of `cl-loop's accumulation clauses.

;;; Code:

(require 'cl-lib)

(defmacro mr-loop-regexp (regexp bound clause form)
  "Search forward from point for REGEXP evaluating FORM for each match.
For each match evaluate FORM, which has access to the match data.
Use the `cl-loop' accumulation CLAUSE to collect the results.

BOUND, if non-nil, bounds the search; it is a buffer position.
The match found must not extend after that position.

Also see `cl-loop', `re-search-forward', and `match-...'."
  `(save-excursion
     (cl-loop while (re-search-forward ,regexp ,bound t)
              ,clause ,form)))

(defmacro mr-mapc-regexp (function regexp &optional bound)
  "Search forward from point for REGEXP calling FUNCTION for each match.
For each match call FUNCTION, which has access to the match data,
with no arguments.

Optional BOUND, if non-nil, bounds the search; it is a buffer
position.  The match found must not extend after that position."
  `(mr-loop-regexp ,regexp ,bound do (funcall ,function)))

(defmacro mr-mapcar-regexp (function regexp &optional bound)
  "Search forward from point for REGEXP calling FUNCTION for each match.
For each match call FUNCTION, which has access to the match data,
with no arguments, and make a list of the results.

Optional BOUND, if non-nil, bounds the search; it is a buffer
position.  The match found must not extend after that position."
  `(mr-loop-regexp ,regexp ,bound collect (funcall ,function)))

(defmacro mr-mapcan-regexp (function regexp &optional bound)
  "Search forward from point for REGEXP calling FUNCTION for each match.
For each match call FUNCTION, which has access to the match data,
with no arguments, and nconc together the results.

Optional BOUND, if non-nil, bounds the search; it is a buffer
position.  The match found must not extend after that position."
  `(mr-loop-regexp ,regexp ,bound nconc (funcall ,function)))

(provide 'map-regexp)
;; Local Variables:
;; indent-tabs-mode: nil
;; End:
;;; map-regexp.el ends here
