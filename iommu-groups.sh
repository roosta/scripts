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
#
# BEGIN_DOC
# ### [iommu-groups.sh](./iommu-groups.sh)
#
# Lists system iommu groups used for PCI passthrough via OVMF. This was copied
# from the arch wiki in 2016, I would probably go check the latest wiki
# revision to get up to date scripts.
#
# - https://wiki.archlinux.org/title/PCI_passthrough_via_OVMF
#
# Usage:
#
# ```sh
# ./iommu-groups.sh
# ```
#
# License [GFDL-1.3](./LICENSES/GFDL-1.3-LICENSE.txt)
# END_DOC

#https://wiki.archlinux.org/title/PCI_passthrough_via_OVMF
for iommu_group in $(find /sys/kernel/iommu_groups/ -maxdepth 1 -mindepth 1 -type d); do
  echo "IOMMU group $(basename "$iommu_group")";
  for device in $(ls -1 "$iommu_group"/devices/); do echo -n $'\t'; lspci -nns "$device";
  done;
done
