PrefabFiles = {
    "rotbox",
}

Assets = {
	Asset("ATLAS", "images/inventoryimages/rotbox.xml"),
	Asset("IMAGE", "images/inventoryimages/rotbox.tex"),
	Asset("ANIM", "anim/rotbox.zip"),
}

local steam_support_languages = {
    LANG_ID_0 = "en",
    LANG_ID_22 = "chs",
    LANG_ID_21 = "cht",
}

local function SetLanguage()
    local steamlang = 'LANG_ID_' .. _G.Profile:GetLanguageID()
    local uselang = steam_support_languages[steamlang] or "en"

    if uselang == "chs" or uselang == "cht" then
        STRINGS.NAMES.ROTBOX = "腐烂机"
        STRINGS.RECIPE_DESC.ROTBOX = "快速腐烂食物，把其他物品变成灰烬或者木炭。"
        STRINGS.CHARACTERS.GENERIC.DESCRIBE.ROTBOX = "啊，神奇的机器！"
        STRINGS.UI.ROTBOX_BUTTON = "清空"
    else
        STRINGS.NAMES.ROTBOX = "Rotbox"
        STRINGS.RECIPE_DESC.ROTBOX = "Turns foods into spoiled_food. Makes other items into ashes or charcoal."
        STRINGS.CHARACTERS.GENERIC.DESCRIBE.ROTBOX = "Oh, it's so amazing!"
        STRINGS.UI.ROTBOX_BUTTON = "Empty"
    end
end

SetLanguage()

AddRecipe2(
    "rotbox",
    {Ingredient("goldnugget", 2), Ingredient("cutstone", 1), Ingredient("wetgoop",1)},
    TECH.SCIENCE_TWO,
    {placer = "rotbox_placer", min_spacing = 1.5, atlas = "images/inventoryimages/rotbox.xml"},
    {"STRUCTURES", "CONTAINERS", "COOKING"}
)

AddMinimapAtlas("images/inventoryimages/rotbox.xml")

-- Setup Container.
local params = {}
params.rotbox =
{
    widget =
    {
        slotpos = {},
        animbank = "ui_chester_shadow_3x4",
        animbuild = "ui_chester_shadow_3x4",
        pos = Vector3(0, 220, 0),
        side_align_tip = 160,
        buttoninfo = {
            text = STRINGS.UI.ROTBOX_BUTTON,  -- Use the localized string
            position = Vector3(0, -170, 0),
        }
    },
    type = "chest",
}

for y = 2.5, -0.5, -1 do
    for x = 0, 2 do
        table.insert(params.rotbox.widget.slotpos, Vector3(75 * x - 75 * 2 + 75, 75 * y - 75 * 2 + 75, 0))
    end
end

function params.rotbox.widget.buttoninfo.fn(inst)
    if inst.components.container then
        for i = 1, inst.components.container:GetNumSlots() do
            local item = inst.components.container:RemoveItemBySlot(i)
            if item then
                item:Remove()
            end
        end
    end
end

function params.rotbox.widget.buttoninfo.validfn(inst)
	return inst.replica.container ~= nil
end

local containers = require("containers")

containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS, params.rotbox.widget.slotpos ~= nil and #params.rotbox.widget.slotpos or 0)

local containers_widgetsetup = containers.widgetsetup

function containers.widgetsetup(container, prefab, data)
    local t = prefab or container.inst.prefab
    if t == "rotbox" then
        local t = params[t]
        if t ~= nil then
            for k, v in pairs(t) do
                container[k] = v
            end
            container:SetNumSlots(container.widget.slotpos ~= nil and #container.widget.slotpos or 0)
        end
    else
        return containers_widgetsetup(container, prefab)
    end
end
