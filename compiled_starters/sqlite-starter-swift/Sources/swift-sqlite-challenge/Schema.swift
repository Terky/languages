struct Schema {

    let type: String
    let name: String
    let tableName: String
    let rootPage: UInt8
    let sql: String

    init?(_ record: Record) {
        guard 
            record.columns.count == 5,
            let type = String(bytes: record.columns[0], encoding: .utf8),
            let name  = String(bytes: record.columns[1], encoding: .utf8),
            let tableName = String(bytes: record.columns[2], encoding: .utf8),
            let sql = String(bytes: record.columns[4], encoding: .utf8),
            record.columns[3].count >= 1
        else {
            return nil
        }
        self.type = type
        self.name = name
        self.tableName = tableName
        self.sql = sql
        rootPage = record.columns[3][0]
    }
}
