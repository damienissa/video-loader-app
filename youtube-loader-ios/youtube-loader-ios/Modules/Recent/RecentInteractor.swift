//
//  RecentInteractor.swift
//  youtube-loader-ios
//
//  Created by Dima Virych on 26.01.2020.
//  Copyright (c) 2020 Virych. All rights reserved.
//
//  This file was generated by the 🐍 VIPER generator
//

import Foundation
import Core

final class RecentInteractor {
    
    let engine = Engine()
}

// MARK: - Extensions -

extension RecentInteractor: RecentInteractorInterface {
    
    var videos: [Video] {
        engine.videos()
    }
}