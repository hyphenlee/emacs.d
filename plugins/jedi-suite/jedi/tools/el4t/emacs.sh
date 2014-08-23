#!/bin/bash

### emacs.sh --- Start Emacs with some packages from the future.

# Copyright (C) 2012 Takafumi Arakaki

# Author: Takafumi Arakaki <aka.tkf at gmail.com>

# This file is NOT part of GNU Emacs.

# EL4T is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# EL4T is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with EL4T.
# If not, see <http://www.gnu.org/licenses/>.

set -e
# Download lib/ert/ if necessary
(cd $(dirname $0) && git submodule update --init > /dev/null 2> /dev/null)

EL4T_DIR=$(dirname $0)
EL4T_EMACS="${EL4T_EMACS:-emacs}"
exec $EL4T_EMACS -l $EL4T_DIR/lib/el4t.el "$@"
