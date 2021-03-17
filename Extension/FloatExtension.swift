//
//  FloatExtension.swift
//  CountOnMe
//
//  Created by Manon Russo on 15/03/2021.
//  Copyright © 2021 Vincent Saluzzo. All rights reserved.
//

import Foundation

 extension Float {
    /// This methods is called above in displayResult(), delete decimal for integer number.
    func removeZerosFromEnd() -> String {
        let formatter = NumberFormatter()
        let number = NSNumber(value: self)
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        return String(formatter.string(from: number) ?? "\(self)")
    }
}
