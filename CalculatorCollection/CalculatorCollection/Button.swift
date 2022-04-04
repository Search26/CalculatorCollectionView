//
//  Button.swift
//  CalculatorCollection
//
//  Created by Ney on 12/06/2021.
//

import UIKit
enum Type{
    case add
    case sub
    case mul
    case div
    case percent
    case sign
    case delete
    case cal
    case comma
    case number
}

class Button: UIButton {
    var index : Int = 0
    var value : Int = 0
    var displayValue : String = ""
    var type : Type = .number
    override init(frame : CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func setButton(index : Int , value: Int , displayValue : String , type : Type ){
        self.index = index
        self.value = value
        self.displayValue = displayValue
        self.type = type
    }
}
