include("block.jl")
include("transaction.jl")

mutable struct Blockchain
    chain :: Array{Block}
    difficulty :: Int8
    pendingTransactions :: Array{Transaction}
    reward :: Int32
end


function create_genesis() :: Block
    genesisBlock = create_block([Transaction("", "Owen", 5000)])
    return genesisBlock
end


function get_lastblock(chain::Blockchain) :: Block
    return chain.chain[end]
end


function create_blockchain() :: Blockchain
    chain = Blockchain([create_genesis()], 5, [], 10)
    return chain
end


function is_chain_valid(chain::Blockchain) :: Bool
    for i in 2:length(chain.chain)
        current = chain.chain[i]
        prev = chain.chain[i-1]
        
        if current.prevHash != prev.hash
            return false
        end
    end
    return true
end


function mine_block(chain, block)
    diffCheck = repeat("9", chain.difficulty)
    while block.hash[1:chain.difficulty] != diffCheck
        block.hash = calc_hash(get_lastblock(chain).hash, block.data, block.timeStamp, block.difficultyInc)
        block.difficultyInc += 1
    end
end


function mine_pending_trans(chain, minerRewardAddress)
    newBlock = create_block(chain.pendingTransactions)
    mine_block(chain, newBlock)
    newBlock.prevHash = get_lastblock(chain).hash

    print("Block Created\n")
    push!(chain.chain, newBlock)
    print("Block Added\n")
    
    rewardTrans = Transaction("System", minerRewardAddress, chain.reward)
    chain.pendingTransactions = Array{Transaction}[]
    push!(chain.pendingTransactions, rewardTrans)
end


function create_trans(chain, transaction)
    push!(chain.pendingTransactions, transaction)
end


function get_balance(chain, walletAddress)
    balance = 0
    for block in chain.chain
        if block.prevHash == ""
            continue
        end
        for trans in block.data
            if trans.fromWallet == walletAddress
                balance -= trans.amount
            end
            if trans.toWallet == walletAddress
                balance += trans.amount
            end
        end
    end
    return balance
end


