//
//  ViewModel.swift
//  ViewModel
//
//  Created by Jack Finnis on 30/11/2021.
//

import Foundation
import ComplexModule

class ViewModel: ObservableObject {
    @Published var t: Double = 0
    
    @Published var m: Double = 1
    @Published var k: Double = 1
    @Published var c: Double = 2
    
    var a: Complex<Double> { Complex(c / (2*m)) }
    var b: Complex<Double> { Complex.sqrt(Complex(pow(c, 2)) - Complex(4*m*k)) / Complex(2*m) }
    var y: Complex<Double> { Complex.exp((-a+b)*Complex(t)) + Complex.exp((-a-b)*Complex(t)) }
    
    func reset() {
        t = 0
    }
    
    var type: DampingType {
        if pow(c, 2) > 4*m*k {
            return .over
        } else if pow(c, 2) < 4*m*k {
            return .under
        } else {
            return .critical
        }
    }
}

enum DampingType: String {
    case under = "Underdamped"
    case critical = "Critical Damping"
    case over = "Overdamped"
}
