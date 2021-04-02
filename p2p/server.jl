using WebSockets
using Sockets
using UUIDs
const LOCALIP = string(Sockets.getipaddr())
const PORT = 8080

struct Client
    uuid :: UUID
    ws :: WebSocket
    username :: string
end

struct Message
    uuid :: UUID
    sender :: String
    message :: string
end


const clients = []


function verifyusername(name)
    if name == ""
        return false
    end
    for client in clients
        if client.username == name
            return false
        end
    end
    return true
end

function addclient(ws, username)
    uuid = uuid4()
    push!(clients, Client(uuid, ws, username))
    return uuid
end

function removeclient(uuid)
    deleteat!(clients, findall(x->x.uuid==uuid, clients))
end 

function getusernamefromclient(ws)
    writeguarded(ws, "You have successfully connected to ProtoNet")
    while true
        writeguarded(ws, "Enter a username:")
        data, = readguarded(ws)
        s = String(data)
        if !verifyusername(s)
            writeguarded(ws, "That username is taken. Please choose a different username.")
        else
            return s
        end
    end
end

function coroutine(req, ws)
    @info "New Incoming Connection"
    username = getusernamefromclient(ws)
    uuid = addclient(ws, username)
    @info "New client connected: $username"

    while isopen(ws)
        data, = readguarded(ws)
        s = String(data)
        if s == "/exit"
            writeguarded(ws, "Goodbye!")
            break
        end
        @info "$username: $s"
    end
    
    removeclient(uuid)
    @info "Client disconnected: $username"
end

const server = WebSockets.ServerWS((req) -> WebSockets.Response(200), coroutine)

@info "In browser > $LOCALIP:8080 , F12> console > ws = new WebSocket(\"ws:/$LOCALIP:8080\") "
@async WebSockets.with_logger(WebSocketLogger()) do
    WebSockets.serve(server, LOCALIP, 8080)
end

