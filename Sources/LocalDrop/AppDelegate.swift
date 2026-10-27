import AppKit

final class AppDelegate: NSObject, NSApplicationDelegate {
    private var windowController: DropWindowController?

    func applicationDidFinishLaunching(_ notification: Notification) {
        let controller = DropWindowController()
        windowController = controller
        controller.showWindow(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        true
    }
}
