# AB-VIPSYSTEM

The VIP System provides functions to verify and retrieve information about users' VIP levels. It allows you to determine if a user has a specific VIP level or higher and also access details about their current VIP level.

Additionally, the system includes a menu **/vipmenu** that enables administrators to check players' VIP statuses, grant VIP levels, and remove them.

## Installation

Follow these steps to install the VIP System on your server:

1. **Database**: Execute the `vip.sql` file on your database to create the necessary table for storing VIP information.

2. **Add Resource**: Add the `ab-vipsystem` resource to your server's resource folder.

3. **Configuration**: Make sure `ox_lib`, `oxmysql`, and `qb-core` are installed and active on your server.

4. **server.cfg**: Add `ensure ab-vipsystem` to your `server.cfg` file after the `ox_lib`, `oxmysql`, and `qb-core` resources.

5. **Restart**: Restart the server to apply the changes and activate the VIP System.

## Function HasVip

- SERVER SIDE: `exports['ab-vipsystem']:HasVip(id, rank)`

- CLIENT SIDE: `QBCore.Functions.TriggerCallback('ab-vipsystem:cb:HasVip', function(result) print(result) end, rank)`

### Parameters

- `id` (number): The ID of the user whose VIP level will be checked.
- `rank` (string): The name of the required VIP rank.

### Return

- `hasvip` (boolean): Returns `true` if the user has the required VIP rank or a higher one, and `false` otherwise.
- (table) Returns a `vip` table with information about the user's VIP level when the function is called from the **SERVER SIDE**.
    - `vip.name` (string): The name of the user's current VIP rank.
    - `vip.label` (string): The label of the user's current VIP rank.
    - `vip.expire` (string): The raw expiration date of the VIP.
    - `vip.date` (string): The formatted expiration date of the VIP in 'Year-Month-Day' format.

### Notes

- The function uses a hierarchy of ranks to check if a user has the required VIP rank or a higher one.

- If the required VIP rank is not found in the configuration table, the function will print an error message.

### Usage Example

```lua
local playerId = source
local vipRankRequired = 'gold'
local hasVip = exports['ab-vipsystem']:HasVip(playerId, vipRankRequired)
if hasVip then
    print("The user has the required VIP rank or a higher one.")
else
    print("The user does not have the required VIP rank.")
end
```



## Function GetVip

- SERVER SIDE: `exports['ab-vipsystem']:GetVip(id)`

- CLIENT SIDE: `QBCore.Functions.TriggerCallback('ab-vipsystem:cb:GetVip', function(result) print(result) end)`

### Parameters

- `id` (number): The ID of the user whose VIP level will be retrieved.

### Return

- (boolean or table) Returns `false` if the player is not found or if the user does not have VIP. Otherwise, it returns a `vip` table with information about the user's VIP level.
    - `vip.name` (string): The name of the user's current VIP rank.
    - `vip.label` (string): The label of the user's current VIP rank.
    - `vip.expire` (string): The raw expiration date of the VIP.
    - `vip.date` (string): The formatted expiration date of the VIP in 'Year-Month-Day' format.

### Usage Example

```lua
local playerId = source
local vipInfo = exports['ab-vipsystem']:GetVip(playerId)
if vipInfo then
    print(json.encode(vipInfo, { indent = true }))
else
    print("No VIP information found for the user.")
end
```

# DEPENDENCIES
- [ox_lib](https://github.com/overextended/ox_lib)
- [QBCore](https://github.com/qbcore-framework/qb-core)
- [oxmysql](https://github.com/overextended/oxmysql)