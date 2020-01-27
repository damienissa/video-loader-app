//
//  DashboardPresenter.swift
//  youtube-loader-ios
//
//  Created by Dima Virych on 26.01.2020.
//  Copyright (c) 2020 Virych. All rights reserved.
//
//  This file was generated by the 🐍 VIPER generator
//

import Foundation

final class DashboardPresenter<Interactor: DashboardInteractorInterface> {
    
    // MARK: - Private properties -
    
    private unowned let view: DashboardViewInterface
    private let interactor: Interactor
    private let wireframe: DashboardWireframeInterface
    
    // MARK: - Lifecycle -
    
    init(view: DashboardViewInterface, interactor: Interactor, wireframe: DashboardWireframeInterface) {
        self.view = view
        self.interactor = interactor
        self.wireframe = wireframe
        interactor.output = { [weak self] result in
            self?.fill(result)
        }
    }
    
    func fill(_ result: Result<UIVideoElement, Error>) {
       
        DispatchQueue.main.async { [weak self] in
           
            do {
                let video = try result.get()
                self?.view.fill()
                self?.wireframe.fillLoaded(video: video)
            } catch {
                self?.view.fill(error)
            }
        }
    }
}

// MARK: - Extensions -

extension DashboardPresenter: DashboardPresenterInterface {
    
    func url(from text: String?) -> URL? {
        
        guard let str = text, let url = URL(string: str) else {
            return nil
        }
        
        return url
    }
    
    func fetch(for url: URL) {
        
        interactor.fetchData(url)
    }
}
