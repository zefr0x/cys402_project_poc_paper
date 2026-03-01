import matplotlib.pyplot as plt
import numpy as np

# block size for every polanomial degree before and after compression
block_sizes = {
    4096: [31016705, 1110298],
    2048: [15505027, 458211],
    1024: [7764273, 231943],
    # 512: [3886115, 118942],
    # 64: [529972, 19728],
}

degrees = list(block_sizes.keys())
before_compression = [block_sizes[degree][0] / 1000000 for degree in degrees]
after_compression = [block_sizes[degree][1] / 1000000 for degree in degrees]

x = np.arange(len(degrees))  # label locations
width = 0.35  # width of bars

fig, ax = plt.subplots()
bars1 = ax.bar(x - width / 2, before_compression, width, label="Before Compression")
bars2 = ax.bar(x + width / 2, after_compression, width, label="After Compression")

ax.set_xlabel("Polynomial Degree")
ax.set_ylabel("Block Size (mega bytes)")
ax.set_xticks(x)
ax.set_xticklabels(degrees)
ax.legend()

# generate pdf file
plt.savefig("block_sizes.pdf", format="pdf", bbox_inches="tight")
