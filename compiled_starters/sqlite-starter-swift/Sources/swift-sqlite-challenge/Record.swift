struct Record {

    private(set) var columns: [[UInt8]]

    init(_ stream: [UInt8]) {
        let varint = Varint(stream)
        let headerSize = varint.value
        var headerOffset = Int(varint.size)
        var contentOffset = Int(varint.value)

        columns = []

        while headerOffset < headerSize {
            let columnInfo = Varint(Array(stream[headerOffset...]))
            let column = Self.parseColumnValue(serialType: Int(columnInfo.value), Array(stream[contentOffset...]))
            
            columns.append(column)

            headerOffset += Int(columnInfo.size)
            contentOffset += column.count
        }
    }

    private static func parseColumnValue(serialType: Int, _ stream: [UInt8]) -> [UInt8] {
        switch serialType {
        case 1:
            return Array(stream[0..<1])
        case let type where isText(serialType: type):
            return Array(stream[0..<getTextLength(serialType: type)])
        default:
            fatalError("Invalid serial type: \(serialType)")
        }
    }

    private static func isText(serialType: Int) -> Bool {
        return serialType >= 13 && !serialType.isMultiple(of: 2)
    }

    private static func getTextLength(serialType: Int) -> Int {
        return (serialType - 13) / 2
    }
}
