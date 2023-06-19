# Rasa_Portfolio 

Here you will find some of the projects that I did while studying Data Analytics course at Turing College. 
Click on the blue links to see full dashboards or SQL queries.

### Customer Behavior and Product Pages Analysis in Online Electronics Store

The task was to identify a unique problem applicable to a chosen dataset. I chose to analyze web events data from an online electronics store. The goal of the analysis was to identify areas for conversion rate improvement by addressing the following questions:

- Which stage of the purchase funnel experiences the highest customer drop-off?
- Are there any trends in customer engagement based on weekdays?
- Are there specific product pages that are underperforming in terms of conversion rates?

Key findings:
- In February, approximately 90% of all sessions ended without adding items to the cart, indicating a significant drop-off in the purchase funnel. Furthermore, the high bounce rate of 69% suggests the need to evaluate the effectiveness of targeted marketing campaigns in reaching the intended audience.
- The online store experiences lower session and order volumes on weekends. To address this, implementing special promotions and incentives during weekends may help attract more customers.
- Out of the analyzed product pages with over 100 visits, 28 pages exhibited poor conversion rates ranging from 0% to 3%. It is crucial to optimize these pages by improve factors such as pricing, product descriptions, images, and overall user experience to enhance conversion rates and minimize bounce rates.

- [Dashboard](https://lookerstudio.google.com/s/ubvAaCiCxQg) (Looker Studio), [Query](https://github.com/rasmat001/Rasa_Portfolio/blob/main/queries/capstone_project.sql), [Report](https://docs.google.com/document/d/1Cs7EMs8h_NNZc60V4Khr5pZsCDsZ-KNpR0FVLLDshQY/edit?usp=sharing)

![](/images/capstone.jpg)

### Marketing Analysis (Session Time Analysis)

The task was to analyze the overall trends of all marketing campaigns on Google Merchandise Store and find out if users tend to spend more time on the website on certain weekdays and how that behavior differs across campaigns.

- [Dashboard](https://lookerstudio.google.com/reporting/ae97231a-987f-4a40-8bf5-b33b7ca753a3) (Looker Studio), [Query](https://github.com/rasmat001/Rasa_Portfolio/blob/main/queries/Session%20Time%20Analysis%20(Marketing).sql)

Key findings:
- Lower user engagement on the weekends (fewer and shorter user sessions)
- Most of the sessions and revenue come from Referral and Organic traffic 
- The most successful paid marketing campaigns was Black Friday and Holiday - they generated most revenue, had higher conversion rate and lower cost per acquisition. Whereas Data Share Promo and New Year campaigns had more sessions, but very low conversion rate and higher cost per acquisition

![](/images/session_time_analysis.jpg)

### Product Analysis (Time to Purchase Analysis)

The task was to identify how much time it takes for a user to make a purchase on the website (from first arriving on the website on any given day until their first purchase on that same day). I have also looked into how much time it takes for a user to reach each purchase funnel event.

- [Dashboard](https://lookerstudio.google.com/s/oy-xRp5uNXs) (Looker Studio), [Query](https://github.com/rasmat001/Rasa_Portfolio/blob/main/queries/Time%20to%20Purchase%20(Product).sql)

Key findings:
- Median time to purchase is 18 minutes
- A user spends the longest time (10min) between adding the first item to the cart and starting the checkout
- It takes 4 min to complete a purchase after adding payment info. To improve customer experience we could investigate how to shorten this time

![](/images/time_to_purchase_funnel.jpg)

### Dashboards for Executive and Sales Department

The task was to prepare a dashboard and a presentation using data from AdventureWorks database for different departments.

- [Dashboard](https://lookerstudio.google.com/s/ry1_TWDoRjI) (Looker Studio) and [Presentation](https://1drv.ms/p/s!AmmVG-hGs2YDgT-zzXHP13f_mRfT?e=DJN9YC) for Sales Department
- [Dashboard](https://lookerstudio.google.com/s/pmKR2tVlIRY) (Looker Studio) and [Presentation](https://onedrive.live.com/view.aspx?resid=366B346E81B9569!188&ithint=file%2cpptx&authkey=!AGj3gx7Xq0UnyNs) for Executive Team

Key findings:
- Although most of the revenue comes from offline sales, they are unprofitable since quite many products are being sold for a price that is even lower than standard cost

![](/images/executive_kpi.jpg)
### RFM Analysis

- [Dashboard](https://lookerstudio.google.com/s/s_8Jv3YrPbs) (Looker Studio), [Query](https://github.com/rasmat001/Rasa_Portfolio/blob/main/queries/RFM%20analysis.sql)

![](/images/RFM.jpg)

### Funnel Analysis

- [Dashboard](https://public.tableau.com/views/FunnelAnalysis_16838888475930/FunnelAnalysis?:language=en-US&publish=yes&:display_count=n&:origin=viz_share_link) (Tableau Public) 

![](/images/Funnel_Analysis.jpg)

### Customer Lifetime Value (CLV) - Cohort Analysis

The task was to calculate CLV using cohort analysis and predict future CLV using cumulative growth % from cohorts where we have data already.
- [Dashboard](https://1drv.ms/x/s!AmmVG-hGs2YDgXRoJqFjD3JOybwE?e=IIOq67) (Spreadsheet), [Query](https://github.com/rasmat001/Rasa_Portfolio/blob/main/queries/CLV%20(cohort).sql)

![](/images/cohort_clv.jpg)

### Sellers' Overview in Olist Marketplace

- [Dashboard](https://public.tableau.com/views/Olist-Sellers/Sellers?:language=en-US&publish=yes&:display_count=n&:origin=viz_share_link) (Tableau Public) 

![](/images/olist_sellers.jpg)



