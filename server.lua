local QBCore = exports['qb-core']:GetCoreObject()

function GetLicense(id)
	local license = ''
	local identifier = GetPlayerIdentifiers(id)
	for i = 1, #identifier do
		if string.find(identifier[i], "license:") then
			license = identifier[i]
			break
		end
	end
	return license
end

function GetRankLabel(name)
	local label = ""
	for _, v in pairs(Config.Ranks) do
		if v.name == name then
			label = v.label
			break
		end
	end
	return label
end

function CheckVip(license)
	local response = MySQL.prepare.await('SELECT `rank`, `expire` FROM `vips` WHERE `license` = ?', {
		license
	})
	if not response then return false end
	local vip = {
		name = response.rank,
		label = GetRankLabel(response.rank),
		expire = response.expire,
		date = os.date('%Y-%m-%d', response.expire)
	}
	return vip
end

function AddVip(target, rank, expire)
	local license = GetLicense(target)
	if not license then return false end
	MySQL.insert.await('INSERT INTO `vips` (license, rank, expire) VALUES (?, ?, ?)', {
		license, rank, expire
	})
	return true
end

function RemoveVip(license)
	local vip = CheckVip(license) or false
	if vip then
		MySQL.query('DELETE FROM vips WHERE license = @license', {['@license'] = license})
		return true
	else
		return false
	end
end

QBCore.Commands.Add(Lang.Command.name, Lang.Command.help, {}, false, function(source, args)
	TriggerClientEvent('ab-vipsystem:cl:OpenVipMenu', source)
end, 'god')

RegisterNetEvent('ab-vipsystem:sv:GiveVip', function(data)
	local L = Lang.Give.Notify
	local src = source
	if not data.id then return end
	if not data.rank then return end
	local player = QBCore.Functions.GetPlayer(data.id)
	if not player then TriggerClientEvent('QBCore:Notify', src, L.error.playernotfound, Config.NotifyType.error) return end
	local validRank = false
	for _, v in pairs(Config.Ranks) do
		if v.name == data.rank then
			validRank = true
			break
		end
	end
	if not validRank then TriggerClientEvent('QBCore:Notify', src, L.error.invalidRank, Config.NotifyType.error) return end
	local RankLabel = GetRankLabel(data.rank)
	local license = GetLicense(data.id)
	local vip = CheckVip(license)
	if vip then
		RemoveVip(license)
	end
	Wait(1000)
	if data.permanent == true then
		if AddVip(data.id, data.rank, 32535140400) then
			TriggerClientEvent('QBCore:Notify', src, string.gsub(L.success.gived_src, '{rank}', RankLabel), Config.NotifyType.success)
			TriggerClientEvent('QBCore:Notify', data.id, string.gsub(L.success.gived_target, '{rank}', RankLabel), Config.NotifyType.success)
		else
			TriggerClientEvent('QBCore:Notify', src, L.error.cantgive, Config.NotifyType.error)
		end
	else
		if not data.expire then TriggerClientEvent('QBCore:Notify', src, L.error.noexpiredate, Config.NotifyType.error) return end
		if AddVip(data.id, data.rank, math.floor(data.expire / 1000)) then
			TriggerClientEvent('QBCore:Notify', src, string.gsub(L.success.gived_src, '{rank}', RankLabel), Config.NotifyType.success)
			TriggerClientEvent('QBCore:Notify', data.id, string.gsub(L.success.gived_target, '{rank}', RankLabel), Config.NotifyType.success)
		else
			TriggerClientEvent('QBCore:Notify', src, L.error.cantgive, Config.NotifyType.error)
		end
	end
end)

RegisterNetEvent('ab-vipsystem:sv:RemoveVip', function(id)
	local L = Lang.Remove
	local src = source
	local player = QBCore.Functions.GetPlayer(id)
	if not player then TriggerClientEvent('QBCore:Notify', src, L.Notify.error.playernotfound, Config.NotifyType.error) return end
	local license = GetLicense(id)
	if RemoveVip(license) then
		TriggerClientEvent('QBCore:Notify', src, L.Notify.success.removed_src, Config.NotifyType.success)
		TriggerClientEvent('QBCore:Notify', id, L.Notify.success.removed_target, Config.NotifyType.success)
	else
		TriggerClientEvent('QBCore:Notify', src, L.Notify.error.novip, Config.NotifyType.error)
	end
end)

QBCore.Functions.CreateCallback('ab-vipsystem:cb:CheckVip', function(source, cb, id)
	local src = source
	local player = QBCore.Functions.GetPlayer(id)
	if not player then TriggerClientEvent('QBCore:Notify', src, Lang.Check.Notify.error.playernotfound, Config.NotifyType.error) return end
	local license = GetLicense(id)
	local vip = CheckVip(license) or false
	cb(vip)
end)

QBCore.Functions.CreateCallback('ab-vipsystem:cb:ConvertTime', function(source, cb, time)
	cb(os.date('%Y-%m-%d', math.floor(time / 1000)))
end)

--[[
function CheckPerms(id, rank)
	if QBCore.Functions.HasPermission(id, rank) then
		return true
	else
		return false
	end
end

QBCore.Functions.CreateCallback('ab-vipsystem:cb:CheckPerms', function(source, cb, args)
	if CheckPerms(source, args) then
		cb(true)
	else
		cb(false)
	end
end)

--]]

Citizen.CreateThread(function()
	while Config.CheckVips do
		Wait(Config.CheckVipsInterval)
		local players = QBCore.Functions.GetPlayers()
		for i=1, #players do
			local license = GetLicense(players[i])
			local vip = CheckVip(license)
			if vip then
				if vip.date == os.date('%Y-%m-%d') then
					if RemoveVip(license) then
						TriggerClientEvent('QBCore:Notify', players[i], Lang.Remove.Notify.success.removed_target, Config.NotifyType.success)
					end
				end
			end
		end	
		Wait(1)
	end
end)


function HasVip(id, required, onlyrequired)
	local validrank = false
	for i, v in pairs(Config.Ranks) do
		if v.name == required then
			validrank = true
			break
		end
	end
	if not validrank then error("Rank doesn't exist") end
	local license = GetLicense(id)
	local vip = CheckVip(license)
	if not vip then return false end
	if vip.name == required then
		return true, vip
	else
		local requiredIndex = 0
		local vipIndex
		for i, v in pairs(Config.Ranks) do
			if v.name == required then
				requiredIndex = i
				break
			end
		end
		for i, v in pairs(Config.Ranks) do
			if vip.name == v.name then
				vipIndex = i
				break
			end
		end
		if vipIndex >= requiredIndex then
			return true, vip
		else
			return false, vip
		end
	end	
end exports('HasVip', HasVip)

QBCore.Functions.CreateCallback('ab-vipsystem:cb:HasVip', function(source, cb, required)
	cb(exports['ab-vipsystem']:HasVip(source, required))
end)

function GetVip(id)
	local player = QBCore.Functions.GetPlayer(id)
	if not player then return false end
	local license = GetLicense(id)
	local vip = CheckVip(license)
	if not vip then return false end
	return vip
end exports('GetVip', GetVip)

QBCore.Functions.CreateCallback('ab-vipsystem:cb:GetVip', function(source, cb)
	cb(exports['ab-vipsystem']:GetVip(source))
end)