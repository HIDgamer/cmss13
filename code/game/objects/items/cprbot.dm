/obj/item/cprbot_item
    name = "CPRbot"
    desc = "A compact CPRbot 9000 asemply"
    icon = 'icons/obj/structures/machinery/aibots.dmi'
    icon_state = "cprbot"
    w_class = SIZE_MEDIUM
    var/deployment_path = /obj/structure/machinery/bot/cprbot

/obj/item/cprbot_item/proc/deploy_cprbot(mob/user, atom/location)
    if(!user || !location)
        return
    // Attempt to delete the item first
    qdel(src)
    world << "Deleting item [src]. Deploying CPRbot at [location]."

    // Proceed with the CPRbot deployment
    var/obj/structure/machinery/bot/cprbot/R = new deployment_path(location)
    if(R)
        R.add_fingerprint(user)
        world << "CPRbot deployed successfully at [location]."
    else
        world << "Failed to deploy CPRbot at [location]."

/obj/item/cprbot_item/attack_self(mob/user)
    if (..())
        return TRUE
    if(user)
        deploy_cprbot(user, user.loc)

/obj/item/cprbot_item/afterattack(atom/target, mob/user, proximity)
    if(proximity && isturf(target))
        var/turf/T = target
        if(!T.density)
            deploy_cprbot(user, T)

/obj/item/cprbot_broken
    name = "CPRbot"
    desc = "A compact CPRbot 9000 asemply it appears to be in bad shape"
    icon = 'icons/obj/structures/machinery/aibots.dmi'
    icon_state = "cprbot_broken"
    w_class = SIZE_MEDIUM

/obj/item/cprbot_broken/attackby(obj/item/W, mob/living/user)
    if(iswelder(W))
        if(!HAS_TRAIT(W, TRAIT_TOOL_BLOWTORCH))
            to_chat(user, SPAN_WARNING("You need a stronger blowtorch!"))
            return

        var/obj/item/tool/weldingtool/WT = W
        if(!WT.isOn())
            to_chat(user, SPAN_WARNING("\The [WT] needs to be on!"))
            return

        if(!WT.remove_fuel(5, user))  // Ensure the welder has enough fuel to operate
            to_chat(user, SPAN_NOTICE("You need more welding fuel to complete this task."))
            return

        playsound(src, 'sound/items/Welder.ogg', 25, 1)

        if(!do_after(user, 10 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL | BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
            return

        var/obj/item/cprbot_item/I = new /obj/item/cprbot_item(src.loc)

        if(user)
            if(!user.put_in_active_hand(I))
                if(!user.put_in_inactive_hand(I))
                    I.forceMove(src.loc)
        else
            I.forceMove(src.loc)

/obj/item/cprbot_broken/attackby(obj/item/W, mob/living/user)
    if(iswelder(W))
        if(!HAS_TRAIT(W, TRAIT_TOOL_BLOWTORCH))
            to_chat(user, SPAN_WARNING("You need a stronger blowtorch!"))
            return

        var/obj/item/tool/weldingtool/WT = W
        if(!WT.isOn())
            to_chat(user, SPAN_WARNING("\The [WT] needs to be on!"))
            return

        if(!WT.remove_fuel(5, user))  // Ensure enough fuel is available
            to_chat(user, SPAN_NOTICE("You need more welding fuel to complete this task."))
            return

        playsound(src, 'sound/items/Welder.ogg', 25, 1)

        if(!do_after(user, 10 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL | BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
            return

        // Create the repaired item
        var/obj/item/cprbot_item/I = new /obj/item/cprbot_item(src.loc)

        // Check if the broken item is in the user's hand
        var/hand_was_active = user.get_active_hand() == src
        var/hand_was_inactive = user.get_inactive_hand() == src

        // Remove the broken item
        qdel(src)

        // Attempt to place the new item into the user's hands
        if (hand_was_active)
            if (!user.put_in_active_hand(I))
                I.forceMove(user.loc)  // Place it at user's location if hands are full
        else if (hand_was_inactive)
            if (!user.put_in_inactive_hand(I))
                I.forceMove(user.loc)  // Place it at user's location if hands are full
        else
            I.forceMove(user.loc)  // Place at the original location if not in hand


