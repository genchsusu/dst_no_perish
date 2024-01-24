GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end}) 

if GetModConfigData('enable_drying_rack') then
    modimport("custom/components/dryer")
end 

modimport("custom/components/perishable")

if GetModConfigData('enable_rotbox') then
    modimport("custom/prefabs/rotbox")
end 