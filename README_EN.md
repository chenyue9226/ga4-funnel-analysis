# GA4 E-commerce Funnel & Channel Conversion Analysis (BigQuery SQL + Excel)

## Project Overview
This project analyzes the GA4 BigQuery Public Dataset to build a **session-level e-commerce conversion funnel**  
(**View → Cart → Checkout → Purchase**).  
It compares conversion performance across traffic channels, identifies the major drop-off stage, and provides actionable optimization recommendations.

---

## Data Source
- Dataset: `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`  
- Reference: https://developers.google.com/analytics/bigquery/web-ecommerce-demo-dataset  
- Time Range: **2020/11/01 – 2021/01/31**
- Note: This is an **obfuscated (anonymized / masked) sample dataset**, meaning some user or traffic-source fields may be partially hidden for privacy protection.

---

## KPI Snapshot
- View Item Sessions: **77,020**
- Add to Cart Sessions: **15,188** (Step CV: **19.70%**)
- Begin Checkout Sessions: **11,106** (Step CV: **73.10%**)
- Purchase Sessions: **4,848** (Step CV: **43.70%**)
- Final CV (View → Purchase): **6.29%**

---

## Key Findings
- The biggest drop-off occurs at **View → Add to Cart (19.70%)**, which is the primary bottleneck of the full funnel.
- Channel-level final conversion rates show that **Referral / Unknown** perform better overall, while **Paid Search** has the lowest conversion rate.
- A noticeable drop still exists from **Checkout → Purchase**, suggesting potential friction related to payment, shipping cost, or trust barriers.

---

## Recommendations
- **P0: Improve Add-to-Cart Rate**
  - Strengthen product page engagement and CTA visibility
  - Make discounts / shipping fees / delivery policies clearer and more transparent
- **P0: Optimize Paid Search Traffic**
  - Refine keyword intent matching and targeting
  - Improve landing page relevance and consistency
- **P1: Reduce Checkout Friction**
  - Simplify checkout steps
  - Add trust signals (policies, guarantees, reviews)
  - Offer more payment options

---

## Deliverables
- Key Visualizations:
  - Overall funnel
  - Key conversion rates
  - Channel final CV comparison
  - Channel step-level CV breakdown
  - Daily trend (sessions + CV)
- End-to-end workflow using **BigQuery SQL + Excel**
- Report: **GA4漏斗分析报告.pdf**

---

## Author
Chen Yue | BigQuery SQL · Funnel Analysis · Excel Visualization
