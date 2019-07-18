events = {};

SLASH_PETEVENTEXPORT1 = '/peve';

PET_BATTLE_EVENT_NAME = 'Pet Battle Bonus Event';

local function isLeapYear(year)
	if ((year % 4 == 0) and (year % 100 ~= 0)) or (year % 400 == 0) then
		return true;
	end
	return false;
end

local function getDaysInMonth(month, year)
	DAYS_IN_MONTH = { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 };
	if month == 2 and isLeapYear(year) then
		return 29;
	end
	return DAYS_IN_MONTH[month];
end

-- must be less than one month
local function addToDate(day, month, year, delta)
	day = day + delta;
	if day > getDaysInMonth(month, year) then
		day = day - getDaysInMonth(month, year);
		month = month +  1;
		if (month > 12) then
			month = 1
			year = year + 1
		end
	end
	return day, month, year;
end

--is dateA before dateB
local function isBeforeDate(dateA, dateB)
	if(dateA.year > dateB.year)then
		return false;
	end
	if(dateA.year < dateB.year)then
		return true;
	end
	if(dateA.month > dateB.month)then
		return false;
	end
	if(dateA.month < dateB.month)then
		return true;
	end
	if(dateA.monthDay < dateB.monthDay)then
		return true;
	end
	return false;

end

local function setEvents()
	events = {};
	local today = date("*t");
	local day, month, year = today.day, today.month, today.year
	local count = 0;
	repeat
		C_Calendar.SetAbsMonth(month, year);
		local numEvents = C_Calendar.GetNumDayEvents(0, day);
		local datePoint = {monthDay = day, month = month, year = year};
		for i=1,numEvents do
			local event = C_Calendar.GetDayEvent(0, day, i);
			if (event.title == PET_BATTLE_EVENT_NAME) then
				tinsert(events, event.startTime);
			end
		end
		day, month , year = addToDate(day, month, year, 7);
	until (isBeforeDate(C_Calendar.GetMaxCreateDate(), datePoint))
end

local function slashHandler(msg, editBox)
	setEvents()
end

SlashCmdList["PETEVENTEXPORT"] = slashHandler;