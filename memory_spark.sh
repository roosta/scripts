total=$(grep 'MemTotal' /proc/meminfo | egrep -o '[0-9]+')
not_apps=0
for mem in $(egrep '(MemFree|Buffers|Cached|Slab|PageTables|SwapCached)' /proc/meminfo | egrep -o '[0-9]+'); do
  not_apps=$((not_apps+mem))
done
spark $((total-not_apps)) $total 0 | tail -n 1 | cut -b 1-3
