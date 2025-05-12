# Equipment ID ranges
speakers = list(range(1, 301))                # 300 total
lights = list(range(301, 901))                # 600 total
microphones = list(range(901, 1111))          # 210 total
consoles = list(range(1111, 1211))            # 100 total
special_effects = list(range(1211, 1341))     # 130 total

stage_ids = list(range(1, 39))                # Stage IDs from 1 to 38

# Requirements per stage
req_per_stage = {
    "speakers": 7,
    "lights": 15,
    "microphones": 5,
    "consoles": 2,
    "special_effects": 3
}

# Assignments list
assignments = []

# Equipment pointers
eq_index = {
    "speakers": 0,
    "lights": 0,
    "microphones": 0,
    "consoles": 0,
    "special_effects": 0
}

# Map to equipment lists
equipment_lists = {
    "speakers": speakers,
    "lights": lights,
    "microphones": microphones,
    "consoles": consoles,
    "special_effects": special_effects
}

# Generate insert pairs
for stage_id in stage_ids:
    for eq_type in req_per_stage:
        needed = req_per_stage[eq_type]
        eq_list = equipment_lists[eq_type]
        idx = eq_index[eq_type]

        # Take 'needed' items
        for _ in range(needed):
            if idx >= len(eq_list):
                raise ValueError(f"Not enough {eq_type} for all stages.")
            assignments.append(f"({stage_id}, {eq_list[idx]})")
            idx += 1

        # Update pointer
        eq_index[eq_type] = idx


midpoint = len(assignments) // 2
first_half = assignments[:midpoint]
second_half = assignments[midpoint:]


# Output full SQL
print("INSERT INTO stage_technical_equipment (stage_id, technical_equipment_id) VALUES")
print(",\n".join(second_half) + ";")
