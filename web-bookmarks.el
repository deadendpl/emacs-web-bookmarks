;;; web-bookmarks.el --- Open a web bookmark from Emacs  -*- lexical-binding: t; -*-

;; Copyright (C) 2025

;; Author:  Oliwier Czerwiński <oliwier.czerwi@proton.me>
;; Keywords: convenience
;; Version: 20250216
;; URL: https://github.com/deadendpl/emacs-web-bookmarks

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; A package that reads web bookmarks from a csv file and allows for
;; opening them from Emacs.

;;; Code:

(defcustom web-bookmarks-file
  (expand-file-name "web-bookmarks" user-emacs-directory)
  "File where bookmarks are stored."
  :type '(file))

(defvar web-bookmarks-alist nil
  "Current bookmarks list.")

;;;###autoload
(defun web-bookmarks-read ()
  "Put bookmarks from `web-bookmarks-file' into `web-bookmarks-alist'."
  (with-temp-buffer
    (insert-file-contents web-bookmarks-file)
    (while (search-forward "," nil t)
      (let ((url (buffer-substring-no-properties
                  (point) (line-end-position)))
            (name (buffer-substring-no-properties
                   (line-beginning-position) (1- (point)))))
        (add-to-list 'web-bookmarks-alist `(,name . ,url))))))

(defun web-bookmarks-open ()
  "Open a bookmark."
  (interactive)
  ;; bookmark causes vertico to error
  (web-bookmarks-read)
  (let ((choice (completing-read
                 "Website: " web-bookmarks-alist nil t)))
    (browse-url (cdr (assoc choice web-bookmarks-alist)))))

(provide 'web-bookmarks)
;;; web-bookmarks.el ends here
