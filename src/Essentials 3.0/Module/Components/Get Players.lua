local Players = game:GetService('Players')
local Teams = game:GetService('Teams')

local filteredArgs = {
	['all'] = {'ban','pban','kick','crash'},
	['others'] = {'ban','pban','kick','crash'},
	['nonadmins'] = {'ban','pban','kick','crash'},
	['admins'] = {'ban','pban','kick','crash'},
}

local function Filter(Arg,commandConfirmation,Command)
	if not commandConfirmation then
		return false
	end
	for a,b in next,filteredArgs do
		for c,d in next,b do
			if (tostring(Command):lower() == tostring(d):lower()) and (tostring(Arg):lower() == tostring(a):lower()) then
				return true
			end
		end
	end
	return false
end

local function getPlayers(Player, Arguments, getPermissions,commandConfirmation,Command)
	local toReturn = {}
	local toConfirm = {}
    if Player and getPermissions then
        if Arguments then
            for Segment in Arguments:gmatch('([^,]+)') do
                local lowerSegment = Segment:lower()
                if Filter(lowerSegment,commandConfirmation,Command) then
                    table.insert(toConfirm,{lowerSegment,commandConfirmation,Command})
                end
                if lowerSegment == 'me' then
                    table.insert(toReturn,Player)
                elseif lowerSegment == 'all' then
                    for a,b in next,Players:GetPlayers() do
                        table.insert(toReturn,b)
                    end
                elseif lowerSegment == 'others' then
                    for a,b in next,Players:GetPlayers() do
                        if b ~= Player then
                            table.insert(toReturn,b)
                        end
                    end
                elseif lowerSegment == 'random' then
                    local ranPlayer = Players:GetPlayers()[math.random(1,#Players:GetPlayers())]
                    if ranPlayer == Player then
                        repeat
                            ranPlayer = Players:GetPlayers()[math.random(1,#Players:GetPlayers())]
                            if #Players:GetPlayers() == 1 and ranPlayer == Player then
                                break
                            end
                            task.wait()
                        until ranPlayer ~= Player
                    end
                    table.insert(toReturn,ranPlayer)
                elseif lowerSegment == 'admins' then
                    for a,b in next,Players:GetPlayers() do
                        if getPermissions(b) > 0 then
                            table.insert(toReturn,b)
                        end
                    end
                elseif lowerSegment == 'nonadmins' then
                    for a,b in next,Players:GetPlayers() do
                        if getPermissions(b) == 0 then
                            table.insert(toReturn,b)
                        end
                    end
                elseif string.sub(lowerSegment,1,1) == '%' then
                    for a,b in next,Teams:GetChildren() do
                        if string.sub(b.Name:lower(),1,#Segment-1) == string.sub(Segment:lower(),2) then
                            for c,d in next,Players:GetPlayers() do
                                if d.TeamColor == b.TeamColor then
                                    table.insert(toReturn,d)
                                end
                            end
                        end
                    end
                else
                    for a,b in next,Players:GetPlayers() do
                        if string.sub(b.Name:lower(),1,#Segment) == lowerSegment then
                            table.insert(toReturn,b)
                        end
                    end
                end
            end
        else
            table.insert(toReturn,Player)
        end
	end
	if toReturn == {} and #toReturn == 0 then
		return false
	elseif toReturn ~= {} and #toReturn > 0 then
		if #toConfirm > 0 and toConfirm ~= {} then
			return "Confirm",toConfirm
		else
			return toReturn
		end
	end
end

return getPlayers