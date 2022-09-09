extension UnsignedInteger {

    init<T: Collection>(_ bytes: T) where T.Element == UInt8 {
        precondition(bytes.count <= MemoryLayout<Self>.size, "bytes count: \(bytes.count), layout: \(MemoryLayout<Self>.size)")

        var value = UInt64()

        for byte in bytes {
            value <<= 8
            value |= UInt64(byte)
        }

        self.init(value)
    }
}
