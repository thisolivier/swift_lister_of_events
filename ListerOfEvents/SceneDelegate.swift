//
//  SceneDelegate.swift
//  ListerOfEvents
//
//  Created by Olivier Butler on 11/12/2019.
//  Copyright © 2019 Olivier Butler. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else {
            return
        }
        //http://my-json-server.typicode.com/livestyled/mock-api/events
        let interactor = EventsListViewInteractor()
        let eventListTableViewController = EventsListTableViewController.controller(interactor: interactor)
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = eventListTableViewController
        self.window = window
        window.makeKeyAndVisible()
    }

}

