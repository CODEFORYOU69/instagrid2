//
//  modele.swift
//  instagrid 2
//
//  Created by younes ouasmi on 20/01/2024.
//

import Foundation
import UIKit

struct ImageGrid {
    var images: [UIImage?] = Array(repeating: nil, count: 4)
    var currentTemplate: GridTemplate = .template1

    enum GridTemplate {
        case template1
        case template2
        case template3

    }

    mutating func setImage(_ image: UIImage, atIndex index: Int) {
        guard index >= 0 && index < images.count else { return }
        images[index] = image
    }

    mutating func setTemplate(_ template: GridTemplate) {
        currentTemplate = template
    }

    }
