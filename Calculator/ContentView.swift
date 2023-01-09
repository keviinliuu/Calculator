//
//  ContentView.swift
//  Calculator
//
//  Created by Kevin Liu on 2022-12-27.
//

import SwiftUI

enum CalcButton: String{
    case one = "1"
    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case six = "6"
    case seven = "7"
    case eight = "8"
    case nine = "9"
    case zero = "0"
    case decimal = "."
    case equals = "="
    case add = "+"
    case minus = "-"
    case multiply = "X"
    case divide = "/"
    case negative = "-/+"
    case clear = "C"
    case percent = "%"
    
    var buttonColor: Color {
        switch self {
        case .add, .minus, .multiply, .divide, .equals:
            return Color(UIColor(red: 0.52, green: 0.83, blue: 0.92, alpha: 1))
        case .clear, .negative, .percent:
            return Color(UIColor(red: 0.99, green: 0.99, blue: 0.74, alpha: 1))
        default:
            return Color(UIColor(red: 0.89, green: 0.48, blue: 0.69, alpha: 1))
        }
    }
    
    var textColor: Color {
        switch self {
        case .add, .minus, .multiply, .divide, .equals, .clear, .negative, .percent:
            return Color(.black)
        default:
            return Color(.white)
        }
    }
}

enum Operation {
    case add, minus, multiply, divide, none
    
}

struct ContentView: View {
    
    @State var value = "0"
    @State var currentOperation: Operation = .none
    @State var runningNumber = 0.0
    @State var newNumber = false;
    
    let buttons: [[CalcButton]] = [
        [.clear, .negative, .percent, .divide],
        [.seven, .eight, .nine, .multiply],
        [.four, .five, .six, .minus],
        [.one, .two, .three, .add],
        [.zero, .decimal, .equals],
    ]
    
    var body: some View {
        
        ZStack {
            Color(red: 0.1176, green: 0.0863, blue: 0.2157)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                HStack{
                    Spacer()
                    Text(value)
                        .bold()
                        .font(.system(size: 100))
                        .foregroundColor(.white)
                }
                .padding()
                
                ForEach(buttons, id: \.self) { row in
                    HStack(spacing: 12){
                        ForEach(row, id: \.self) { item in
                            Button(action: {
                                self.didTap(button: item)
                            }, label: {
                                Text(item.rawValue)
                                    .font(.system(size: 32))
                                    .frame(
                                        width: self.buttonWidth(item: item),
                                        height: self.buttonHeight()
                                    )
                                    .background(item.buttonColor)
                                    .foregroundColor(item.textColor)
                                    .cornerRadius(60)
                            })
                        }
                    }
                    .padding(.bottom, 3)
                    
                }
            }
        }
    }
    
    func didTap(button: CalcButton) {
        switch button {
        case .add, .minus, .multiply, .divide, .equals:
            newNumber = true
            if button == .add {
                self.currentOperation = .add
                self.runningNumber = Double(self.value) ?? 0.0
            }
            else if button == .minus {
                self.currentOperation = .minus
                self.runningNumber = Double(self.value) ?? 0.0
            }
            else if button == .multiply {
                self.currentOperation = .multiply
                self.runningNumber = Double(self.value) ?? 0.0
            }
            else if button == .divide {
                self.currentOperation = .divide
                self.runningNumber = Double(self.value) ?? 0.0
            }
            else if button == .equals {
                if self.currentOperation == .divide && (Int(self.value) ?? 0) == 0{
                    self.value = "Error"
                }
                else {
                    setResult(result: calculateResult())
                }
            }
        case .clear:
            self.value = "0"
        case .decimal:
            if !self.value.contains(".") && self.value != "0" {
                self.value = "\(self.value)."
            }
        case .negative:
            self.runningNumber = Double(self.value) ?? 0.0
            self.runningNumber *= -1
            setResult(result: runningNumber)
        case .percent:
            self.runningNumber = Double(self.value) ?? 0.0
            self.runningNumber /= 100
            setResult(result: runningNumber)
        default:
            let number = button.rawValue
            if self.value == "0" || newNumber {
                value = number
                newNumber = false;
            }
            else {
                self.value = "\(self.value)\(number)"
            }
        }
    }
    
    func buttonWidth(item: CalcButton) -> CGFloat {
        if item == .zero {
            return ((UIScreen.main.bounds.width - (4*12)) / 4) * 2
        }
        return (UIScreen.main.bounds.width - (5*12)) / 4
    }
    
    func buttonHeight() -> CGFloat {
        return (UIScreen.main.bounds.width - (5*12)) / 4
    }
    
    func calculateResult() -> Double {
        var result = 0.0;
        let runningValue = self.runningNumber
        let currentValue = Int(self.value) ?? 0
        switch self.currentOperation {
        case .add:
            result = runningValue + Double(currentValue)
        case .minus:
            result = runningValue - Double(currentValue)
        case .multiply:
            result = runningValue * Double(currentValue)
        case .divide:
            result = runningValue / Double(currentValue)
        case .none:
            break
        }
        
        return result
    }
    
    func setResult(result: Double) {
        if floor(result) == result {
            self.value = "\(Int(result))"
        }
        else {
            self.value = "\(result)"
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
