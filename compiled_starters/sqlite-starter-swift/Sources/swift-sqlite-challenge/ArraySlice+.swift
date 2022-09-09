extension ArraySlice {

    func chunks(size chunkSize: Int) -> [Self] {
        var result = [Self]()

        var currentOffset = 0
        for _ in 1...(count / chunkSize) {
            let newOffset = chunkSize + currentOffset
            if count - chunkSize < newOffset {
                result.append(self[currentOffset...])
            } else {
                result.append(self[currentOffset..<newOffset])
            }
            currentOffset = newOffset
        }

        return result
    }
}
