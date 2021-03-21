import Base.*


struct Transaction
    fromWallet
    toWallet
    amount
end

Base.string(t::Transaction) = string(t.fromWallet) * string(t.toWallet) * string(t.amount) 
*(s::String, t::Transaction) = s * string(t)
