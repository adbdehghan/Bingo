//
//  CalculatorBrain.swift
//  Stanford Calculator
//
//  Created by Nicholas Grana on 4/12/17.
//  Copyright © 2017 Nicholas Grana. All rights reserved.
//

import Foundation

/*
 
 - Alt+Click to specify class on right
 - Edit > Emojis & Symbols for all font symbols
 
 */

// structs get default initializor automatically so no init errors
struct CalculatorBrain {
    
    var resultIsPending: Bool {
        return pendingBinaryOperation != nil
    }
    
    // Created when you click value then operation (4 +) and then performs when you specify last value (4 + 3)
    private struct PendingBinaryOperation {
        
        let function: (Double, Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    // generic value for dictionary to store different types of operations with specific values
    private enum Operation {
        case constant(Double) // PI, e
        case unary((Double) -> Double) // sin, cos
        case binary((Double, Double) -> Double) // +, -
        case equals // =
    }
    
    // accumluates all values (final answer), not set when it starts
    private var accumulator: Double?
    // stores the pending operation (4 +) until next number is specified
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    var description = ""
    
    // simple table to easily connect values and functions to specific button titles
    private var operations: Dictionary<String, Operation> =
        [
            "π" : .constant(Double.pi),
            "e" : .constant(M_E),
            "√" : .unary(sqrt),
            "sin" : .unary(sin),
            "cos" : .unary(cos),
            "tan" : .unary(tan),
            "%" : .unary({ $0 * 0.01 }),
            "+/-" : .unary({ -$0 }),
            "+" : .binary({ $0 + $1 }),
            "-" : .binary({ $0 - $1 }),
            "÷" : .binary({ $0 / $1 }),
            "×" : .binary({ $0 * $1 }),
            "=" : .equals
    ]
    
    // accumulator is private and this allows other classes to get it
    var result: Double? {
        get {
            return accumulator
        }
    }
    
    // prevents constant values and answers from showing up in description (only the symbol should)
    var appendAccumulator = true
    
    // performs different types of operations from the operations table and manages the different types of operations
    // set whenever a button that is not a number is clicked
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                accumulator = value
                description += " " + symbol
                appendAccumulator = false
            case .unary(let function) where accumulator != nil:
                
                if resultIsPending || description.isEmpty {
                    description += " \(symbol)(\(accumulator!))"
                } else {
                    description = "\(symbol)(\(description))"
                }
                
                accumulator = function(accumulator!)
                appendAccumulator = false
            case .binary(let function) where accumulator != nil && pendingBinaryOperation == nil:
                pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                
                if description.isEmpty {
                    description += "\(accumulator!) \(symbol)"
                } else {
                    description += " \(symbol)"
                }
                appendAccumulator = true
            case .equals where accumulator != nil && pendingBinaryOperation != nil:
                if appendAccumulator {
                    description += " " + String(accumulator!)
                }
                
                accumulator = pendingBinaryOperation!.perform(with: accumulator!)
                pendingBinaryOperation = nil
                appendAccumulator = true
            default: // when the where clauses are false
                break
            }
        }
    }
    
    mutating func reset() {
        description = ""
        accumulator = nil
        pendingBinaryOperation = nil
    }
    
    // marks as mutating so Swift knows when to copy a value
    // set whenever a number is clicked
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
    }
}
