local function e_or_z(en, zh)
	return (locale == "zh" or locale == "zhr" or locale == "zht") and zh or en
end

name = e_or_z("No Perish", "禁止腐烂")
author = 'OpenSource'
version = '1.0.1'
description = e_or_z(
    [[
New item:
    Rotbox: Turns foods into spoiled_food. Makes other items into ashes or charcoal.
Configuration modification:
    The drying Rack permanently preserves food.
    The speed of food decay can be adjusted or even returned fresh.
    ]],
    [[
新物品：
    腐烂机：快速腐烂食物，把其他物品变成灰烬或者木炭。
配置修改：
    晒肉架永久保存食物。
    可以调整食物的腐烂速度甚至于返鲜。
    ]]
)
forumthread = ""
	
api_version = 10

icon_atlas = "images/modicon.xml"
icon = "modicon.tex"

dst_compatible = true
client_only_mod = false
all_clients_require_mod = true

priority = 0.1

local function AddConfig(label, name, hover, options, default)
	return {
		label = label,
		name = name,
		hover = hover or '',
		options = options or {
			{description = e_or_z("On", "开启"), data = true},
			{description = e_or_z("Off", "关闭"), data = false},
		},
		default = default
	}
end

configuration_options = 
{
    AddConfig(e_or_z('Rotbox can be built', '腐烂机可建造'), 'enable_rotbox', e_or_z("Default Enable", "默认开启"), nil, true),
    AddConfig(e_or_z('Meatrack permanently preserves food', '晒肉架永久保存食物'), 'enable_drying_rack', e_or_z("Default Enable", "默认开启"), nil, true),
    AddConfig(e_or_z('Perishable speed', '食物腐烂速度'), 'perishable_speed', e_or_z("Adjust the speed of food decay", "调整食物腐烂速度"), {
        {description = e_or_z('Return Fresh', '返鲜'), data = -1},
        {description = "10%", data = 0.1},
        {description = "20%", data = 0.2},
        {description = "50%", data = 0.5},
        {description = e_or_z('Default', '默认'), data = 1},
        {description = "200%", data = 2},
        {description = "1000%", data = 10},
    }, -1),
}
