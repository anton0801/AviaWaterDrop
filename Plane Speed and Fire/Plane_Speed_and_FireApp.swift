import SwiftUI

@main
struct Plane_Speed_and_FireApp: App {
    
    @UIApplicationDelegateAdaptor(PlaneAppDelegate.self) var planeAppDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class PlaneAppDelegate: NSObject, UIApplicationDelegate {
        
    static var orientationLock = UIInterfaceOrientationMask.landscape

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return PlaneAppDelegate.orientationLock
    }
    
}
