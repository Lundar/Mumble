# Copyright 2005-2016 The Mumble Developers. All rights reserved.
# Use of this source code is governed by a BSD-style license
# that can be found in the LICENSE file at the root of the
# Mumble source tree or at <https://www.mumble.info/LICENSE>.

# Use a custom tool to query for RCC dependencies.
# Qt's regular invocation of "rcc -list" doesn't work with
# .qrc files that contain references to non-existent files.
# Our .qrc files do that, because we auto-generate some of
# the files at make-time.

# Override RCC_DIR to be 'debug' or 'release'.
# We have to do this because we're loading the
# 'resources' feature a bit earlier than usual.
# By default, Qt would have set these itself.
CONFIG(debug, debug|release) {
	RCC_DIR = debug
}
CONFIG(release, debug|release) {
	RCC_DIR = release
}

load(resources)

win32:!win32-g++-cross {
	WINPWD = $$shell_path($${PWD})
	RCC_DEPENDS = $$escape_expand(\")$${WINPWD}\\scripts\\rcc-depends.py$$escape_expand(\")
	rcc.depend_command = python $${RCC_DEPENDS} ${QMAKE_FILE_IN}
} else {
	RCC_DEPENDS = $$escape_expand(\")$${PWD}/scripts/rcc-depends.py$$escape_expand(\")
	rcc.depend_command = $${RCC_DEPENDS} ${QMAKE_FILE_IN}
}
