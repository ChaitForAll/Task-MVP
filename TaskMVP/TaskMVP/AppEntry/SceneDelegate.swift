//
//  SceneDelegate.swift
//  TaskMVP
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    //MARK: Property(s)
    
    var window: UIWindow?

    //MARK: Function(s)

    func scene(
        _ scene: UIScene, 
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }
        let window = UIWindow(windowScene: windowScene)
        window.makeKeyAndVisible()
        window.rootViewController = TodoMarkingViewController()
        self.window = window
    }
}

