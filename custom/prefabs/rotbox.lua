PrefabFiles = {
    "rotbox",
}

Assets = {
	Asset("ATLAS", "images/inventoryimages/rotbox.xml"),
	Asset("IMAGE", "images/inventoryimages/rotbox.tex"),
	Asset("ANIM", "anim/rotbox.zip"),
}

if locale == "zh" or locale == "zhr" or locale == "zht" then
    STRINGS.NAMES.ROTBOX = "腐烂机"
    STRINGS.RECIPE_DESC.ROTBOX = "使食物快速腐烂"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.ROTBOX = "啊，神奇的机器！"
else
    STRINGS.NAMES.ROTBOX = "Rotbox"
    STRINGS.RECIPE_DESC.ROTBOX = "Turns foods into spoiled_food."
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.ROTBOX = "Oh, it's so amazing!"
end

AddRecipe2(
    "rotbox",
    {Ingredient("goldnugget", 2), Ingredient("cutstone", 1), Ingredient("wetgoop",1)},
    TECH.SCIENCE_TWO,
    {placer = "rotbox_placer", min_spacing = 1.5, atlas = "images/inventoryimages/rotbox.xml"},
    {"STRUCTURES", "CONTAINERS", "COOKING"}
)

AddMinimapAtlas("images/inventoryimages/rotbox.xml")
