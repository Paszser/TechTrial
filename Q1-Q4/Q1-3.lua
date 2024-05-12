--Q1-Q4 - Fix or improve the implementation of the below methods.

--
--Q1 - Fix or improve the implementation of the below methods
--

local function releaseStorage(player)
    --Here we can check that player exists and amke any further comprobations needed. This prevents errors if player is nil or not a player object.
    if player and player:isPlayer() then  

        --Here we use a more consistent parameter to get the identifier of the player's storage. This way we don't use a written value
        player:setStorageValue(player:storageKey, -1)

        --If isn't needed this Key we can access to the player's setter directly and setting this value to its storage to set it to "empty". This depends on the setter implementation
        --player:setStorageValue(-1)
    end    
end

function onLogout(player)

    --Like the method before we can check that the player still exists. It's good practice to ensure that the player is still valid when the onLogout function is called. 
    --Although it's unlikely, there might be scenarios where the player is invalidated before the releaseStorage event executes.
    if player and player:isPlayer() then

        --Here like in realeaseStorage method we maybe can directly access to the getter
        --We also check if the value is not equal to -1, meaning there's a valid value and if storage value is being set before (not necessarily 1). This can make sense if this value it's the size of storage or something like this
        --This means that we can release the storage if it hasn't being released before. This might be more robust depending on how the storage value is used elsewhere in your code.
        --if player:getStorageValue() ~= -1 then

        if player:getStorageValue(player:storageKey) ~= -1 then
            addEvent(releaseStorage, 1000, player)
        end
    end
    return true
end


--
--Q2 - Fix or improve the implementation of the below method
--


-- this method is supposed to print names of all guilds that have less max members than memberCount 
function printSmallGuildNames(memberCount)
    -- Use a prepared statement to avoid SQL injection vulnerabilities
    local selectGuildQuery = "SELECT name FROM guilds WHERE max_members < ?;"
    local stmt = db.prepareStatement(selectGuildQuery)

    --This method depends on the library or method implemented in the project
    stmt:bind(1, memberCount)
    
    -- Execute the prepared statement. AS we use a prepared statement que use executeQuery() over storeQuery()
    local resultId = stmt:executeQuery() 
    
    if resultId then

        -- Used a loop to iterate over all the results and print each guild name.
        while resultId:next() do
            local guildName = resultId:getString("name")
            print(guildName)
        end
        
        --  Release and close the resources associated with the result set to free up memory and avoid resource leaks.
        resultId:close() 

    else
        -- Added error handling to check if the query returned results.
        print("Error executing SQL query.")
    end
end



--
--Q3 - Fix or improve the name and the implementation of the below method
--

-- Renamed the function to removeFromPlayerParty, which clearly indicates its purpose.
function removeFromPlayerParty(playerId, memberName)

    --Use of local keyword to avoid global variable usage
    local player = Player(playerId)
    local party = player:getParty()

    --Stored party members in a variable (members) for better readability and efficiency.
    local members = party:getMembers()
    
    -- Iterate over party members sequentially and use of a placeholder for unused variables
    for _, member in ipairs(members) do

        -- Get the name of the member for comparison.
        --We ensure that we're comparing the actual names (strings) of the players and not comparing if v and the newly created Player(membername) reference the same object in memory.
        if member:getName() == memberName then
            party:removeMember(member)
            return party -- Indicate successful removal returning the modified party object
        end
    end

    return nil -- Indicate member not found
end
