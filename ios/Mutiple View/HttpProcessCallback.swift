//
//  HttpProcessCallback.swift
//  Mutiple View
//
//  Created by hailor on 2017/11/7.
//  Copyright © 2017年 hailor. All rights reserved.
//

import Foundation
import React

protocol CallbackDelegate {
    func progress(progress:Float, callback:RCTResponseSenderBlock)
    func success(object:NSObject, callback:RCTResponseSenderBlock)
    func failure(object:NSObject, callback:RCTResponseSenderBlock)
}

typealias test = () -> ()

class HttpProcessCallback:NSObject{
//    var callbackDelegate:CallbackDelegate?
    typealias CallbackSuccess = (_ object:NSObject) -> ()
    typealias CallbackProgress = (_ progress:Float) -> ()
    typealias CallbackFailure = (_ object:NSObject) -> ()

    
    func progrss(progess:Float, callbackProgess:CallbackProgress){
        callbackProgess(progess)
    }
    
    func success(object:NSObject, callbackSuccess:CallbackSuccess){
        callbackSuccess(object)
    }
    
    func failure(object:NSObject, callbackFailure:CallbackFailure){
        callbackFailure(object)
    }

}
