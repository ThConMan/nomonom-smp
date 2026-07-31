package com.mobgrab.util;

import com.mobgrab.MobGrab;
import net.kyori.adventure.text.Component;
import net.kyori.adventure.text.format.NamedTextColor;
import net.kyori.adventure.text.format.TextDecoration;
import org.bukkit.Color;
import org.bukkit.Location;
import org.bukkit.entity.*;
import org.bukkit.inventory.MerchantRecipe;
import org.bukkit.persistence.PersistentDataType;

import java.util.List;
import java.util.UUID;

public final class HologramUtil {

    private static final double HOLOGRAM_Y_OFFSET = 2.4;
    private static final float LINE_HEIGHT = 0.25f;

    private HologramUtil() {}

    public static void spawnHologram(Villager villager) {
        removeHologram(villager);

        Location loc = villager.getLocation().clone().add(0, HOLOGRAM_Y_OFFSET, 0);
        List<MerchantRecipe> recipes = villager.getRecipes();
        if (recipes.isEmpty()) return;

        Component text = buildHologramText(recipes);

        TextDisplay display = villager.getWorld().spawn(loc, TextDisplay.class, td -> {
            td.text(text);
            td.setBillboard(Display.Billboard.CENTER);
            td.setAlignment(TextDisplay.TextAlignment.CENTER);
            td.setSeeThrough(false);
            td.setShadowed(true);
            td.setBackgroundColor(Color.fromARGB(160, 0, 0, 0));
            td.setLineWidth(300);
            td.setPersistent(true);
            td.setCustomNameVisible(false);

            td.getPersistentDataContainer().set(
                    MobGrab.MOBGRAB_PLACED_KEY, PersistentDataType.BOOLEAN, true);
        });

        villager.getPersistentDataContainer().set(
                MobGrab.MOBGRAB_HOLOGRAM_KEY, PersistentDataType.STRING, display.getUniqueId().toString());
    }

    public static void updateHologram(Villager villager) {
        TextDisplay display = getHologram(villager);
        if (display == null) {
            spawnHologram(villager);
            return;
        }

        List<MerchantRecipe> recipes = villager.getRecipes();
        display.text(buildHologramText(recipes));
    }

    public static void removeHologram(Villager villager) {
        TextDisplay display = getHologram(villager);
        if (display != null) {
            display.remove();
        }
        villager.getPersistentDataContainer().remove(MobGrab.MOBGRAB_HOLOGRAM_KEY);
    }

    private static TextDisplay getHologram(Villager villager) {
        String uuidStr = villager.getPersistentDataContainer()
                .get(MobGrab.MOBGRAB_HOLOGRAM_KEY, PersistentDataType.STRING);
        if (uuidStr == null) return null;

        try {
            UUID uuid = UUID.fromString(uuidStr);
            Entity entity = villager.getWorld().getEntity(uuid);
            if (entity instanceof TextDisplay td && !td.isDead()) {
                return td;
            }
        } catch (IllegalArgumentException ignored) {}

        return null;
    }

    private static Component buildHologramText(List<MerchantRecipe> recipes) {
        Component text = Component.empty();

        for (int i = 0; i < recipes.size(); i++) {
            MerchantRecipe recipe = recipes.get(i);
            int remaining = recipe.getMaxUses() - recipe.getUses();
            boolean exhausted = remaining <= 0;

            String tradeName = getTradeLabel(recipe);

            NamedTextColor usesColor;
            if (exhausted) usesColor = NamedTextColor.DARK_GRAY;
            else if (remaining <= recipe.getMaxUses() / 4) usesColor = NamedTextColor.RED;
            else if (remaining <= recipe.getMaxUses() / 2) usesColor = NamedTextColor.YELLOW;
            else usesColor = NamedTextColor.GREEN;

            Component line;
            if (exhausted) {
                line = Component.text(tradeName, NamedTextColor.DARK_GRAY, TextDecoration.STRIKETHROUGH)
                        .append(Component.text(" 0/" + recipe.getMaxUses(), NamedTextColor.DARK_GRAY)
                                .decoration(TextDecoration.STRIKETHROUGH, false));
            } else {
                line = Component.text(tradeName, NamedTextColor.WHITE)
                        .append(Component.text(" " + remaining + "/" + recipe.getMaxUses(), usesColor));
            }

            text = text.append(line.decoration(TextDecoration.ITALIC, false));
            if (i < recipes.size() - 1) {
                text = text.append(Component.newline());
            }
        }

        return text;
    }

    private static String getTradeLabel(MerchantRecipe recipe) {
        var result = recipe.getResult();

        if (result.getType() == org.bukkit.Material.ENCHANTED_BOOK
                && result.hasItemMeta()
                && result.getItemMeta() instanceof org.bukkit.inventory.meta.EnchantmentStorageMeta esm) {
            var enchants = esm.getStoredEnchants();
            if (!enchants.isEmpty()) {
                var entry = enchants.entrySet().iterator().next();
                return MobDataUtil.formatEnum(entry.getKey().getKey().getKey())
                        + " " + toRoman(entry.getValue());
            }
        }

        if (result.hasItemMeta() && result.getItemMeta().hasDisplayName()) {
            return net.kyori.adventure.text.serializer.plain.PlainTextComponentSerializer
                    .plainText().serialize(result.getItemMeta().displayName());
        }

        return MobDataUtil.formatEnum(result.getType().name());
    }

    private static String toRoman(int num) {
        return switch (num) {
            case 1 -> "I";
            case 2 -> "II";
            case 3 -> "III";
            case 4 -> "IV";
            case 5 -> "V";
            default -> String.valueOf(num);
        };
    }
}
