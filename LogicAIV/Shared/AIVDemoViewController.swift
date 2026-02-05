/*
See LICENSE folder for this sample’s licensing information.

Abstract:
View controller for the AIVDemo audio unit. Manages the interactions between a FilterView and the audio unit's parameters.
*/

import CoreAudioKit
import SwiftUI
import AIVFramework
#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif



// MARK: - View Controller

public class AIVDemoViewController: AUViewController {

    // MARK: - Compatibility Outlets (Required by Storyboard/XIB)
    #if os(iOS)
    @IBOutlet var compactView: UIView!
    @IBOutlet var expandedView: UIView!
    @IBOutlet var filterView: FilterView!
    @IBOutlet var frequencyTextField: UITextField!
    @IBOutlet var resonanceTextField: UITextField!
    #elseif os(macOS)
    @IBOutlet var compactView: NSView!
    @IBOutlet var expandedView: NSView!
    @IBOutlet var filterView: FilterView!
    @IBOutlet var frequencyTextField: NSTextField!
    @IBOutlet var resonanceTextField: NSTextField!
    #endif

    @IBAction func frequencyUpdated(_ sender: Any) {}
    @IBAction func resonanceUpdated(_ sender: Any) {}


    private var hostingController: Any? // Type erased to support both platforms if needed, or specific

    public var audioUnit: AIVDemo? {
        didSet {
            performOnMain {
                if self.isViewLoaded {
                    self.updateHostingController()
                }
            }
        }
    }
    
    #if os(macOS)
    public override init(nibName: NSNib.Name?, bundle: Bundle?) {
        super.init(nibName: nibName, bundle: Bundle(for: type(of: self)))
    }
    #endif

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        #if os(iOS)
        let host = UIHostingController(rootView: AIVMainView(audioUnit: audioUnit))
        addChild(host)
        view.addSubview(host.view)
        host.view.frame = view.bounds
        host.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        host.didMove(toParent: self)
        hostingController = host
        #elseif os(macOS)
        let host = NSHostingController(rootView: AIVMainView(audioUnit: audioUnit))
        addChild(host)
        view.addSubview(host.view)
        host.view.frame = view.bounds
        host.view.autoresizingMask = [.width, .height]
        hostingController = host
        #endif
    }
    
    private func updateHostingController() {
        guard let au = audioUnit else { return }
        
        #if os(iOS)
        if let host = hostingController as? UIHostingController<AIVMainView> {
            host.rootView = AIVMainView(audioUnit: au)
        }
        #elseif os(macOS)
        if let host = hostingController as? NSHostingController<AIVMainView> {
            host.rootView = AIVMainView(audioUnit: au)
        }
        #endif
    }

    func performOnMain(_ operation: @escaping () -> Void) {
        if Thread.isMainThread {
            operation()
        } else {
            DispatchQueue.main.async {
                operation()
            }
        }
    }
    
    // MARK: - Compatibility
    public func toggleViewConfiguration() {
        // No-op for SwiftUI interface
    }
    
    public func selectViewConfiguration(_ viewConfig: AUAudioUnitViewConfiguration) {
        // No-op for SwiftUI interface
    }
}
