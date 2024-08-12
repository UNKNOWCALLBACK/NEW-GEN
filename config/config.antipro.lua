Config = {} or nil

Config.cheatdetech = function(_source,xPlayer,token)
    if token == nil then
        DropPlayer(_source,"Pro")
             print( "[" GetCurrentResourceName() .. "] : DETECH PLAYER ID : ( " .._source..") IS TRY TO TRIGGERSERVEREVENT WITH OUT TOKEN" )
    else
        DropPlayer(_source,"Pro")
            print( "[" GetCurrentResourceName() .. "] : DETECH PLAYER ID : ( " .._source..") IS TRY TO TRIGGERSERVEREVENT WITH TOKEN : " ..token  )
    end
end