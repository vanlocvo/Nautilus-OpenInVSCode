# Base on Nautilus Admin
# Copyright (C) 2020 Van Loc Vo <vvanloc.vo@gmail.com>
#
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

import os, subprocess
import urllib.parse

from gi.repository import Nautilus, GObject
from gettext import gettext

CODE = '/usr/bin/code'

class VSCodeNautilus(GObject.GObject, Nautilus.MenuProvider):
	def __init__(self):
		pass

	def get_file_items(self, files):
		"""Returns the menu items to display when one or more files/folders are
		selected."""
		# Don't show when more than 1 file is selected
		if len(files) != 1:
			return
		file = files[0]

		# Add the menu items
		items = []
		if file.get_uri_scheme() == "file": # must be a local file/directory
			if os.path.exists(CODE):
					items += [self._create_nautilus_item(file)]

		return items 

	def get_background_items(self, file):
		"""Returns the menu items to display when no file/folder is selected
		(i.e. when right-clicking the background)."""
		# Add the menu items
		items = []
		if file.is_directory() and file.get_uri_scheme() == "file":
				items += [self._create_nautilus_item(file)]
		return items

	def _create_nautilus_item(self, file):
		"""Creates the 'Open with VSCode' menu item."""
		item = Nautilus.MenuItem(name="VSCodeNautilus::Nautilus",
		                         label=gettext("Open in Code"),
		                         tip=gettext("Open this folder/file in Visual Studio Code"))
		item.connect("activate", self._nautilus_run, file)
		return item 

	def _nautilus_run(self, menu, file):
		"""'Open with VSCode' menu item callback."""
		uri = file.get_uri()
		uri = urllib.parse.unquote(uri)
		uri = uri.replace('file://','')
		subprocess.Popen([CODE, uri])
