include("transaction.jl")
using Dates, SHA


mutable struct Block
    timeStamp :: Int64
    data :: Array{Transaction}
    difficultyInc :: Int64
    prevHash :: String
    hash :: String
end

datetime2epoch(x::DateTime) = (Dates.value(x) - Dates.UNIXEPOCH)*1_000_000

function calc_hash(prevHash::String, data::Array{Transaction}, time::Int64, difficultyInc::Int64 )
    
    dataString = foldl(((x,y) -> string(x)*string(y)), data)
    return bytes2hex(sha256(prevHash * dataString * string(time) * string(difficultyInc)))
end

function create_block(data, prevHash="")
    currentTime = datetime2epoch(now())
    hash = calc_hash(prevHash, data, currentTime, 0)
    return Block(currentTime, data, 0, prevHash, hash)
end




