/* libwfut universal config file  */

/* Define if curl is recent enough to have the pipelining option. */
#define HAVE_CURL_MULTI_PIPELINING 1

/* Define to 1 if you have the <dlfcn.h> header file. */
#ifndef _MSC_VER
#	define HAVE_DLFCN_H 1
#endif

/* Define to 1 if you have the <inttypes.h> header file. */
#ifndef _MSC_VER
#   define HAVE_INTTYPES_H 1
#endif

/* Define to 1 if you have the `tinyxml' library (-ltinyxml). */
/* #undef HAVE_LIBTINYXML */

/* Define to 1 if you have the `z' library (-lz). */
#define HAVE_LIBZ 1

/* Define to 1 if you have the <memory.h> header file. */
#define HAVE_MEMORY_H 1

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

/* Define to the sub-directory in which libtool stores uninstalled libraries.
   */
#define LT_OBJDIR ".libs/"

/* Name of package */
#define PACKAGE "libwfut"

/* Define to the address where bug reports for this package should be sent. */
#define PACKAGE_BUGREPORT "simon@worldforge.org"

/* Define to the full name of this package. */
#define PACKAGE_NAME "libwfut"

/* Define to the full name and version of this package. */
#define PACKAGE_STRING "libwfut 0.2.2"

/* Define to the one symbol short name of this package. */
#define PACKAGE_TARNAME "libwfut"

/* Define to the home page for this package. */
#define PACKAGE_URL ""

/* Define to the version of this package. */
#define PACKAGE_VERSION "0.2.2"

/* Define to 1 if you have the ANSI C header files. */
#define STDC_HEADERS 1

/* Version number of package */
#define VERSION "0.2.2"
