# This file is part of MXE.
# See index.html for further information.

PKG             := libpng
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.6.16
$(PKG)_CHECKSUM := 31855a8438ae795d249574b0da15b34eb0922e13
$(PKG)_SUBDIR   := libpng-$($(PKG)_VERSION)
$(PKG)_FILE     := libpng-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/libpng/libpng16/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.simplesystems.org/pub/$(PKG)/png/src/libpng16/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/p/libpng/code/ref/master/tags/' | \
    $(SED) -n 's,.*<a[^>]*>v\([0-9][^<]*\)<.*,\1,p' | \
    grep -v alpha | \
    grep -v beta | \
    grep -v rc | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    ln -sf '$(PREFIX)/$(TARGET)/bin/libpng-config' '$(PREFIX)/bin/$(TARGET)-libpng-config'

    '$(TARGET)-gcc' \
        -W -Wall -Werror -std=c99 -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-libpng.exe' \
        `'$(PREFIX)/$(TARGET)/bin/libpng-config' --static --cflags --libs`
endef
