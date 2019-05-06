//
//  AppDelegate.swift
//  Example
//
//  Created by Julio Miguel Alorro on 2/7/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import UIKit
import Cyanic
import SideMenu

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        let viewModel: ExampleListViewModel  = ExampleListViewModel(initialState: ExampleListState.default)
//        let vc = ExampleListVC(viewModel: viewModel)
//        let vc = ExampleSectionedVC()
        let vc: ExampleLoginVC = ExampleLoginVC(
            viewModelOne: UsernameViewModel(initialState: UsernameState.default),
            viewModelTwo: PasswordViewModel(initialState: PasswordState.default)
        )

        let nvc: UINavigationController = UINavigationController(rootViewController: vc)

        self.window?.rootViewController = nvc
        self.window?.makeKeyAndVisible()

        let rightVC: UISideMenuNavigationController = UISideMenuNavigationController(
            rootViewController: ExampleCounterVC()
        )

        SideMenuManager.default.menuRightNavigationController = rightVC
        SideMenuManager.default.menuLeftNavigationController = nil
        SideMenuManager.default.menuEnableSwipeGestures = false
        SideMenuManager.default.menuLeftSwipeToDismissGesture = nil
        SideMenuManager.default.menuRightSwipeToDismissGesture = nil
        SideMenuManager.default.menuShadowRadius = 0.0
        SideMenuManager.default.menuShadowColor = UIColor.clear
        SideMenuManager.default.menuShadowOpacity = 0.0
        SideMenuManager.default.menuDismissOnPush = false
        SideMenuManager.default.menuFadeStatusBar = false
        SideMenuManager.default.menuPresentMode = SideMenuManager.MenuPresentMode.menuSlideIn

        return true
    }

}

