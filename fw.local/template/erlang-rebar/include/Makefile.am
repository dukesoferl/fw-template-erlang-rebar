templateincludedir = $(prefix)/share/fw/template/@FW_TEMPLATE_TEMPLATE_TYPE@/include

dist_templateinclude_DATA = myapp.hrl

install-data-hook:
	find "$(DESTDIR)$(templateincludedir)" -type f | xargs chmod -w

CLEANFILES =

MAINTAINERCLEANFILES =                  \
  Makefile.in

include $(top_srcdir)/fw/build/automake/check-shell.am
include $(top_srcdir)/fw/build/automake/gnu-make-check.am
