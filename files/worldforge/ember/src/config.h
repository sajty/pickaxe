/* src/config.h.  Generated from config.h.in by configure.  */
/* src/config.h.in.  Generated from configure.ac by autoheader.  */

/* Include pthread support for binary relocation? */
/* #undef BR_PTHREAD */

/* Use binary relocation? */
/* #undef ENABLE_BINRELOC */

/* "extension stl" */
#define EXT_HASH 1

/* define if the Boost library is available */
#define HAVE_BOOST /**/

/* define if the Boost::Thread library is available */
#define HAVE_BOOST_THREAD /**/

/* Define to 1 if you have the <dlfcn.h> header file. */
#ifndef _MSC_VER
#   define HAVE_DLFCN_H 1
#endif

/* Define to 1 if you don't have `vprintf' but do have `_doprnt.' */
/* #undef HAVE_DOPRNT */

/* Define to 1 if you have the <inttypes.h> header file. */
#ifndef _MSC_VER
#   define HAVE_INTTYPES_H 1
#endif

/* Define to 1 if you have the `pthread' library (-lpthread). */
/* #undef HAVE_LIBPTHREAD */

/* Define to 1 if you have the `tinyxml' library (-ltinyxml). */
/* #undef HAVE_LIBTINYXML */

/* Define to 1 if your system has a GNU libc compatible `malloc' function, and
   to 0 otherwise. */
#define HAVE_MALLOC 1

/* Define to 1 if you have the <math.h> header file. */
#define HAVE_MATH_H 1

/* Define to 1 if you have the <memory.h> header file. */
#define HAVE_MEMORY_H 1

/* Define to 1 if you have the `memset' function. */
#define HAVE_MEMSET 1

/* Define to 1 if you have the `OpenGL' library. */
#define HAVE_OPENGL 1

/* Define to 1 if you have the `select' function. */
#define HAVE_SELECT 1

/* Define to 1 if the system has the type `sighandler_t'. */
#ifndef _MSC_VER
#	define HAVE_SIGHANDLER_T 1
#endif
/* Define to 1 if you have the <signal.h> header file. */
#define HAVE_SIGNAL_H 1

/* Define to 1 if you have the <stdint.h> header file. */
#ifndef _MSC_VER
#   define HAVE_STDINT_H 1
#endif

/* Define to 1 if you have the <stdlib.h> header file. */
#define HAVE_STDLIB_H 1

/* Define to 1 if you have the <strings.h> header file. */
#ifndef _MSC_VER
#   define HAVE_STRINGS_H 1
#endif

/* Define to 1 if you have the <string.h> header file. */
#define HAVE_STRING_H 1

/* Define to 1 if you have the <sys/stat.h> header file. */
#define HAVE_SYS_STAT_H 1

/* Define to 1 if you have the <sys/types.h> header file. */
#define HAVE_SYS_TYPES_H 1

/* Define to 1 if you have the <unistd.h> header file. */
#ifndef _MSC_VER
#   define HAVE_UNISTD_H 1
#endif


/* Define to 1 if you have the `vprintf' function. */
#define HAVE_VPRINTF 1

/* Define to the sub-directory in which libtool stores uninstalled libraries.
   */
#define LT_OBJDIR ".libs/"

/* The Ogre plugin dir */
#define OGRE_PLUGINDIR "/home/sajty/dev/worldforge/local/lib/OGRE"

/* Name of package */
#define PACKAGE "ember"

/* Define to the address where bug reports for this package should be sent. */
#define PACKAGE_BUGREPORT "erik.hjortsberg@gmail.com"

/* Define to the full name of this package. */
#define PACKAGE_NAME "Ember"

/* Define to the full name and version of this package. */
#define PACKAGE_STRING "Ember 0.6.1"

/* Define to the one symbol short name of this package. */
#define PACKAGE_TARNAME "ember"

/* Define to the home page for this package. */
#define PACKAGE_URL ""

/* Define to the version of this package. */
#define PACKAGE_VERSION "0.6.1"

/* Define to 1 if you have the ANSI C header files. */
#define STDC_HEADERS 1

/* Define to 1 if your <sys/time.h> declares `struct tm'. */
#ifdef _MSC_VER
#	define TM_IN_SYS_TIME
#endif

/* Version number of package */
#define VERSION "0.6.1"

/* Define to empty if `const' does not conform to ANSI C. */
/* #undef const */

/* Define to `__inline__' or `__inline' if that's what the C compiler
   calls it, or to nothing if 'inline' is not supported under any name.  */
#ifndef __cplusplus
/* #undef inline */
#endif

/* Define to rpl_malloc if the replacement function should be used. */
/* #undef malloc */
