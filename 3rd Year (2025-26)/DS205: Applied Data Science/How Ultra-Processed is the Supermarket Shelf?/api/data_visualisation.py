import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.ticker as mtick

df = pd.read_json("../data/enriched/all_products_nova.jsonl", lines=True)

# only look at products with NOVA data
df_nova = df.dropna(subset=["nova_group"])
df_nova["nova_group"] = df_nova["nova_group"].astype(int)

nova_labels = {
    1: "NOVA 1\nUnprocessed",
    2: "NOVA 2\nProcessed\nIngredients",
    3: "NOVA 3\nProcessed",
    4: "NOVA 4\nUltra-Processed",
}
nova_colours = {1: "#2ecc71", 2: "#f1c40f", 3: "#e67e22", 4: "#e74c3c"}

# FIGURE 1: overall NOVA distribution (bar chart)
fig, ax = plt.subplots(figsize=(8, 5))
counts = df_nova["nova_group"].value_counts().sort_index()
bars = ax.bar(
    [nova_labels[i] for i in counts.index],
    counts.values,
    color=[nova_colours[i] for i in counts.index],
    edgecolor="white",
    width=0.6,
)
for bar, count in zip(bars, counts.values):
    pct = count / len(df_nova) * 100
    ax.text(bar.get_x() + bar.get_width() / 2, bar.get_height() + 10,
            f"{count}\n({pct:.1f}%)", ha="center", va="bottom", fontsize=9)

ax.set_title("NOVA Classification of Waitrose Products", fontsize=13, fontweight="bold")
ax.set_ylabel("Number of Products")
ax.set_ylim(0, counts.max() * 1.15)
ax.spines[["top", "right"]].set_visible(False)
plt.tight_layout()
plt.savefig("../figures/NOVA_distribution.png", dpi=150)
plt.show()
print("Saved NOVA.png")

# FIGURE 2: NOVA distribution by category
fig, ax = plt.subplots(figsize=(12, 6))
category_nova = df_nova.groupby(["category", "nova_group"]).size().unstack(fill_value=0)
category_nova_pct = category_nova.div(category_nova.sum(axis=1), axis=0) * 100
category_nova_pct = category_nova_pct.sort_values(4, ascending=True)  # sort by UPF %

category_nova_pct.plot(
    kind="barh",
    stacked=True,
    color=[nova_colours[i] for i in category_nova_pct.columns],
    ax=ax,
    edgecolor="white",
)
ax.set_title("NOVA Distribution by Category", fontsize=13, fontweight="bold")
ax.set_xlabel("Percentage of Products (%)")
ax.set_ylabel("")
ax.xaxis.set_major_formatter(mtick.PercentFormatter())
ax.legend([nova_labels[i] for i in category_nova_pct.columns], 
          loc="lower right", fontsize=8)
ax.spines[["top", "right"]].set_visible(False)
plt.tight_layout()
plt.savefig("../figures/NOVA_by_category.png", dpi=150)
plt.show()
print("Saved NOVA_by_category.png")

# FIGURE 3: UPF proportion by category (bar chart)
fig, ax = plt.subplots(figsize=(10, 6))
UPF_by_cat = df_nova.groupby("category").apply(
    lambda x: (x["nova_group"] == 4).sum() / len(x) * 100
).sort_values(ascending=True)

bars = ax.barh(
    UPF_by_cat.index,
    UPF_by_cat.values,
    color="#e74c3c",
    edgecolor="white",
)
for bar, val in zip(bars, UPF_by_cat.values):
    ax.text(val + 0.5, bar.get_y() + bar.get_height() / 2,
            f"{val:.1f}%", va="center", fontsize=9)

ax.axvline(UPF_by_cat.mean(), color="black", linestyle="--", linewidth=1, label=f"Average ({UPF_by_cat.mean():.1f}%)")
ax.set_title("Proportion of Ultra-Processed Products by Category", fontsize=13, fontweight="bold")
ax.set_xlabel("% Ultra-Processed (NOVA 4)")
ax.set_xlim(0, 110)
ax.legend()
ax.spines[["top", "right"]].set_visible(False)
plt.tight_layout()
plt.savefig("../figures/UPF_by_category.png", dpi=150)
plt.show()
print("Saved UPF_by_category.png")


# FIGURE 4: NOVA coverage by category (including null)
fig, ax = plt.subplots(figsize=(12, 6))

nova_colours_with_null = {1: "#2ecc71", 2: "#f1c40f", 3: "#e67e22", 4: "#e74c3c", "null": "#bdc3c7"}

df["nova_group_label"] = df["nova_group"].apply(
    lambda x: int(x) if pd.notna(x) else "null"
)
category_all = df.groupby(["category", "nova_group_label"]).size().unstack(fill_value=0)
for col in [1, 2, 3, 4, "null"]:
    if col not in category_all.columns:
        category_all[col] = 0
category_all = category_all[[1, 2, 3, 4, "null"]]
category_all_pct = category_all.div(category_all.sum(axis=1), axis=0) * 100
category_all_pct = category_all_pct.sort_values("null", ascending=False)

category_all_pct.plot(
    kind="barh",
    stacked=True,
    color=[nova_colours_with_null[c] for c in category_all_pct.columns],
    ax=ax,
    edgecolor="white",
)
ax.set_title("NOVA Coverage by Category (including unmatched products)", fontsize=13, fontweight="bold")
ax.set_xlabel("Percentage of Products (%)")
ax.set_ylabel("")
ax.xaxis.set_major_formatter(mtick.PercentFormatter())
ax.legend(["NOVA 1 (Unprocessed)", "NOVA 2", "NOVA 3 (Processed)", "NOVA 4 (Ultra-Processed)", "No NOVA data"],
          loc="lower right", fontsize=8)
ax.spines[["top", "right"]].set_visible(False)
plt.tight_layout()
plt.savefig("../figures/NOVA_coverage.png", dpi=150)
plt.show()

# SUMMARY STATISTICS
print(f"\nTotal products: {len(df)}")
print(f"Products with NOVA: {len(df_nova)} ({len(df_nova)/len(df)*100:.1f}%)")
print(f"Ultra-processed (NOVA 4): {UPF_count} ({UPF_count/len(df_nova)*100:.1f}% of classified)")
print(f"\nNOVA breakdown:")
for nova, count in counts.items():
    print(f"  NOVA {nova}: {count} ({count/len(df_nova)*100:.1f}%)")