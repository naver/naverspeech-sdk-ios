lib_LTLIBRARIES     = libnsclient.la

libnsclient_la_SOURCES = \
	errors.c \
	errors.h \
	ns_audio.c \
	ns_audio.h \
	ns_client.h \
	ns_client.c \
	ns_client_defs.h \
	ns_recognize.h \
	ns_recognize.c \
	ns_message.c \
	ns_message.h \
	ns_network.c \
	ns_network.h \
	ns_async.c \
	ns_async.h \
	ns_packet.c \
	ns_packet.h

libnsclient_la_CFLAGS  = $(NSFEAT_CFLAGS)

libnsclient_la_LDFLAGS = \
	-pthread \
	-lm \
	$(NSFEAT_LIBS)

include_HEADERS = \
	ns_client_defs.h \
	ns_client.h \
	ns_message.h
