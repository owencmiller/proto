#=
#   Proto Node REPL
#
#   by owen miller
#
=#

function get_input(prompt)
    printstyled(stdout, color=:green, bold=true,prompt*"> ")
    input = readline(stdin)
    return input
end


function start_message()
    println("Welcome to the Proto network\n")
    println("by owen miller")
    println("Type 'help' for a list of commands")
end


function command_help(names, desc)
    println("List of available commands:")
    if length(names) != length(desc)
        @warn Internal command description error
        return
    end
    for i in 1:length(names)
        println("  - ", names[i], ": ", desc[i])
    end
end

function isIP(input_ip)
    inputs = split(input_ip, ':')
    
    if length(inputs) != 2
        return false
    end
    
    ip_nums = tryparse.(Int, split(inputs[1], '.'))
    port = tryparse(Int, inputs[2])

    if length(ip_nums) != 4 || port == nothing
        return false
    end


    for n in ip_nums
        if n == nothing || 0 > n || 255 < n
            return false
        end
    end

    return true
end

function connect()
    while true
        println("Enter the IP of a connection node in the network: [ipv4]:[port]")
        input = get_input("connect")
        if isIP(input)
            println("You entered a valid IP address- returning to main prompt")
            break
        else
            println("You entered an invalid IP address.")
        end
    end
end

function repl()
    commands = Dict("help" => ((() -> command_help(collect(keys(commands)), [x[2] for x in collect(values(commands))])),
                              "List available commands"), 
                    "exit" => ("exit",
                              "Terminate this proto node"), 
                    "connect" => (connect,
                              "Connect to the proto network")
                   )
    while true
        input = get_input("")
        command = get(commands, input, "no command found")
        if command[1] != "no command"
            if command[1] == "exit"
                break
            else
                command[1]()
            end
        else
            println("Unknown command: ", input, "\n")
            println("Type 'help' for a list of commands")
        end
    end
end

function main()
    start_message()
    repl()
end


main()
