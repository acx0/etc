# ~/.config/ranger/apps.py

from ranger.defaults.apps import CustomApplications as DefaultApps
from ranger.api.apps import *

class CustomApplications(DefaultApps):
	def app_default(self, c):
		f = c.file

		if f.video or f.audio:
			if f.video:
				c.flags += 'd'
			return self.either(c, 'vlc', 'smplayer', 'mplayer', 'totem')

		return DefaultApps.app_default(self, c)
