//
//  circleView.swift
//  TalkSocial
//
//  Created by D on 10/3/16.
//  Copyright © 2016 D Conway. All rights reserved.
//

import UIKit

class circleView: UIImageView {

    override func layoutSubviews() {
        layer.cornerRadius = self.frame.width / 2
        clipsToBounds = true
    }

}
