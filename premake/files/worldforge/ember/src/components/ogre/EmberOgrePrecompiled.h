// To use this precompiled header, you need to inject it with "/FI".

#include "EmberOgrePrerequisites.h"

#include <Ogre.h>
#include <CEGUIBase.h>
#include <RendererModules/Ogre/CEGUIOgreRenderer.h>
#include <sigc++/trackable.h>

#include "EmberOgreSignals.h"
#include "framework/Singleton.h"
#include "framework/ConsoleObject.h"
#include "services/input/InputCommandMapper.h"
#include <wfmath/point.h>
#include <wfmath/vector.h>
