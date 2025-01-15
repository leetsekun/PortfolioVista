//
//  CalculatorView.swift
//  PortfolioVista
//
//  Created by leetsekun on 10/18/24.
//

import SwiftUI

struct CalculatorView: View {
    @Binding var displayText: String
    @State private var input1: [String] = []
    @State private var input2: [String] = []
    @State private var prevOp: Operator?
    @State private var isTypingFirstNumber: Bool = true

    private let numberPadColumns: [[String]] = [
        ["1", "4", "7", "."],
        ["2", "5", "8", "0"],
        ["3", "6", "9", "delete"],
        ["+  ×", "-  ÷", "完成"]
    ]

    enum Operator: String {
        case addition = "+"
        case subtraction = "-"
        case multiplication = "×"
        case division = "÷"
    }
    
    var body: some View {
        HStack(spacing: 5) {
            ForEach(numberPadColumns, id: \.self) { column in
                VStack(spacing: 5) {
                    ForEach(column, id: \.self) { symbol in
                        Button(action: {
                            self.buttonTapped(symbol)
                        }) {
                            if symbol == "delete" {
                                Image(systemName: "delete.left.fill")
                                    .font(.title2)
                                    .foregroundColor(.black)
                            } else {
                                Text(symbol)
                                    .font(symbol == "完成" ? .title2.weight(.semibold) : .title)
                                    .foregroundColor(symbol == "完成" ? .white : .black)
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: symbol == "完成" ? 118 : 56)
                        .background(symbol == "完成" ? Color.red : Color.white)
                        .cornerRadius(Constants.cornerRadius)
                    }
                }
            }
        }
    }

    private func buttonTapped(_ symbol: String) {
        switch symbol {
            case "0"..."9":
                handleNumberInput(symbol)
            case ".":
                handleDecimalInput()
            case "+  ×", "-  ÷":
                handleOperatorInput(symbol)
            case "delete":
                handleDelete()
            case "完成":
                handleEqual()
            default:
                break
        }
        updateDisplayText()
    }

    private func updateDisplayText() {
        if input1.isEmpty {
            displayText = "0.00"
            return
        }

        displayText = input1.joined(separator: "")
        if prevOp != nil {
            displayText += "\(prevOp!.rawValue)"
            displayText += input2.joined(separator: "")
        }
    }

    private func evaluateResult() {
        // prevent integer division
        if prevOp == .division && !input1.contains(".") && !input2.contains(".") {
            input2.append(".0")
        }

        let expressionString = (input1.joined(separator: "") + prevOp!.rawValue + input2.joined(separator: "")).replacingOccurrences(of: "×", with: "*").replacingOccurrences(of: "÷", with: "/")
        let expression = NSExpression(format: expressionString)
        
        if let result = expression.expressionValue(with: nil, context: nil) as? NSNumber {
            if result.doubleValue.isFinite {
                if result.doubleValue.truncatingRemainder(dividingBy: 1) == 0 {
                    input1 = String(Int(result.doubleValue)).map { String($0) }
                } else {
                    input1 = String(format: "%.2f", result.doubleValue).map { String($0) }
                }
            }
        } else {
            print("Invalid expression.")
        }
        input2 = []
        prevOp = nil
    }

    private func handleNumberInput(_ number: String) {
        var input = isTypingFirstNumber ? input1 : input2

        // handle decimal, there should be at most 2 digits after decimal point
        if input.count > 3 && input[input.count - 3] == "." {
            return
        }

        // handle leading zero
        if input == ["0"] && number == "0" {
            return
        }

        // handle leading zero
        if input == ["0"] && number != "0" {
            input = [number]
        } else {
            input.append(number)
        }

        if isTypingFirstNumber {
            input1 = input
        } else {
            input2 = input
        }
    }

    private func handleDecimalInput() {
        var input = isTypingFirstNumber ? input1 : input2

        if !input.contains(".") {
            if input.isEmpty {
                input.append("0")
            }
            input.append(".")
        }

        if isTypingFirstNumber {
            input1 = input
        } else {
            input2 = input
        }
    }

    private func handleOperatorInput(_ symbol: String) {
        let op: Operator = symbol == "+  ×" ? .addition : .subtraction
        
        // if the last character from displayText is an operator, we only need to update the prevOp
        if let last = displayText.last, "+-×÷".contains(last) {
            if op == prevOp {
                prevOp = op == .addition ? .multiplication : .division
            } else {
                prevOp = op
            }
            return
        }

        // check if there is trailing decimal point, remove it
        if let last = displayText.last, last == "." {
            if isTypingFirstNumber {
                input1.removeLast()
            } else {
                input2.removeLast()
            }
        }

        // if there is a previous operator, we should evaluate the intermediate result, 
        // otherwise, we should set the prevOp and switch to type the second number
        if prevOp != nil {
            evaluateResult()
        } else {
            isTypingFirstNumber = false
        }
        prevOp = op
    }

    private func handleDelete() {
        // handle empty input
        if input1.isEmpty && input2.isEmpty {
            return
        }

        // handle operator
        if let last = displayText.last, "+-×÷".contains(last) {
            prevOp = nil
            isTypingFirstNumber = true
            return
        }

        if isTypingFirstNumber {
            input1.removeLast()
        } else {
            input2.removeLast()
        }
    }

    private func handleEqual() {
        if input2.isEmpty {
            return
        }
        if input2.last == "." {
            input2.removeLast()
        }
        evaluateResult()
        isTypingFirstNumber = true
    }
}

#Preview {
    @Previewable @State var displayText: String = "0.00"
    return CalculatorView(displayText: $displayText)
}
