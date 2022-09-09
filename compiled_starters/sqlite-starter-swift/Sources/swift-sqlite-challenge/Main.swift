import Foundation

@main
struct Main {

    static func main() async throws {
        switch CommandLine.argc {
        case 0, 1:
            print("Missing <database path> and <command>")
            return
        case 2:
            print("Missing <command>")
            return
        default:
            break
        }

        let path = CommandLine.arguments[1]
        let command = CommandLine.arguments[2]

        let database = try Data(contentsOf: URL(fileURLWithPath: path))
        
        switch command {
        case ".dbinfo":
            let pageHeader = PageHeader(Array(database[100...107]))

            let cellPointers = Array(database[108...])
                .prefix(Int(pageHeader.numberOfCells) * 2)
                .chunks(size: 2)
                .map(Array.init)
                .map(UInt16.init)
                .map(Int.init)

            let schemas = cellPointers.compactMap { cellPointer -> Schema? in
                let stream = Array(database[cellPointer...])

                let payload = Varint(stream)
                let rowId = Varint(Array(stream[Int(payload.size)...]))

                let record = Record(Array(stream[Int(payload.size + rowId.size)...]))
                return Schema(record)
            }

            // You can use print statements as follows for debugging, they'll be visible when running tests.
            print("Logs from your program will appear here!")

            // Uncomment this block to pass the first stage
            // print("number of tables: \(schemas.count)")
        default:
            fatalError("Invalid command \(command)")
        }
    }
}
