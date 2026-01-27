#include "Controller.h"
// #include "pluginterfaces/vst/ivstparameters.h"
#include "public.sdk/source/vst/vstparameters.h"
#include "pluginterfaces/base/ustring.h"
#include "base/source/fstring.h"

Steinberg::FUID Steinberg::Vst::Controller::cid (0x87654321, 0x0FEDCBA9, 0x11111111, 0x22222222);

#include "pluginterfaces/base/ibstream.h"

namespace Steinberg {
namespace Vst {

// Helper to copy string literals to VST's String128
void copyString128(String128 dest, const char16* src)
{
				for(int i = 0; i < 128; ++i)
				{
								dest[i] = src[i];
								if (src[i] == 0) break;
				}
}

Controller::Controller ()
{
}

tresult PLUGIN_API Controller::initialize (FUnknown* context)
{
	tresult result = EditController::initialize (context);
	if (result == kResultOk)
	{
		// Create Gain parameter
								ParameterInfo paramInfo;
								paramInfo.id = kParamGainId;
								copyString128(paramInfo.title, u"Gain");
								copyString128(paramInfo.shortTitle, u"Gain");
								copyString128(paramInfo.units, u"");
								paramInfo.stepCount = 0; // continuous
								paramInfo.defaultNormalizedValue = 0.5f;
								paramInfo.unitId = 0; // No specific unit
								paramInfo.flags = ParameterInfo::kCanAutomate;

								Parameter* gainParam = new Parameter(paramInfo);
								parameters.addParameter(gainParam);
	}
	return result;
}

tresult PLUGIN_API Controller::terminate ()
{
	return EditController::terminate ();
}

tresult PLUGIN_API Controller::setComponentState (IBStream* state)
{
	return kResultOk;
}

} // namespace Vst
} // namespace Steinberg
