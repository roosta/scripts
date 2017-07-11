for dep in $(pip show $1 | grep Requires | sed 's/Requires: //g; s/,//g')
  do pip uninstall -y $dep
done
pip uninstall -y $1
