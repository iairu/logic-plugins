#include "Processor.h"
#include "Controller.h"
#include "pluginterfaces/base/ustring.h"
#include <cmath>

Steinberg::FUID Steinberg::Vst::Processor::cid (0x12345678, 0x9ABCDEF0, 0x11111111, 0x22222222);

#include "pluginterfaces/vst/ivstparameterchanges.h"
#include "pluginterfaces/vst/ivstevents.h"
#include "base/source/fstreamer.h"

namespace Steinberg {
namespace Vst {

Processor::Processor ()
: phase (0.f)
, gain(0.5f)
{
	setControllerClass (Controller::cid);
}

tresult PLUGIN_API Processor::initialize (FUnknown* context)
{
	tresult result = AudioEffect::initialize (context);
	if (result == kResultOk)
	{
		addAudioInput (USTRING("Stereo In"), SpeakerArr::kStereo);
		addAudioOutput (USTRING("Stereo Out"), SpeakerArr::kStereo);
	}
	return result;
}

tresult PLUGIN_API Processor::terminate ()
{
	return AudioEffect::terminate ();
}

tresult PLUGIN_API Processor::setActive (TBool state)
{
	return AudioEffect::setActive (state);
}

tresult PLUGIN_API Processor::process (ProcessData& data)
{
	if (data.inputParameterChanges)
    {
        int32 numParams = data.inputParameterChanges->getParameterCount ();
        for (int32 i = 0; i < numParams; i++)
        {
            IParamValueQueue* queue = data.inputParameterChanges->getParameterData (i);
            if (queue)
            {
                ParamID id = queue->getParameterId ();
                if (id == kParamGainId)
                {
                    int32 numPoints = queue->getPointCount ();
                    ParamValue value;
                    int32 sampleOffset;
                    if (queue->getPoint (numPoints - 1, sampleOffset, value) == kResultOk)
                    {
                        gain = value;
                    }
                }
            }
        }
    }

	if (data.numSamples > 0)
	{
		// ZUN-style distortion
		if (data.numInputs == 0 || data.numOutputs == 0)
		{
			// nothing to do
			return kResultOk;
		}

		int32 numChannels = data.inputs[0].numChannels;

		for (int32 i = 0; i < data.numSamples; i++)
		{
			for (int32 ch = 0; ch < numChannels; ++ch)
			{
				float in = data.inputs[0].channelBuffers32[ch][i];
				
				// Apply a non-linear gain and clipping
				float distorted = in * (1.f + gain * 4.f);
				distorted = tanh(distorted); // Soft clipping

				data.outputs[0].channelBuffers32[ch][i] = distorted;
			}
		}
	}
	return kResultOk;
}

} // namespace Vst
} // namespace Steinberg
