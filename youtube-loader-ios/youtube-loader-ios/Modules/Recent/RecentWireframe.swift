//
//  RecentWireframe.swift
//  youtube-loader-ios
//
//  Created by Dima Virych on 26.01.2020.
//  Copyright (c) 2020 Virych. All rights reserved.
//
//  This file was generated by the 🐍 VIPER generator
//

import UIKit
import BaseViper
import Core

final class RecentWireframe: BaseWireframe {

    // MARK: - Private properties -

    private let storyboard = UIStoryboard(name: "Recent", bundle: nil)

    // MARK: - Module setup -

    init() {
        let moduleViewController = storyboard.instantiateViewController(ofType: RecentViewController.self)
        super.init(viewController: moduleViewController)

        let interactor = RecentInteractor(provider: EngineFactory.createEngine(store: try! DatabaseManager.realm(inMemory: false)))
        let presenter = RecentPresenter(view: moduleViewController, interactor: interactor, wireframe: self)
        moduleViewController.presenter = presenter
    }

}

// MARK: - Extensions -

extension RecentWireframe: RecentWireframeInterface {
    
    func showDetailScreen(for video: UIVideoElement) {
        
        navigationController?.pushWireframe(DetailWireframe(video: video))
    }
}


// MARK: - Adapter

protocol ListDataProvider {
    func listOfVideos() -> [UIVideoElement]
}


extension Engine: ListDataProvider {
    
    func listOfVideos() -> [UIVideoElement] {
        
        videos().map {
            UIVideoElement(video: $0)
        }
    }
}
