import json
from datetime import date, timedelta

base_poem = {
    "todayWord": "snake",

    "part1": """"In tangled coils, a sleek and slender form,
Unveiling secrets, nature's enigma born.
Silent slither, a creature of mystique,
Serpent whispers, a language unique.""",

    "part2": """With scales that shimmer, a captivating sheen,
 Unseen predator, nature's ancient queen.
 Wisdom coiled, in eyes that never blink,
 A dance of venom, a silent link.""",

    "part3": """"In gardens deep, their presence found,
 Symbols of transformation, shedding the ground.
 In sinuous motion, they gracefully glide,
 Reminders of duality, life's ebb and tide.""",

    "part4": """"Respecting their essence, we learn to see,
 The beauty in creatures, wild and free.
 For in the realm of serpents, truth remains,
 A balance of fears and untamed refrains."""
}

out = {}

for add_day in range(365):
    out[(date.today() + timedelta(days=add_day)).strftime("%Y%m%d")] = base_poem

with open("/Users/adamalloul/poetrai/assets/poems/poems.json", "w") as f:
    json.dump(out, f)