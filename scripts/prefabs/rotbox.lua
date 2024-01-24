require "prefabutil"

local assets =
{
    Asset("ANIM", "anim/rotbox.zip"),
    Asset("ANIM", "anim/ui_chester_shadow_3x4.zip"),
    Asset("IMAGE", "images/inventoryimages/rotbox.tex")
}

local prefabs =
{
    "collapse_small",
}

local function onopen(inst) 
    inst.AnimState:PlayAnimation("open") 
    inst.SoundEmitter:PlaySound("dontstarve/common/icebox_open")
end 

local function onclose(inst) 
    inst.AnimState:PlayAnimation("close") 
    inst.SoundEmitter:PlaySound("dontstarve/common/icebox_close")     
end 

local function onhammered(inst, worker)
    inst.components.lootdropper:DropLoot()
    inst.components.container:DropEverything()
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("metal")
    inst:Remove()
end

local function onhit(inst, worker)
    inst.AnimState:PlayAnimation("hit")
    inst.components.container:DropEverything()
    inst.AnimState:PushAnimation("closed", false)
    inst.components.container:Close()
end

local function onbuilt(inst)
    inst.AnimState:PlayAnimation("place")
    inst.AnimState:PushAnimation("closed", false)
    inst.SoundEmitter:PlaySound("dontstarve/common/icebox_craft")
end

local function TransformItem(inst, slot, transform_prefab)
    local removed_item = inst.components.container:RemoveItemBySlot(slot)
    if removed_item then
        local stack_size = removed_item.components.stackable and removed_item.components.stackable:StackSize() or 1
        
        for i = 1, stack_size do
            local result_item = SpawnPrefab(transform_prefab)
            if not inst.components.container:GiveItem(result_item) then
                result_item.Transform:SetPosition(inst.Transform:GetWorldPosition())
            end
        end

        removed_item:Remove()
    end
end

local function DoPerish(inst)
    for k, v in pairs(inst.components.container.slots) do
        if v.components.perishable then
            v.components.perishable:ReducePercent(0.10)
            if v.components.perishable:GetPercent() < 0.10 then
                TransformItem(inst, k, "spoiled_food")
            end
        else
            local excluded_items = {"spoiled_food", "rottenegg", "charcoal", "ash"}
            if not table.contains(excluded_items, v.prefab) then
                local chance = math.random()
                local result_prefab = chance < 0.5 and "charcoal" or "ash"
                TransformItem(inst, k, result_prefab)
            end
        end
    end
end

local function fn(Sim)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst.MiniMapEntity:SetIcon("rotbox.tex")

    inst:AddTag("structure")

    inst.AnimState:SetBank("rotbox")
    inst.AnimState:SetBuild("rotbox")
    inst.AnimState:PlayAnimation("closed")

    inst.SoundEmitter:PlaySound("dontstarve/common/ice_box_LP", "idlesound")

    MakeSnowCoveredPristine(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("container")
    inst.components.container:WidgetSetup("rotbox")
    inst.components.container.onopenfn = onopen
    inst.components.container.onclosefn = onclose
    inst.components.container.skipclosesnd = true
    inst.components.container.skipopensnd = true


    inst:AddComponent("lootdropper")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(2)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit) 
        
    inst:ListenForEvent("onbuilt", onbuilt)
    MakeSnowCovered(inst)

    --Rot Function
    inst:DoPeriodicTask(1, DoPerish, .5)

    return inst
end

return Prefab( "rotbox", fn, assets, prefabs),
        MakePlacer("rotbox_placer", "rotbox", "rotbox", "closed")