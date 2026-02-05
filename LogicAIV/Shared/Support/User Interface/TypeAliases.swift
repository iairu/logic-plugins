/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Type alias mapping to normalize AppKit and UIKit interfaces to support cross-platform code reuse.
*/

#if os(iOS)
import UIKit
public typealias PlatformColor = UIColor
public typealias PlatformFont = UIFont

public typealias Storyboard = UIStoryboard

public typealias PlatformView = UIView
public typealias TextField = UITextField
public typealias Label = UILabel
public typealias Button = UIButton
public typealias Slider = UISlider

#elseif os(macOS)
import AppKit
public typealias PlatformColor = NSColor
public typealias PlatformFont = NSFont

public typealias Storyboard = NSStoryboard

public typealias PlatformView = NSView
public typealias TextField = NSTextField
public typealias Label = NSTextField
public typealias Button = NSButton
public typealias Slider = NSSlider

public var tintColor: NSColor! = NSColor.controlAccentColor.usingColorSpace(.deviceRGB)

#endif
