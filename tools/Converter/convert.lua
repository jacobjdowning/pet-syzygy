json = require "json";

-- EXPORT_PATH = "C:\\Program Files (x86)\\World of Warcraft\\_retail_\\WTF\\Account\\BATSABALL\\SavedVariables\\PetEventExport.lua";

pathFile = io.open("path.txt");
EXPORT_PATH = pathFile:read("*all");
pathFile:close();

dofile(EXPORT_PATH);

for i, element in ipairs(events) do
	element["hour"] = nil;
	element["minute"] = nil;
	element["weekday"] = nil;
	element.day=element.monthDay;
	element["monthDay"] = nil;
end

export = io.open("../../events.json", "w");
export:write(json.encode(events));
export:close();