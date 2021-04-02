using WebSockets
function client_one_message(ws)
    @async reading(ws)
    while isopen(ws)
        #printstyled(stdout, "\nws|client input >  ", color=:green)
        msg = readline(stdin)
        writeguarded(ws, msg)
    end
end

function reading(ws)
    while isopen(ws)
        msg, stillopen = readguarded(ws)
        println("Recieved:", String(msg))
    end
end



function main()
    while true
        println("\nSuggestion: Run 'minimal_server.jl' in another REPL")
        println("\nWebSocket client side. WebSocket URI format:")
        println("ws:// host [ \":\" port ] path [ \"?\" query ]")
        println("Example:\nws://127.0.0.1:8080")
        println("Where do you want to connect? Empty line to exit")
        printstyled(stdout, color = :green,  "\nclient_repl_input >  ")
        wsuri = readline(stdin)
        wsuri == "" && break
        res = WebSockets.open(client_one_message, wsuri)
    end
    println("Have a nice day")
end

main()
