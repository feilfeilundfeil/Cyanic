//
//  AppDelegate.swift
//  Example
//
//  Created by Julio Miguel Alorro on 2/7/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import UIKit
import FFUFComponents

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: UIScreen.main.bounds.width, height: 10.0)
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0

//        let viewModel: ExampleViewModel  = ExampleViewModel(initialState: ExampleState.default)
//
//        let vc = ExampleVC(layout: layout, cellTypes: [ComponentCell.self], throttleType: ThrottleType.throttle, viewModel: viewModel)

        let viewModelA = ViewModelA(initialState: StateA.default)
        let viewModelB = ViewModelB(initialState: StateB.default)

        let viewModel = CompositeViewModel(
            first: viewModelA,
            second: viewModelB,
            initialState: CompositeState(firstState: viewModelA.currentState, secondState: viewModelB.currentState, isTrue: false)
        )

        let vc = CompositeVC(layout: layout, cellTypes: [ComponentCell.self], throttleType: ThrottleType.debounce, viewModel: viewModel)

        self.window?.rootViewController = UINavigationController(rootViewController: vc)
        self.window?.makeKeyAndVisible()

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
    }


}

