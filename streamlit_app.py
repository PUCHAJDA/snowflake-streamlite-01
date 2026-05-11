# Import python packages
import streamlit as st
from snowflake.snowpark.context import get_active_session

# Get the current Snowflake session (auto-authenticated in Snowflake SiS)
session = get_active_session()

# ── Page config ──────────────────────────────────────────────
st.set_page_config(page_title="Pfizer Analytics Dashboard", layout="wide")
st.title("Pfizer Analytics Dashboard")

# ── Sidebar filters ───────────────────────────────────────────
st.sidebar.header("Filters")

regions = ["All"] + [
    r["REGION"]
    for r in session.sql(
        "SELECT DISTINCT region FROM TEST.ANALYTICS.SALES ORDER BY 1"
    ).collect()
]
selected_region = st.sidebar.selectbox("Region", regions)

products = ["All"] + [
    r["PRODUCT_NAME"]
    for r in session.sql(
        "SELECT DISTINCT product_name FROM TEST.ANALYTICS.SALES ORDER BY 1"
    ).collect()
]
selected_product = st.sidebar.selectbox("Product", products)

# Build WHERE clause
where_clauses = []
if selected_region != "All":
    where_clauses.append(f"region = '{selected_region}'")
if selected_product != "All":
    where_clauses.append(f"product_name = '{selected_product}'")
where_sql = ("WHERE " + " AND ".join(where_clauses)) if where_clauses else ""

# ── KPI Cards ─────────────────────────────────────────────────
st.subheader("Key Metrics")

kpi_df = session.sql(f"""
    SELECT
        SUM(revenue)    AS total_revenue,
        SUM(units_sold) AS total_units,
        COUNT(*)        AS num_transactions
    FROM TEST.ANALYTICS.SALES
    {where_sql}
""").to_pandas()

col1, col2, col3 = st.columns(3)
col1.metric("Total Revenue (USD)", f"${kpi_df['TOTAL_REVENUE'][0]:,.0f}")
col2.metric("Units Sold", f"{kpi_df['TOTAL_UNITS'][0]:,.0f}")
col3.metric("Transactions", f"{kpi_df['NUM_TRANSACTIONS'][0]}")

st.divider()

# ── Revenue Over Time ─────────────────────────────────────────
st.subheader("Monthly Revenue")

revenue_df = session.sql(f"""
    SELECT
        DATE_TRUNC('month', sale_date) AS month,
        SUM(revenue) AS total_revenue
    FROM TEST.ANALYTICS.SALES
    {where_sql}
    GROUP BY 1
    ORDER BY 1
""").to_pandas()

st.line_chart(revenue_df.set_index("MONTH")["TOTAL_REVENUE"])

st.divider()

# ── Revenue by Region & Product ───────────────────────────────
col_left, col_right = st.columns(2)

with col_left:
    st.subheader("Revenue by Region")
    region_df = session.sql(f"""
        SELECT region, SUM(revenue) AS total_revenue
        FROM TEST.ANALYTICS.SALES
        {where_sql}
        GROUP BY 1
        ORDER BY 2 DESC
    """).to_pandas()
    st.bar_chart(region_df.set_index("REGION")["TOTAL_REVENUE"])

with col_right:
    st.subheader("Revenue by Product")
    product_df = session.sql(f"""
        SELECT product_name, SUM(revenue) AS total_revenue
        FROM TEST.ANALYTICS.SALES
        {where_sql}
        GROUP BY 1
        ORDER BY 2 DESC
    """).to_pandas()
    st.bar_chart(product_df.set_index("PRODUCT_NAME")["TOTAL_REVENUE"])

st.divider()

# ── Clinical Trials ───────────────────────────────────────────
st.subheader("Clinical Trials")

trial_status = st.selectbox(
    "Filter by Status",
    ["All", "Completed", "Active", "Recruiting", "Planned"],
)
trial_where = "" if trial_status == "All" else f"WHERE status = '{trial_status}'"

trials_df = session.sql(f"""
    SELECT
        trial_id, trial_name, product, phase, status,
        start_date, end_date, participants,
        country, success_rate
    FROM TEST.ANALYTICS.CLINICAL_TRIALS
    {trial_where}
    ORDER BY start_date DESC
""").to_pandas()

st.dataframe(trials_df, use_container_width=True)

st.divider()

# ── Inventory & Low Stock Alerts ──────────────────────────────
st.subheader("Inventory Levels")

inv_df = session.sql("""
    SELECT product_name, warehouse, region, stock_units, reorder_level,
           IFF(stock_units < reorder_level, 'LOW', 'OK') AS stock_status
    FROM TEST.ANALYTICS.INVENTORY
    ORDER BY stock_units ASC
""").to_pandas()

low_stock = inv_df[inv_df["STOCK_STATUS"] == "LOW"]

if not low_stock.empty:
    st.warning(f"{len(low_stock)} item(s) below reorder level!")
    st.dataframe(low_stock, use_container_width=True)

st.subheader("Full Inventory")
st.dataframe(inv_df, use_container_width=True)

st.divider()

# ── Raw Sales Data ────────────────────────────────────────────
with st.expander("Raw Sales Data"):
    sales_df = session.sql(f"""
        SELECT * FROM TEST.ANALYTICS.SALES
        {where_sql}
        ORDER BY sale_date DESC
    """).to_pandas()
    st.dataframe(sales_df, use_container_width=True)
