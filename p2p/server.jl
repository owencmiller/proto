using WebSockets
const BAREHTML = "<head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">
 <title>Empty.html</title></head><body></body></html>"
import Sockets
const LOCALIP = string(Sockets.getipaddr())
const PORT = 443

function coroutine(req, ws)
    @info "Started coroutine for " ws
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

handle(req) = replace(BAREHTML, "<body></body>" => BODY) |> WebSockets.Response

const server = WebSockets.ServerWS(handle, coroutine)

@info "In browser > $LOCALIP:$PORT , F12> console > ws = new WebSocket(\"ws://$LOCALIP:$PORT\") "
@async WebSockets.with_logger(WebSocketLogger()) do
    WebSockets.serve(server, LOCALIP, PORT)
end
