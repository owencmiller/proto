using WebSockets
using Sockets
const LOCALIP = string(Sockets.getipaddr())
const PORT = 8080

function coroutine(req, ws)
    push!(clients, ws)
    @info "New Incoming Connection"
    
    while isopen(ws)
        data, = readguarded(ws)
        s = String(data)
        if s == ""
            writeguarded(ws, "Goodbye!")
            break
        end
        @info "Received: $s"
        writeguarded(ws, "Hello! Type 'exit' to leave")
    end
    @info "Will now close " ws
end

const server = WebSockets.ServerWS((req) -> WebSockets.Response(200), coroutine)

@info "In browser > $LOCALIP:8080 , F12> console > ws = new WebSocket(\"ws:/$LOCALIP:8080\") "
@async WebSockets.with_logger(WebSocketLogger()) do
    WebSockets.serve(server, LOCALIP, 8080)
end

