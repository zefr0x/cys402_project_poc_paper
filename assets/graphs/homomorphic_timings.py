import matplotlib.pyplot as plt

# Define the operations times for every count of voters
timings = {
    100: [54.9, 63.5, 101.6, 37, 85.9],
    250: [137.3, 64.9, 253.8, 37.5, 162.2],
    500: [277, 64, 491.1, 36.8, 283.9],
    1000: [559.5, 63.4, 996.4, 36.9, 542.3],
    1500: [821.5, 63.9, 1477.2, 36.6, 779.9],
}

# Define the operations to be timed
operations = [
    "Global Key Aggregation",
    "Vote Casting",
    "Votes Tallying",
    "Decryption",
    "Decryption Shares Aggregation",
]

# Restructure data
data_sizes = sorted(timings.keys())
operation_timings = {operation: [] for operation in operations}
for size in data_sizes:
    for i, timing in enumerate(timings[size]):
        operation_timings[operations[i]].append(timing)

fig, ax = plt.subplots(figsize=(12, 6))

for i, (func, timings) in enumerate(operation_timings.items()):
    ax.plot(data_sizes, timings, label=func, marker="o")

ax.set_xlabel("Participants Count")
ax.set_ylabel("Time (milli seconds)")
ax.legend()
ax.grid(True)

plt.tight_layout()

# generate pdf file
plt.savefig("homomorphic_timings.pdf", format="pdf", bbox_inches="tight")
