import AVFoundation
import Flutter
import Network
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  private var journalChannel: FlutterMethodChannel?
  private var audioChannel: FlutterMethodChannel?
  private var networkChannel: FlutterEventChannel?
  private let networkWatch = NetworkWatch()
  #if SOULDREAMS_EXPORT
    private var exportChannel: FlutterMethodChannel?
  #endif

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    #if SOULDREAMS_EXPORT
      // A file left by a share the app did not see close (D108).
      FounderExport.sweep()
    #endif
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
    if let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "AudioSession") {
      audioChannel = AudioSession.channel(messenger: registrar.messenger())
    }
    if let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "NetworkWatch") {
      let channel = FlutterEventChannel(name: NetworkWatch.channelName, binaryMessenger: registrar.messenger())
      channel.setStreamHandler(networkWatch)
      networkChannel = channel
    }
    #if SOULDREAMS_EXPORT
      if let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "FounderExport") {
        exportChannel = FounderExport.channel(messenger: registrar.messenger())
      }
    #endif
  }
}

#if SOULDREAMS_EXPORT
  // The founder's export (C142-I item 3; D107; D108), compiled only where
  // SOULDREAMS_EXPORT is set: dev.xcconfig and founder.xcconfig, never
  // tester.xcconfig (R8; native_test.dart). One night's file, written to
  // tmp/Export with complete protection, handed to the phone's share with
  // every type Apple names excluded but AirDrop, and the people row too on
  // iOS 18 and later. Other targets cannot be removed, so the file is given
  // to AirDrop alone: any other target receives nothing (OnlyAirDrop). The
  // file is deleted when the share closes, sent or not, and the folder is
  // emptied before each share and at launch. tmp is never backed up (R11).
  // A failure answers with a code only (R3).
  enum FounderExport {
    static let channelName = "souldreams/founder_export"
    private static var sharing = false

    enum Failure: Error { case arguments, busy, presenter }

    // Every activity type Apple names, but AirDrop (UIActivity.h), each
    // from the iOS that has it.
    static var excluded: [UIActivity.ActivityType] {
      var types: [UIActivity.ActivityType] = [
        .postToFacebook, .postToTwitter, .postToWeibo, .message, .mail, .print, .copyToPasteboard,
        .assignToContact, .saveToCameraRoll, .addToReadingList, .postToFlickr, .postToVimeo,
        .postToTencentWeibo, .openInIBooks, .markupAsPDF,
      ]
      if #available(iOS 15.4, *) { types.append(.sharePlay) }
      if #available(iOS 16.0, *) { types += [.collaborationInviteWithLink, .collaborationCopyLink] }
      if #available(iOS 16.4, *) { types.append(.addToHomeScreen) }
      return types
    }

    static func folder() -> URL {
      return FileManager.default.temporaryDirectory.appendingPathComponent("Export", isDirectory: true)
    }

    static func sweep() {
      try? FileManager.default.removeItem(at: folder())
    }

    static func channel(messenger: FlutterBinaryMessenger) -> FlutterMethodChannel {
      let channel = FlutterMethodChannel(name: channelName, binaryMessenger: messenger)
      channel.setMethodCallHandler { call, result in
        guard call.method == "share" else {
          result(FlutterMethodNotImplemented)
          return
        }
        do {
          try share(call, result)
        } catch {
          if !sharing { sweep() }
          result(FlutterError(code: "export", message: nil, details: nil))
        }
      }
      return channel
    }

    // The file's name is the night's date in digits (export_text.dart).
    static func valid(_ name: String) -> Bool {
      return name.range(of: "^[0-9]{4}-[0-9]{2}-[0-9]{2}[.]txt$", options: .regularExpression) != nil
    }

    static func presenter() -> UIViewController? {
      let windows = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.flatMap { $0.windows }
      var top = windows.first { $0.isKeyWindow }?.rootViewController
      while let next = top?.presentedViewController { top = next }
      return top
    }

    static func share(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) throws {
      guard !sharing else { throw Failure.busy }
      guard let a = call.arguments as? [String: Any], let name = a["name"] as? String, valid(name),
        let bytes = a["bytes"] as? FlutterStandardTypedData
      else { throw Failure.arguments }
      guard let top = presenter() else { throw Failure.presenter }
      sweep()
      let fm = FileManager.default
      let complete: [FileAttributeKey: Any] = [.protectionKey: FileProtectionType.complete]
      try fm.createDirectory(at: folder(), withIntermediateDirectories: true, attributes: complete)
      let url = folder().appendingPathComponent(name, isDirectory: false)
      try bytes.data.write(to: url, options: [.completeFileProtection])
      let sheet = UIActivityViewController(activityItems: [OnlyAirDrop(url)], applicationActivities: nil)
      sheet.excludedActivityTypes = excluded
      if #available(iOS 18.0, *) { sheet.excludedActivitySectionTypes = .peopleSuggestions }
      sharing = true
      sheet.completionWithItemsHandler = { _, _, _, _ in
        guard sharing else { return }
        sharing = false
        sweep()
        result(nil)
      }
      top.present(sheet, animated: true)
    }
  }

  // The file, given to AirDrop alone: for any other activity the share
  // asks for the item and gets nothing ("you can return nil",
  // UIActivityItemProvider.h).
  final class OnlyAirDrop: NSObject, UIActivityItemSource {
    let url: URL

    init(_ url: URL) {
      self.url = url
    }

    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
      return url
    }

    func activityViewController(
      _ activityViewController: UIActivityViewController,
      itemForActivityType activityType: UIActivity.ActivityType?
    ) -> Any? {
      return activityType == .airDrop ? url : nil
    }
  }
#endif

// Whether the phone has a connection, as the phone knows it (D92 item 3;
// D93 Q4): Apple's path monitor, one true or false at each change, on the
// main thread. It sends nothing anywhere (R10). Reached from SoulDreams Dev
// only (lib/recording/connection.dart).
final class NetworkWatch: NSObject, FlutterStreamHandler {
  static let channelName = "souldreams/network"
  private var monitor: NWPathMonitor?

  func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    monitor?.cancel()
    let next = NWPathMonitor()
    next.pathUpdateHandler = { path in
      let online = path.status == .satisfied
      DispatchQueue.main.async { events(online) }
    }
    next.start(queue: DispatchQueue(label: "souldreams.network"))
    monitor = next
    return nil
  }

  func onCancel(withArguments arguments: Any?) -> FlutterError? {
    monitor?.cancel()
    monitor = nil
    return nil
  }
}

// The phone's audio, given back when a recording ends (D79 c): the session
// is deactivated with notify-others, so music the recording paused
// resumes. The record package never deactivates the session when a
// recording stops. Reached from SoulDreams Dev only
// (lib/recording/record_microphone.dart). A failure answers with a code
// only (R3).
enum AudioSession {
  static let channelName = "souldreams/audio_session"

  static func channel(messenger: FlutterBinaryMessenger) -> FlutterMethodChannel {
    let channel = FlutterMethodChannel(name: channelName, binaryMessenger: messenger)
    channel.setMethodCallHandler { call, result in
      guard call.method == "release" else {
        result(FlutterMethodNotImplemented)
        return
      }
      do {
        try AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
        result(nil)
      } catch {
        result(FlutterError(code: "audio-session", message: nil, details: nil))
      }
    }
    return channel
  }
}

// The journal's folder on the phone (D49 b; R11): Library/Application
// Support/Journal, excluded from backup, the folder and every file with
// complete file protection. Plain file operations; the store's rules are
// in Dart (lib/journal/). A failure answers with a code only, never a
// path or a message (R3). A recording's audio is kept here too until its
// words come (D92): appended as it is recorded, every file created with
// complete protection, read back in ranges, and its front cut away by
// copying the rest to a new file (D94).
enum JournalFiles {
  static let channelName = "souldreams/journal_files"
  private static func allowed(_ c: Unicode.Scalar) -> Bool {
    return ("a"..."z").contains(c) || ("A"..."Z").contains(c) || ("0"..."9").contains(c)
      || c == "." || c == "_" || c == "-"
  }

  enum Failure: Error { case name, arguments, rename, flush, delete, create }

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

  // Forces a written file's bytes to the disk (D54), so that the rename
  // which publishes it can never leave an empty or partial night after a
  // power loss. F_FULLFSYNC where the file system has it, else fsync.
  static func flush(_ url: URL) throws {
    let fd = Darwin.open(url.path, O_RDONLY)
    guard fd >= 0 else { throw Failure.flush }
    defer { Darwin.close(fd) }
    if fcntl(fd, F_FULLFSYNC) == -1 && fsync(fd) == -1 { throw Failure.flush }
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
      let url = try file(a["name"])
      try bytes.data.write(to: url, options: [.completeFileProtection])
      try flush(url)
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
    case "append":
      let a = try arguments(call)
      guard let bytes = a["bytes"] as? FlutterStandardTypedData, let sync = a["sync"] as? Bool else {
        throw Failure.arguments
      }
      let url = try file(a["name"])
      if !fm.fileExists(atPath: url.path) {
        guard fm.createFile(
          atPath: url.path, contents: nil, attributes: [.protectionKey: FileProtectionType.complete])
        else { throw Failure.create }
      }
      let handle = try FileHandle(forWritingTo: url)
      defer { try? handle.close() }
      try handle.seekToEnd()
      try handle.write(contentsOf: bytes.data)
      if sync { try flush(url) }
      return nil
    case "size":
      let url = try file(call.arguments)
      guard fm.fileExists(atPath: url.path) else { return nil }
      return (try fm.attributesOfItem(atPath: url.path)[.size] as? NSNumber)?.int64Value
    case "readRange":
      let a = try arguments(call)
      guard let offset = a["offset"] as? Int, let length = a["length"] as? Int, offset >= 0, length >= 0 else {
        throw Failure.arguments
      }
      let handle = try FileHandle(forReadingFrom: try file(a["name"]))
      defer { try? handle.close() }
      try handle.seek(toOffset: UInt64(offset))
      return FlutterStandardTypedData(bytes: try handle.read(upToCount: length) ?? Data())
    case "copyTail":
      let a = try arguments(call)
      guard let offset = a["offset"] as? Int, offset >= 0 else { throw Failure.arguments }
      let from = try file(a["from"])
      let to = try file(a["to"])
      let handle = try FileHandle(forReadingFrom: from)
      defer { try? handle.close() }
      try handle.seek(toOffset: UInt64(offset))
      let rest = try handle.readToEnd() ?? Data()
      try rest.write(to: to, options: [.completeFileProtection])
      try flush(to)
      return nil
    case "deleteAll":
      // Every entry, whatever its name (D54): one that cannot be removed
      // does not stop the others, and the call then answers with a code.
      let dir = try folder()
      var failed = false
      for name in try fm.contentsOfDirectory(atPath: dir.path) {
        do { try fm.removeItem(at: dir.appendingPathComponent(name)) } catch { failed = true }
      }
      if failed { throw Failure.delete }
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
