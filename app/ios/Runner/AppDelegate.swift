import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  private var journalChannel: FlutterMethodChannel?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // Third-party keyboards refused, app-wide (D50 1): Apple's documented way
  // to reject custom keyboards. Every other extension point is allowed.
  // FlutterAppDelegate's own answer (it asks the plugins) is not consulted.
  override func application(
    _ application: UIApplication,
    shouldAllowExtensionPointIdentifier extensionPointIdentifier: UIApplication.ExtensionPointIdentifier
  ) -> Bool {
    return extensionPointIdentifier != .keyboard
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    if let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "JournalFiles") {
      journalChannel = JournalFiles.channel(messenger: registrar.messenger())
    }
  }
}

// The journal's folder on the phone (D49 b; R11): Library/Application
// Support/Journal, excluded from backup, the folder and every file with
// complete file protection. Plain file operations; the store's rules are
// in Dart (lib/journal/). A failure answers with a code only, never a
// path or a message (R3).
enum JournalFiles {
  static let channelName = "souldreams/journal_files"
  private static func allowed(_ c: Unicode.Scalar) -> Bool {
    return ("a"..."z").contains(c) || ("A"..."Z").contains(c) || ("0"..."9").contains(c)
      || c == "." || c == "_" || c == "-"
  }

  enum Failure: Error { case name, arguments, rename }

  static func channel(messenger: FlutterBinaryMessenger) -> FlutterMethodChannel {
    let channel = FlutterMethodChannel(name: channelName, binaryMessenger: messenger)
    channel.setMethodCallHandler { call, result in
      do {
        result(try handle(call))
      } catch {
        result(FlutterError(code: "journal-io", message: nil, details: nil))
      }
    }
    return channel
  }

  static func folder() throws -> URL {
    let base = try FileManager.default.url(
      for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    return base.appendingPathComponent("Journal", isDirectory: true)
  }

  // The same rule as validName in lib/journal/journal_files.dart.
  static func file(_ name: Any?) throws -> URL {
    guard let n = name as? String, !n.isEmpty, n != ".", !n.hasPrefix(".."),
      n.unicodeScalars.allSatisfy(allowed)
    else { throw Failure.name }
    return try folder().appendingPathComponent(n, isDirectory: false)
  }

  static func arguments(_ call: FlutterMethodCall) throws -> [String: Any] {
    guard let a = call.arguments as? [String: Any] else { throw Failure.arguments }
    return a
  }

  static func handle(_ call: FlutterMethodCall) throws -> Any? {
    let fm = FileManager.default
    switch call.method {
    case "open":
      var dir = try folder()
      let complete: [FileAttributeKey: Any] = [.protectionKey: FileProtectionType.complete]
      try fm.createDirectory(at: dir, withIntermediateDirectories: true, attributes: complete)
      try fm.setAttributes(complete, ofItemAtPath: dir.path)
      var values = URLResourceValues()
      values.isExcludedFromBackup = true
      try dir.setResourceValues(values)
      return nil
    case "list":
      return try fm.contentsOfDirectory(atPath: folder().path).sorted()
    case "read":
      let url = try file(call.arguments)
      guard fm.fileExists(atPath: url.path) else { return nil }
      return FlutterStandardTypedData(bytes: try Data(contentsOf: url))
    case "write":
      let a = try arguments(call)
      guard let bytes = a["bytes"] as? FlutterStandardTypedData else { throw Failure.arguments }
      try bytes.data.write(to: try file(a["name"]), options: [.completeFileProtection])
      return nil
    case "rename":
      let a = try arguments(call)
      let from = try file(a["from"])
      let to = try file(a["to"])
      // POSIX rename: one step, replacing the target.
      guard Darwin.rename(from.path, to.path) == 0 else { throw Failure.rename }
      return nil
    case "delete":
      let url = try file(call.arguments)
      if fm.fileExists(atPath: url.path) { try fm.removeItem(at: url) }
      return nil
    case "protection":
      let dir = try folder()
      let excluded = try dir.resourceValues(forKeys: [.isExcludedFromBackupKey])
        .isExcludedFromBackup ?? false
      let folderClass = try fm.attributesOfItem(atPath: dir.path)[.protectionKey] as? FileProtectionType
      let fileClass = try fm.attributesOfItem(atPath: file(call.arguments).path)[.protectionKey]
        as? FileProtectionType
      return [
        "excluded": excluded,
        "folderComplete": folderClass == .complete,
        "fileComplete": fileClass == .complete,
      ]
    default:
      return FlutterMethodNotImplemented
    }
  }
}
