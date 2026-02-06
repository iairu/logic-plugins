work on robust code based on prompt 1.2 from 7_PROMPT_GALLERY.md, include code comments from research 5_PHYSICS_RESEARCH.md

here is the project structure:

./Configuration
./Configuration/SampleCode.xcconfig
./Documentation
./Documentation/graph.png
./8_PROMPT_HISTORY.md
./macOS
./macOS/AIVFramework
./macOS/AIVFramework/AIVDemoViewController.xib
./macOS/AIVFramework/AIVFramework.h
./macOS/AIVFramework/Support
./macOS/AIVFramework/Support/NSStoryboardExtensions.swift
./macOS/AIVFramework/Support/NSTextFieldExtensions.swift
./macOS/AIVFramework/AIVDemoViewControllerExtension.swift
./macOS/AIVFramework/Info.plist
./macOS/AIVExtension
./macOS/AIVExtension/AIVExtension.entitlements
./macOS/AIVExtension/AIVExtension.swift
./macOS/AIVExtension/Info.plist
./macOS/AIV
./macOS/AIV/MainViewController.swift
./macOS/AIV/Assets.xcassets
./macOS/AIV/Assets.xcassets/AppIcon.appiconset
./macOS/AIV/Assets.xcassets/AppIcon.appiconset/macOS-32.png
./macOS/AIV/Assets.xcassets/AppIcon.appiconset/macOS-256.png
./macOS/AIV/Assets.xcassets/AppIcon.appiconset/macOS-128.png
./macOS/AIV/Assets.xcassets/AppIcon.appiconset/macOS-512.png
./macOS/AIV/Assets.xcassets/AppIcon.appiconset/Contents.json
./macOS/AIV/Assets.xcassets/AppIcon.appiconset/macOS-64.png
./macOS/AIV/Assets.xcassets/AppIcon.appiconset/macOS-16.png
./macOS/AIV/Assets.xcassets/AppIcon.appiconset/macOS-1024.png
./macOS/AIV/Assets.xcassets/Contents.json
./macOS/AIV/Base.lproj
./macOS/AIV/Base.lproj/Main.storyboard
./macOS/AIV/AIV.entitlements
./macOS/AIV/AppDelegate.swift
./macOS/AIV/Info.plist
./.DS_Store
./LICENSE
./LICENSE/LICENSE.txt
./3-README_INIT_PHYSICS.md
./AIV.xcodeproj
./AIV.xcodeproj/project.pbxproj
./AIV.xcodeproj/.xcodesamplecode.plist
./AIV.xcodeproj/project.xcworkspace
./AIV.xcodeproj/project.xcworkspace/xcuserdata
./AIV.xcodeproj/project.xcworkspace/xcuserdata/iairu.xcuserdatad
./AIV.xcodeproj/project.xcworkspace/xcuserdata/iairu.xcuserdatad/.!68145!UserInterfaceState.xcuserstate
./AIV.xcodeproj/project.xcworkspace/xcuserdata/iairu.xcuserdatad/.!68277!UserInterfaceState.xcuserstate
./AIV.xcodeproj/project.xcworkspace/xcuserdata/iairu.xcuserdatad/UserInterfaceState.xcuserstate
./AIV.xcodeproj/project.xcworkspace/xcuserdata/v.xcuserdatad
./AIV.xcodeproj/project.xcworkspace/xcuserdata/v.xcuserdatad/UserInterfaceState.xcuserstate
./AIV.xcodeproj/project.xcworkspace/xcshareddata
./AIV.xcodeproj/project.xcworkspace/xcshareddata/IDEWorkspaceChecks.plist
./AIV.xcodeproj/project.xcworkspace/xcshareddata/WorkspaceSettings.xcsettings
./AIV.xcodeproj/project.xcworkspace/xcshareddata/swiftpm
./AIV.xcodeproj/project.xcworkspace/xcshareddata/swiftpm/configuration
./AIV.xcodeproj/xcshareddata
./AIV.xcodeproj/xcshareddata/xcschemes
./AIV.xcodeproj/xcshareddata/xcschemes/AIV iOS.xcscheme
./AIV.xcodeproj/xcshareddata/xcschemes/AIVFramework macOS.xcscheme
./AIV.xcodeproj/xcshareddata/xcschemes/AIVExtension iOS.xcscheme
./AIV.xcodeproj/xcshareddata/xcschemes/AIVExtension macOS.xcscheme
./AIV.xcodeproj/xcshareddata/xcschemes/AIVFramework iOS.xcscheme
./AIV.xcodeproj/xcshareddata/xcschemes/AIV macOS.xcscheme
./6_PROMPT.md
./Shared
./Shared/AIVDemoViewController.swift
./Shared/AudioUnitManager.swift
./Shared/Support
./Shared/Support/Audio
./Shared/Support/Audio/Synth.aif
./Shared/Support/Audio/SimplePlayEngine.swift
./Shared/Support/User Interface
./Shared/Support/User Interface/AIVMainView.swift
./Shared/Support/User Interface/AIVControls.swift
./Shared/Support/User Interface/ViewExtensions.swift
./Shared/Support/User Interface/FilterView.swift
./Shared/Support/User Interface/TypeAliases.swift
./Shared/AudioUnit
./Shared/AudioUnit/AIVDemoParameters.swift
./Shared/AudioUnit/Support
./Shared/AudioUnit/Support/ParameterRamper.hpp
./Shared/AudioUnit/Support/DSPKernel.hpp
./Shared/AudioUnit/Support/DSPKernel.mm
./Shared/AudioUnit/Support/AIVDSPKernelAdapter.h
./Shared/AudioUnit/Support/AIVDSPClasses.hpp
./Shared/AudioUnit/Support/AIVDSPKernelAdapter.mm
./Shared/AudioUnit/Support/AIVDSPKernel.hpp
./Shared/AudioUnit/Support/BufferedAudioBus.hpp
./Shared/AudioUnit/AIVDemo.swift
./7_PROMPT_GALLERY.md
./4-README_RESEARCH_PROMPT.md
./5_PHYSICS_RESEARCH.md
./6_FEATURE_LIST.md
./2-PROMPT_HISTORY_AFTER_INIT_RESEARCH.md
./1-INIT_RESEARCH.md

---

when done update UX and UI based on robust code from prompt 1.2 from 7_PROMPT_GALLERY.md, include code comments from research 5_PHYSICS_RESEARCH.md

---

update AIV and AIVExtension with proper UI and UX, add more code and utilize extension tabs for different modules

---

for some reason instead of AIVMainView.swift being the main view it is actually AIVDemoViewController.swift which contains the old and still shown AIVMainView, please fix this

---

whenever i rotate any knobs on noise gate or de-esser or limiter it never adjusts to the new value and stays reset, when i try to return pitch back it doesn't do so, only forwarding pitch works but isnt normalised to original audio level, compressor default attack is 10 but knob only allows 0.0 to 1.0 rotation, resonance is missing from knobs (add it as additional knob)

---

still whenever i rotate any knobs on noise gate, de-esser, pitch speed, limiter or resonance it never adjusts to the my new value and stays in original position

---

still whenever i rotate any knobs on noise gate, de-esser, pitch speed, limiter or resonance it never adjusts to the my new value and stays in original position

all of the problems persist due to issue with AIVMainView values not being updated, please fix this

also adjusting mid gain in eq caused overflow and broke the sound, please fix this

---

noise gate now works well, same for de-esser threshold and frequency

de-esser "range" knob is still snapping back, limiter "ceiling" knob is still snapping back also limiter "lookahead" knob is still snapping back, eq mid gain is doing better but at max 12dB still breaks the sound

---

the AIV app demo sound works well with the entire vocal chain, however when i add AIV in Logic Pro it only lowers the sound and doesn't apply anything from the vocal chain regardless of how much i adjust it

---

problem persists: the AIV "Play" button sound works well with the entire vocal chain, no kernel nor DSP adjustments needed, BUT when i add AIVDemo inside Logic Pro the AIVDemo automatically lowers the sound and never applies any of the vocal chain effects, again APP IS OK - APP ALL EFFECT WORK AND APP BYPASS WORKS AND AU IS STILL BROKEN - AU ALL EFFECT NOT WORKING, AU HAS JUST MUSHED UP SOUND, AU BYPASS DOES NOTHING

---

AU controls view (called "Controls") works perfectly in Logic Pro, AU rack view (called "AIVDemo") still has no effect in Logic Pro, but rack view works perfectly in standalone app

---

equalizer mid gain around 9dB causes screetch and sound stops working

---

mid gain still causes screetch past 9.50dB likely due to not being limited in regard to Q value, also add toggle to all rack components making them off by default

---

pitch and limiter is missing a toggle, move master rack to top

---

remove the old parameters from top of app view now that they're part of the proper interface

