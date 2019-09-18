//
//  UInt11.swift
//
//  Copyright © 2018 BitcoinKit developers
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation

struct UInt11: ExpressibleByIntegerLiteral {
    static var bitWidth: Int { 11 }

    static var max16: UInt16 { UInt16(2047) }
    static var max: UInt11 { UInt11(exactly: max16)! }

    static var min: UInt11 { 0 }

    private let valueBoundBy16Bits: UInt16

    init?<T>(exactly source: T) where T: BinaryInteger {
        guard
            let valueBoundBy16Bits = UInt16(exactly: source),
            valueBoundBy16Bits < 2048 else { return nil }

        self.valueBoundBy16Bits = valueBoundBy16Bits
    }

}

extension UInt11 {
    init<T>(truncatingIfNeeded source: T) where T: BinaryInteger {
         let valueBoundBy16Bits = UInt16(truncatingIfNeeded: source)
         self.valueBoundBy16Bits = Swift.min(UInt11.max16, valueBoundBy16Bits)
     }

     /// Creates a new integer value from the given string and radix.
     init?<S>(_ text: S, radix: Int = 10) where S: StringProtocol {
         guard let uint16 = UInt16(text, radix: radix) else { return nil }
         self.init(exactly: uint16)
     }

    init(integerLiteral value: Int) {
        guard let exactly = UInt11(exactly: value) else {
            fatalError("bad integer literal value does not fit in UInt11, value passed was: \(value)")
        }
        self = exactly
    }
}

extension UInt11 {
    var binaryString: String {
        let binaryString = String(valueBoundBy16Bits.binaryString.suffix(Self.bitWidth))
        assert(UInt16(binaryString, radix: 2)! == valueBoundBy16Bits, "incorrect conversion.")
        return binaryString
    }
}
