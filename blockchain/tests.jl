include("transaction.jl")
include("block.jl")
include("blockchain.jl")


ctz = create_blockchain()
create_trans(ctz, Transaction("Owen","Connor",3.2))
create_trans(ctz, Transaction("Owen","Harmon",1))
create_trans(ctz, Transaction("Connor","Harmon",5.12))

print("Will started mining\n")
mine_pending_trans(ctz, "Will")

create_trans(ctz, Transaction("Matt","Connor",.01))
create_trans(ctz, Transaction("Harmon","Owen",100))
create_trans(ctz, Transaction("Harmon","Matt",.000001))


print("Will started mining\n")
mine_pending_trans(ctz, "Will")

print("Will has " * string(get_balance(ctz, "Will")) * " in his Collatz wallet\n")
print(is_chain_valid(ctz))

