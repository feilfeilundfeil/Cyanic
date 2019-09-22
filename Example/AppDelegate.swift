//
//  AppDelegate.swift
//  Example
//
//  Created by Julio Miguel Alorro on 2/7/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import UIKit
import Cyanic
import RxSwift
import SideMenu

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let vc: ExampleLoginVC = ExampleLoginVC(
            viewModelOne: UsernameViewModel(initialState: UsernameState.default),
            viewModelTwo: PasswordViewModel(initialState: PasswordState.default)
        )

        let nvc: UINavigationController = UINavigationController(rootViewController: vc)

        self.window?.rootViewController = nvc
        self.window?.makeKeyAndVisible()

        let rightVC: SideMenuNavigationController = SideMenuNavigationController(
            rootViewController: ExampleCounterVC()
        )
        SideMenuManager.default.rightMenuNavigationController = rightVC
        rightVC.sideMenuDelegate = self
        rightVC.enableSwipeToDismissGesture = false
        rightVC.presentationStyle = .menuSlideIn
        rightVC.presentationStyle.onTopShadowRadius = 0.0
        rightVC.presentationStyle.onTopShadowColor = UIColor.clear
        rightVC.presentationStyle.onTopShadowOpacity = 0.0
        rightVC.dismissOnPush = false
        rightVC.statusBarEndAlpha = 0.0

         _ = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
               .subscribe(onNext: { _ in
                   print("Resource count \(RxSwift.Resources.total)")
               })

        return true
    }

}

extension AppDelegate: SideMenuNavigationControllerDelegate {
    func sideMenuWillAppear(menu: SideMenuNavigationController, animated: Bool) {
        print("Side Menu Will Appear")
    }
    func sideMenuDidAppear(menu: SideMenuNavigationController, animated: Bool) {
        print("Side Menu Did Appear")
    }
    func sideMenuWillDisappear(menu: SideMenuNavigationController, animated: Bool) {
        print("Side Menu Will Disappear")
    }
    func sideMenuDidDisappear(menu: SideMenuNavigationController, animated: Bool) {
        print("Side Menu Did Disappear")
    }
}

