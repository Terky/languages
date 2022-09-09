struct Varint {

    let value: Int64
    let size: UInt8

    init(_ stream: [UInt8]) {
        let usableBytes = Self.readUsableBytes(stream)
        size = UInt8(usableBytes.count)
        value = usableBytes
            .enumerated()
            .reduce(.zero) { (result, element) in
                let (index, byte) = element
                let size = index == 8 ? 8 : 7
                return (result << size) + Int64(Self.usableValue(usableSize: size, byte: byte))
            }
    }

    private static func usableValue(usableSize: Int, byte: UInt8) -> UInt8 {
        if usableSize == 8 {
            return UInt8(usableSize)
        } else {
            return byte & Constants.lastSevenBitsMask
        }
    }

    private static func readUsableBytes(_ stream: [UInt8]) -> [UInt8] {
        var usableBytes = [UInt8]()

        for idx in 0..<8 {
            usableBytes.append(stream[idx])

            if startsWithZero(byte: stream[idx]) {
                break
            }        
        }

        return usableBytes
    }

    private static func startsWithZero(byte: UInt8) -> Bool {
        return (byte & Constants.firstBitMask) == .zero
    }
}

private enum Constants {

    static let firstBitMask: UInt8 = 0b10000000
    static let lastSevenBitsMask: UInt8 = 0b01111111
}
