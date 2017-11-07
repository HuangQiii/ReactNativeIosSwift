//
//  HttpProcessCallback.swift
//  Mutiple View
//
//  Created by hailor on 2017/11/7.
//  Copyright © 2017年 hailor. All rights reserved.
//

import Foundation

protocol HttpProcessCallback {
    func progress(progress:Float)
    func success(object:NSObject)
    func failure(object:NSObject)
}
