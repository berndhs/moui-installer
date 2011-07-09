#
# Makefile
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
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

all:

install:
	mkdir -p $(DESTDIR)/usr/sbin
	mkdir -p $(DESTDIR)/etc/instalateur

	install -m 0755 src/liveinst.sh $(DESTDIR)/usr/sbin/liveinst
	install -m 0755 src/instalateur  $(DESTDIR)/usr/sbin/instalateur
	install -m 0755 src/post_install.sh  $(DESTDIR)/etc/instalateur/post_install.sh 

clean:


