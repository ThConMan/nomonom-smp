package com.mobgrab.listener;

import com.mobgrab.MobGrab;
import com.mobgrab.util.HologramUtil;
import org.bukkit.entity.Villager;
import org.bukkit.event.EventHandler;
import org.bukkit.event.Listener;
import org.bukkit.persistence.PersistentDataType;

public final class TradeListener implements Listener {

    private final MobGrab plugin;

    public TradeListener(MobGrab plugin) {
        this.plugin = plugin;
    }

    @EventHandler
    public void onTrade(io.papermc.paper.event.player.PlayerTradeEvent event) {
        if (!(event.getVillager() instanceof Villager villager)) return;

        if (!villager.getPersistentDataContainer()
                .has(MobGrab.MOBGRAB_PLACED_KEY, PersistentDataType.BOOLEAN)) return;

        // Update hologram one tick later so the recipe use count is current
        plugin.getServer().getScheduler().runTaskLater(plugin, () -> {
            HologramUtil.updateHologram(villager);
        }, 1L);
    }
}
