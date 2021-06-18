//
//  LoginModel.swift
//  PublisherSubscriber
//
//  Created by Thongchai Subsaidee on 18/6/2564 BE.
//

import Foundation

struct LoginModel: Decodable, Hashable {
    let username: String
    let password: String
}
