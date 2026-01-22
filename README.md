# ga4-funnel-analysis
GA4 funnel &amp; channel analysis using BigQuery SQL
# GA4 E-commerce Funnel & Channel Analysis (BigQuery SQL)

## 1. 项目背景
本项目使用 Google BigQuery Public Datasets 中的 **GA4 电商样例事件数据**，
对用户行为漏斗（Funnel）与获客渠道（Acquisition Channel）进行分析。

数据为 GA4 BigQuery 导出结构的样例数据，部分字段经过脱敏/混淆（obfuscated），因此可能存在 `<Other>`、`(data deleted)` 等不可解释值。

---

## 2. 分析目标
1) 构建 session-level 漏斗指标，定位最大流失环节  
2) 拆分设备维度（desktop / mobile / tablet）判断是否存在体验差异  
3) 拆分渠道维度（source/medium & channel grouping），识别高/低质量流量并给出建议

---

## 3. 数据说明
- Dataset: `bigquery-public-data.ga4_obfuscated_sample_ecommerce`
- Tables: `events_*`
- Date range: 2020-11-01 ~ 2021-01-31
- Funnel events:
  - `view_item` → `add_to_cart` → `begin_checkout` → `purchase`

---

## 4. 核心指标定义（Conversion Rate）
- 浏览→加购：`cv_view_to_cart = sessions_add_to_cart / sessions_view_item`
- 加购→结账：`cv_cart_to_checkout = sessions_begin_checkout / sessions_add_to_cart`
- 结账→购买：`cv_checkout_to_purchase = sessions_purchase / sessions_begin_checkout`
- 浏览→购买：`cv_view_to_purchase = sessions_purchase / sessions_view_item`

---

## 5. 分析步骤与结果

### Step 1：整体漏斗（Overall Funnel）
结果（session-level）：
- sessions_view_item = 77,020
- sessions_add_to_cart = 15,188
- sessions_begin_checkout = 11,106
- sessions_purchase = 4,848

转化率：
- view → cart = 19.7%
- cart → checkout = 73.1%
- checkout → purchase = 43.7%
- view → purchase = 6.29%

结论：
- 最大流失发生在 **浏览→加购（view_item → add_to_cart）**，约 80% 浏览后未加购
- 第二大流失发生在 **结账→购买（begin_checkout → purchase）**

---

### Step 2：按设备拆分（Device Funnel）
主要结果：
- desktop：转化率与 mobile 接近
- mobile：每一步转化率略高但差异不大
- tablet：流量较小

结论：
- **设备不是主要转化差异来源**，因此优先关注渠道质量与漏斗关键环节优化

---

### Step 3：渠道分析（Channel Full Funnel & Grouping）
#### Step 3.5：按 source/medium 拆分完整漏斗
观察发现：
- 不同渠道在每一步的转化率差异明显
- 部分渠道（如 google/cpc）整体转化偏低，可能存在流量意图弱或落地页承接不足

#### Step 3.6：Channel Grouping（可解释渠道组）
将渠道归为：Organic Search / Paid Search / Direct / Referral / Unknown

结果（view → purchase）：
- Organic Search：~5.23%
- Direct：~6.10%
- Referral：~7.49%
- Paid Search：~4.83%（最低）
- Unknown：~7.42%（受脱敏影响，仅用于评估归因完整性）

结论：
- **Paid Search 转化最低**，应优先优化投放精准度与落地页承接
- Referral / Direct 相对更高，说明外部推荐或回访流量购买意图更强

---

## 6. 可执行建议（Actionable Recommendations）
P0（最高优先级）
- 优化 Paid Search（cpc）流量质量：收紧关键词/人群、提升落地页承接一致性
- 目标：将 Paid Search 转化提升至接近 Direct 水平

P1（影响最大）
- 针对最大流失点（view → cart）优化商品页：突出价格/优惠、评价与配送信息、提升加购引导

P2（长期）
- 改善归因完整性：规范 UTM 参数与追踪链路，降低 Direct / Unknown 占比，提高渠道决策可解释性

---

## 7. 局限性（Limitations）
- 数据为 obfuscated sample，部分 source/medium 被隐藏或聚合，导致 Unknown/Other 渠道不可解释
- 因此本项目重点基于可解释渠道组进行业务判断

---

## 8. 项目文件结构
- `sql/01_overall_funnel.sql`
- `sql/02_funnel_by_device.sql`
- `sql/03_channel_full_funnel.sql`
- `sql/04_channel_grouping.sql`

