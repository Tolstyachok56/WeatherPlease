//
//  AppDelegate.swift
//  WeatherPlease
//
//  Created by Виктория Бадисова on 29.01.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let scheduler = Scheduler()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        appDesign()
        UNUserNotificationCenter.current().delegate = self
        scheduler.deactivateAllDeliveredNotifications()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
    }

    fileprivate func appDesign() {
        // White and notHidden status bar
        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.statusBarStyle = .lightContent
        
        // Transparent navigation bar
        let navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.setBackgroundImage(UIImage(), for: .default)
        navigationBarAppearance.shadowImage = UIImage()
        navigationBarAppearance.isTranslucent = true
        
        //Transparent tab bar
        let tabBarAppearance = UITabBar.appearance()
        tabBarAppearance.backgroundImage = UIImage()
        tabBarAppearance.shadowImage = UIImage()
        tabBarAppearance.isTranslucent = true
    }
    
    private func updateHomeViewController() {
        if let rootVC = window?.rootViewController as? UITabBarController {
            rootVC.selectedIndex = 0
            if let homeVC = rootVC.selectedViewController as? HomeViewController {
                homeVC.refresh(homeVC.refreshButton)
            }
        }
    }
    
    private func reloadNotificationsTableView() {
        if let rootVC = self.window?.rootViewController as? UITabBarController,
            let selectedVC = rootVC.selectedViewController as? UINavigationController,
            let visibleVC = selectedVC.visibleViewController as? NotificationsViewController{
            visibleVC.notificationsTableView.reloadData()
        }
    }
    
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        scheduler.deactivate(deliveredNotification: notification)
        scheduler.deactivateAllDeliveredNotifications()
        reloadNotificationsTableView()
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.actionIdentifier == UNNotificationDefaultActionIdentifier {
            scheduler.deactivate(deliveredNotification: response.notification)
            scheduler.deactivateAllDeliveredNotifications()
        }
        updateHomeViewController()
        completionHandler()
    }
    
}
