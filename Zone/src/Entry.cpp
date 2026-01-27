#include "public.sdk/source/main/pluginfactory.h"
#include "Processor.h"
#include "Controller.h"

namespace Steinberg {

#define PClass Vst::Processor
#define CClass Vst::Controller

BEGIN_FACTORY_DEF ("ZUN", "http://www.zun.com", "info@zun.com")
	DEF_CLASS2 (INLINE_UID_FROM_FUID(PClass::cid),
				PClass::cid,
				CClass::cid,
				"Zone",
				Vst::PlugType::kFx,
				"Fx",
				"ZUN",
				"1.0.0",
				"http://www.zun.com")
END_FACTORY

} // namespace Steinberg
