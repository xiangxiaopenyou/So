//
//  NSStringExtention.swift
//  fitplus
//
//  Created by 天池邵 on 15/8/13.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

import Foundation

extension String {
    var imageUrl: String {return "http://7u2h8u.com1.z0.glb.clouddn.com/" + self}
    var thumblImageUrl: String {return "http://7u2h8u.com1.z0.glb.clouddn.com/\(self)?imageView/5/w/160/h/160"}
}