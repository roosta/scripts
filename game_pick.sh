#!/bin/bash
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
# ---------------------------------------------------------------------
# Roosta <mail@roosta.sh> @ 2016-05-21
# www.roosta.sh
# Ridiculous script used to pick a random game from a text file.
# Rationale: I have bunch of games in my game library I haven't played,
# if I simply pick one I tend to avoid a lot of games based on existing preferences.
# This results in me never giving a bunch of titles the time of day, so the game this
# script picks, I focus on. Either play until completion, or at the very least give it
# a proper chance.
#TODO: expand to include other kinds of media, like books, movies...

games_list=resources/games_primary.txt
games_count=$(wc -l ${games_list} | awk '{print $1}')
random_number=$(( ( RANDOM % games_count )  + 1 ))
intro="Calculating"

# check for toilet, else just echo text.
# this could prolly be more robust, but bleh
fancy() {
  if hash toilet 2>/dev/null; then
    toilet --gay -t -F border -f future "$@"
  else
    echo -n -e "$@" "\n"
  fi
}

# add a countdown before displaying "result"
for (( c=0; c<=5; c++ )); do
  intro+="."
  echo -ne "$intro \r" && sleep 1
done
echo -ne "The Game Picked Was:\n"
fancy "$(awk "NR==$random_number" "$games_list")"

