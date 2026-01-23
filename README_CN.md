# GA4 电商漏斗与渠道转化分析（BigQuery SQL + Excel）

---

## 项目简介
基于 GA4 BigQuery Public Dataset，构建 **Session 级电商转化漏斗**（View → Cart → Checkout → Purchase），对比不同渠道转化表现并定位关键流失环节，输出可执行优化建议。

---

## 数据来源
- Dataset：`bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  https://developers.google.com/analytics/bigquery/web-ecommerce-demo-dataset
- 时间范围：2020/11/01 – 2021/01/31  
- 说明：数据为 **obfuscated（匿名/模糊化）样本数据**

---

## 核心指标（KPI Snapshot）
- View Item Sessions：77,020  
- Add to Cart Sessions：15,188（Step CV：19.70%）
- Begin Checkout Sessions：11,106（Step CV：73.10%）
- Purchase Sessions：4,848（Step CV：43.70%）
- **Final CV（View → Purchase）：6.29%**

---

## 关键发现
- 最大流失发生在 **浏览 → 加购（19.70%）**，是全链路关键短板  
- 渠道最终 CV 对比：Referral / Unknown 更高，Paid Search 最低  
- 结账 → 购买仍存在明显损耗，可能与支付/运费/信任摩擦有关

---

## 优化建议
- P0：提升加购率（商品页承接、CTA、优惠/运费信息透明）  
- P0：优化 Paid Search（关键词意图、人群定向、落地页一致性）  
- P1：减少结账摩擦（流程简化、信任背书、支付方式丰富）

---

## 项目产出
- 核心图表（整体漏斗 / 关键 CV / 渠道最终 CV / 渠道分步 CV / 日趋势）
- SQL + Excel 完整分析链路
- GA4漏斗分析报告.pdf
---

## 作者
陈玥｜BigQuery SQL · Funnel Analysis · Excel 可视化
