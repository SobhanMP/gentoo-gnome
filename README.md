![](ss.png?raw=true)

* This is the experimental gnome overlay, USE AT YOUR OWN RISK.
* It will probably break your deptree, your system, and your backbone.
* For bugs, head over to #gentoo-desktop @ FreeNode, or https://bugs.gentoo.org/
* To help, checkout ./status/ and http://tinyurl.com/gnome-overlay-bugs
* Scripts for development available in ./scripts/
* If you plan on forking the overlay to work on some gnome stuff, don't hesitate
  to send us a mail at gnome_at_gentoo_dot_org to inform us or ask for a merge
  of your work
* Please set branch.autosetuprebase = always
* Or set in your .gitconfig:
[branch]
	autosetuprebase = always

###########
# GNOME 3 #
###########
* To try out GNOME 3, use the portage config files in status/portage-configs. It
  is recommended to symlink the package.keywords.gnome3 and package.mask.gnome3
  files, and copy the others to the proper place.
* Read man portage to know the proper place to copy/symlink these files. In
  particular, note that /etc/portage/package.{keywords,mask} can be directories.
* If you have bugs, please report them to Gentoo for triaging before contacting
  upstream. Bugs might be gentoo-specific, in which case you would waste
  upstream's time.
* While reporting bugs to bugs.gentoo.org, please prepend "[gnome-overlay]" to
  the subject for ease of finding.
* #gentoo-desktop @ FreeNode is the proper place for questions. Note that the
  gnome team is severely understaffed, so it might take us time to reply.
