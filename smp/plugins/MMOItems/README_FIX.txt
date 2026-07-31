Drop-in fix pack for MMOItems

1) Overwrite these paths on your server:
   - plugins/MMOItems/crafting-stations/arcane-forge.yml
   - plugins/MMOItems/crafting-stations/mythical-forge.yml
   - plugins/MMOItems/crafting-stations/steel-crafting-station.yml
   - plugins/MMOItems/item/materials.yml

2) Then SSH and run these to sanitize existing item YAMLs (removes bad stats and ALL crafting blocks that crash recipes):

# Remove invalid stats seen in logs
sed -i -E '/^[[:space:]]*(REPAIR_MATERIAL|REPAIR_AMOUNT|REQUIRED_DEXTERITY|ADDITIONAL_EXPERIENCE|MANA_REGENERATION|MAX_STELLIUM):/Id' plugins/MMOItems/item/*.yml

# Strip any `crafting:` sections (prevents LinkedHashMap->String lore crash)
perl -0777 -i -pe 's/\n([ \t]*)crafting:\n(?:(?:(?:(?1)[ \t].*)|\1[ \t]+.*)\n)+//g' plugins/MMOItems/item/*.yml

3) Start server.
