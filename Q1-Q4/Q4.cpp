//Q4 - Assume all method calls work fine. Fix the memory leak issue in below method

void Game::addItemToPlayer(const std::string& recipient, uint16_t itemId)
{
    Player* player = g_game.getPlayerByName(recipient);
    bool createdPlayer = false; // Flag to track if we created a new player object

    if (!player) { //Maybe we don't want to create a new player if is a nullptr when we search a player with recipient name. This is a design decision based on the requirements or assumptions of the system. 
        player = new Player(nullptr);
        if (!IOLoginData::loadPlayerByName(player, recipient)) {
            delete player; // If loading fails, delete the player object to avoid memory leak
            return;
        }
        createdPlayer = true;
    }

    Item* item = Item::CreateItem(itemId);
    if (!item) {
        if(createdPlayer){
            delete player; // If we created the player but failed to load the item, delete it
        }
        return;
    }

    g_game.internalAddItem(player->getInbox(), item, INDEX_WHEREVER, FLAG_NOLIMIT);

    if (player->isOffline()) {
        IOLoginData::savePlayer(player);
    }

    if (createdPlayer){ 
        delete player; // If we created the player object, delete it when no longer needed
    }
}