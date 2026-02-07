/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Non-UI controller object used to manage the interaction with the AIVDemo audio unit.
*/

import Foundation
import AudioToolbox
import CoreAudioKit
import AVFoundation

// A simple wrapper type to prevent exposing the Core Audio AUAudioUnitPreset in the UI layer.
public struct Preset {
    fileprivate init(preset: AUAudioUnitPreset) {
        audioUnitPreset = preset
    }
    fileprivate let audioUnitPreset: AUAudioUnitPreset
    public var number: Int { return audioUnitPreset.number }
    public var name: String { return audioUnitPreset.name }
}

// Delegate protocol to be adopted to be notified of parameter value changes.
public protocol AUManagerDelegate: AnyObject {
    // Legacy parameters removed
}

// Controller object used to manage the interaction with the audio unit and its user interface.
public class AudioUnitManager {

    /// The user-selected audio unit.
    private var audioUnit: AIVDemo?

    public weak var delegate: AUManagerDelegate? 

    public private(set) var viewController: AIVDemoViewController!

    // Gets the audio unit's defined presets.
    public var presets: [Preset] {
        guard let audioUnitPresets = audioUnit?.factoryPresets else {
            return []
        }
        return audioUnitPresets.map { preset -> Preset in
            return Preset(preset: preset)
        }
    }

    // Retrieves or sets the audio unit's current preset.
    public var currentPreset: Preset? {
        get {
            guard let preset = audioUnit?.currentPreset else { return nil }
            return Preset(preset: preset)
        }
        set {
            audioUnit?.currentPreset = newValue?.audioUnitPreset
        }
    }

    /// The playback engine used to play audio.
    private let playEngine = SimplePlayEngine()

    // A token for our registration to observe parameter value changes.
    private var parameterObserverToken: AUParameterObserverToken?

    // The AudioComponentDescription matching the AIVExtension Info.plist
    private var componentDescription: AudioComponentDescription = {

        // Ensure that AudioUnit type, subtype, and manufacturer match the extension's Info.plist values
        var componentDescription = AudioComponentDescription()
        componentDescription.componentType = kAudioUnitType_Effect
        componentDescription.componentSubType = 0x666c7472 /*'fltr'*/
        componentDescription.componentManufacturer = 0x69616972 /*'iair'*/
        componentDescription.componentFlags = 0
        componentDescription.componentFlagsMask = 0

        return componentDescription
    }()

    private let componentName = "iairu: AIVAlpha"

    public init() {

        viewController = loadViewController()

        /*
         Register our `AUAudioUnit` subclass, `AIVDemo`, to make it able
         to be instantiated via its component description.

         Note that this registration is local to this process.
         */
        AUAudioUnit.registerSubclass(AIVDemo.self,
                                     as: componentDescription,
                                     name: componentName,
                                     version: 0x00010200)

        AVAudioUnit.instantiate(with: componentDescription) { audioUnit, error in
            guard error == nil, let audioUnit = audioUnit else {
                fatalError("Could not instantiate audio unit: \(String(describing: error))")
            }
            self.audioUnit = audioUnit.auAudioUnit as? AIVDemo
            self.connectParametersToControls()
            self.playEngine.connect(avAudioUnit: audioUnit)
        }
    }

    // Loads the audio unit's view controller from the extension bundle.
    private func loadViewController() -> AIVDemoViewController {
        // Locate the app extension's bundle in the main app's PlugIns directory
        guard let url = Bundle.main.builtInPlugInsURL?.appendingPathComponent("AIVExtension.appex"),
            let appexBundle = Bundle(url: url) else {
                fatalError("Could not find app extension bundle URL.")
        }

        #if os(iOS)
        let storyboard = Storyboard(name: "MainInterface", bundle: appexBundle)
        guard let controller = storyboard.instantiateInitialViewController() as? AIVDemoViewController else {
            fatalError("Unable to instantiate AIVDemoViewController")
        }
        return controller
        #elseif os(macOS)
        return AIVDemoViewController(nibName: "AIVDemoViewController", bundle: appexBundle)
        #endif
    }

    /**
     Called after instantiating our audio unit, to find the AU's parameters and
     connect them to our controls.
     */
    private func connectParametersToControls() {

        guard let audioUnit = audioUnit else {
            fatalError("Couldn't locate AIVDemo")
        }

        viewController.audioUnit = audioUnit
        
        // No standalone parameter handling needed - pure View Controller hosting
    }

    @discardableResult
    public func togglePlayback() -> Bool {
        return playEngine.togglePlay()
    }

    public func toggleView() {
        viewController.toggleViewConfiguration()
    }

    public func cleanup() {
        playEngine.stopPlaying()

        guard let parameterTree = audioUnit?.parameterTree,
              let token = parameterObserverToken else { return }
        parameterTree.removeParameterObserver(token)
        parameterObserverToken = nil
    }
}

#if os(macOS)
public class RegistrationManager {
    public static func checkStatus() -> String {
        var status = "--- Audio Component Search ---\n"
        
        // 1. Check AVAudioUnitComponentManager
        let description = AudioComponentDescription(componentType: kAudioUnitType_Effect, 
                                                    componentSubType: 0x666c7472, // 'fltr'
                                                    componentManufacturer: 0x69616972, // 'iair'
                                                    componentFlags: 0, 
                                                    componentFlagsMask: 0)
                                                    
        let components = AVAudioUnitComponentManager.shared().components(matching: description)
        
        if let comp = components.first {
            status += "✅ Found: \(comp.name) (v\(comp.versionString))\n"
            status += "   Manufacturer: \(comp.manufacturerName)\n"
            status += "   Format: \(comp.typeName)\n"
        } else {
            status += "❌ NOT FOUND in System Registry\n"
            status += "   (Make sure to run the app once to register)\n"
        }
        
        status += "\n--- Pluginkit Query ---\n"
        
        // 2. Run pluginkit
        let bundleID = "com.iairu.AIV.AIVExtension"
        status += "Searching for Bundle ID: \(bundleID)\n"
        
        let task = Process()
        task.launchPath = "/usr/bin/pluginkit"
        task.arguments = ["-m", "-v", "-D", "-i", bundleID]
        
        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError = pipe
        
        do {
            try task.run()
            task.waitUntilExit()
            
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            if let output = String(data: data, encoding: .utf8), !output.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                status += output
            } else {
                status += "⚠️ No matches found for \(bundleID).\n"
                status += "   This usually means the extension is not registered or Sandbox blocks query.\n"
                status += "   Try moving App to /Applications and run again.\n"
            }
        } catch {
            status += "Error running pluginkit: \(error)\n"
        }
        
        return status
    }
    
    public static func registerPlugin() -> String {
        var status = "--- Forcing Registration ---\n"
        
        // 1. Locate the .appex bundle
        guard let pluginsURL = Bundle.main.builtInPlugInsURL else {
            return status + "❌ Error: Could not find PlugIns directory in bundle.\n"
        }
        
        let extensionURL = pluginsURL.appendingPathComponent("AIVExtension.appex")
        let extensionPath = extensionURL.path
        
        status += "Target: \(extensionPath)\n"
        
        if !FileManager.default.fileExists(atPath: extensionPath) {
             return status + "❌ Error: Extension not found at expected path.\n"
        }
        
        // 2. Run pluginkit -a (Add)
        status += "1. Adding to registry (pluginkit -a)...\n"
        let addResult = runProcess(launchPath: "/usr/bin/pluginkit", arguments: ["-a", extensionPath])
        status += addResult.output
        if !addResult.success { status += "⚠️ Warning: 'Add' command execution failed.\n" }
        
        // 3. Run pluginkit -e use (Enable)
        let bundleID = "com.iairu.AIV.AIVExtension"
        status += "2. Enabling (pluginkit -e use -i \(bundleID))...\n"
        let enableResult = runProcess(launchPath: "/usr/bin/pluginkit", arguments: ["-e", "use", "-i", bundleID])
        status += enableResult.output
         if !enableResult.success { status += "⚠️ Warning: 'Enable' command execution failed.\n" }
        
        // 4. Re-check status
        status += "\n--- Verification ---\n"
        status += checkStatus()
        
        return status
    }
    
    // Helper for running processes
    private static func runProcess(launchPath: String, arguments: [String]) -> (success: Bool, output: String) {
        let task = Process()
        task.launchPath = launchPath
        task.arguments = arguments
        
        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError = pipe
        
        do {
            try task.run()
            task.waitUntilExit()
            
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            let output = String(data: data, encoding: .utf8) ?? ""
            return (task.terminationStatus == 0, output)
        } catch {
            return (false, "Error: \(error)\n")
        }
    }
}
#endif
