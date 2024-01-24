local perishable_speed = GetModConfigData('perishable_speed') or -1

TUNING.PERISH_GLOBAL_MULT = TUNING.PERISH_GLOBAL_MULT * perishable_speed
