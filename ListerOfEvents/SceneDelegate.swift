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
        let apiBaseUrl = URL(string: "http://my-json-server.typicode.com/livestyled/mock-api/events")!
        let httpApiService = HttpApiService()
        let imageStore = ImageStore()
        let eventStore = EventStore()
        let favouriteStore = FavouriteStore()
        
        let interactor = EventsListViewInteractor(
            imageService: ImageService(httpApiService: httpApiService, imageStore: imageStore),
            eventService: EventService(
                apiService: httpApiService,
                eventStore: eventStore,
                favouritesStore: favouriteStore,
                remoteUrl: apiBaseUrl),
            eventStore: eventStore,
            favouriteStore: favouriteStore)
        let eventListTableViewController = EventsListTableViewController.controller(interactor: interactor)
        interactor.viewController = eventListTableViewController
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = eventListTableViewController
        self.window = window
        window.makeKeyAndVisible()
    }

}

