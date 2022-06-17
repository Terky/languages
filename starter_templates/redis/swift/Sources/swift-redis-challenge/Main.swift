import NIOCore
import NIOPosix

@main
struct Main {

    // Uncomment this block to pass the first stage
    // final class ServerChannel: ChannelInboundHandler {
    //     typealias InboundIn = ByteBuffer
    //     typealias InboundOut = ByteBuffer
    //
    //     func channelActive(context: ChannelHandlerContext) {
    //         guard let address = context.remoteAddress else {
    //             print("error: Failed to read client remote address")
    //             return
    //         }
    //         print("Client \(address) connected")
    //     }
    //
    //     func channelRead(context: ChannelHandlerContext, data: NIOAny) {
    //         let byteBuffer = unwrapInboundIn(data)
    //         print("Received data from client \"\(String(buffer: byteBuffer))\"")
    //     }
    // }

    static func main() async throws {
        print("Logs from your program will appear here")

        // Uncomment this block to pass the first stage
        // let group = MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)
        // let bootstrap = ServerBootstrap(group: group)
        //     .serverChannelOption(ChannelOptions.backlog, value: 5)
        //     .serverChannelOption(ChannelOptions.socketOption(.so_reuseaddr), value: 1)
        //     .childChannelInitializer { channel in
        //         channel.pipeline.addHandler(ServerChannel())
        //     }
        //
        // let channel = try bootstrap.bind(host: "0.0.0.0", port: 6379).wait()
        //
        // try channel.closeFuture.wait()
        //
        // try group.syncShutdownGracefully()
    }
}
