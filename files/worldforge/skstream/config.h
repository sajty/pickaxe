/* skstream universal config file  */

/* true if config.h was included */
#define CONFIG_H_INCLUDED 1

/* "Define to 1 if you have the `closesocket' function." */
#ifdef _MSC_VER
#define HAVE_CLOSESOCKET 1
#endif
/* Define to 1 if you have the <cstdio> header file. */
#define HAVE_CSTDIO 1

/* Define to 1 if you have the <dlfcn.h> header file. */
#define HAVE_DLFCN_H 1

/* "Define to 1 if you have the `gai_strerror' function." */
#define HAVE_GAI_STRERROR 1

/* "Define to 1 if you have the `getaddrinfo' function." */
#define HAVE_GETADDRINFO 1

/* Define to 1 if you have the `inet_aton' function. */
#ifndef _MSC_VER
#	define HAVE_INET_ATON 1
#endif

/* Define to 1 if you have the <inttypes.h> header file. */
#ifndef _MSC_VER
#   define HAVE_INTTYPES_H 1
#endif

/* true if we have in_addr_t */
#define HAVE_IN_ADDR_T 1

/* Define to 1 if you have the <iostream> header file. */
#define HAVE_IOSTREAM 1

/* true if we have sockaddr_in6 and AF_INET6 */
#define HAVE_IPV6 1

/* Define to 1 if you have the <memory.h> header file. */
#define HAVE_MEMORY_H 1

/* Define to 1 if you have the <stdint.h> header file. */
#ifndef _MSC_VER
#   define HAVE_STDINT_H 1
#endif

/* Define to 1 if you have the <stdlib.h> header file. */
#define HAVE_STDLIB_H 1

/* Define to 1 if you have the <string> header file. */
#define HAVE_STRING 1

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
#define PACKAGE "skstream"

/* Define to the address where bug reports for this package should be sent. */
#define PACKAGE_BUGREPORT "alriddoch@googlemail.com"

/* Define to the full name of this package. */
#define PACKAGE_NAME "skstream"

/* Define to the full name and version of this package. */
#define PACKAGE_STRING "skstream 0.3.8"

/* Define to the one symbol short name of this package. */
#define PACKAGE_TARNAME "skstream"

/* Define to the home page for this package. */
#define PACKAGE_URL ""

/* Define to the version of this package. */
#define PACKAGE_VERSION "0.3.8"

/* Define if unix domain sockets are supported */
#ifndef _MSC_VER
#	define SKSTREAM_UNIX_SOCKETS 1
#endif

/* Define to 1 if you have the ANSI C header files. */
#define STDC_HEADERS 1

/* Version number of package */
#define VERSION "0.3.8"
