1. /* LOCAL DEALERS VIEW ABOUT AREA AGENT */
CREATE OR REPLACE VIEW LOCAL_DEALERS_AREA_AGENT_VIEW ("DEALER DEALERSHIP NO.","AREA AGENT ID", "NAME", "CITY", "AREA", "SHOP NAME", "SHOP OPENNING TIME","SHOP CLOSING TIME")
AS SELECT dealer_dealership_no, agent_id, agent_name, agent_city, agent_area, agent_shop_name,  agent_shop_open_time, agent_shop_close_time
FROM  LOCAL_DEALER JOIN COLLECTOR USING (dealer_dealership_no)
		JOIN Area_Agent USING (agent_id);
		

/* DISPLAYING SQL */
SELECT "AREA AGENT ID", "NAME", "CITY", "AREA", "SHOP NAME", "SHOP OPENNING TIME","SHOP CLOSING TIME"
FROM  LOCAL_DEALERS_AREA_AGENT_VIEW 
WHERE LOWER("DEALER DEALERSHIP NO.") = 'ld_0000001' OR "DEALER DEALERSHIP NO." = 'LD_0000001';


/* COUNTING AMOUNT OF AREA AGENT */
SELECT CONCAT(COUNT("AREA AGENT ID"), ' PERSONS') "NO. OF AREA AGENT" 
FROM LOCAL_DEALERS_AREA_AGENT_VIEW
WHERE LOWER("DEALER DEALERSHIP NO.") = 'ld_0000001' OR "DEALER DEALERSHIP NO." = 'LD_0000001';


2. /* LOCAL DEALERS VIEW ABOUT TRANSACTION WITH AREA AGENT */
CREATE OR REPLACE VIEW LD_TRANSACTION_AA_VIEW ("DEALER DEALERSHIP NO.","AREA AGENT ID", "NAME", "TRANSACTION ID", "TRANSACTION DATE", "WASTE TYPE", "AMOUNT", "PRICE PER UNIT", "EXPENSE")
AS SELECT dealer_dealership_no, agent_id, agent_name, TRANSACTION_ID, TRANSACTION_DATE, TYPES_WASTE, AMOUNT, PER_UNIT_PRICE, AMOUNT*PER_UNIT_PRICE
FROM  LOCAL_DEALER JOIN COLLECTOR USING (dealer_dealership_no)
		JOIN Area_Agent USING (agent_id)
		JOIN AGENT_TRANSACTION USING (AGENT_ID)
		JOIN TRANSACTION_SUPPORT USING (TRANSACTION_ID,TRANSACTION_DATE)
WHERE TRANS_SELL_COMPANY IN (SELECT AGENT_ID FROM Area_Agent);


/* DISPLAYING SQL */
SELECT "NAME", "AREA AGENT ID", "TRANSACTION ID", TO_CHAR("TRANSACTION DATE", 'DD-MON-YYYY') "TRANSACTION DATE", "WASTE TYPE", CONCAT("AMOUNT", ' kg') "AMOUNT", CONCAT("PRICE PER UNIT", ' tk') "PRICE PER UNIT", CONCAT("EXPENSE", ' tk') "EXPENSE"
FROM LD_TRANSACTION_AA_VIEW WHERE LOWER("DEALER DEALERSHIP NO.") = 'ld_0000001' OR "DEALER DEALERSHIP NO." = 'LD_0000001';

		
/* EXPENSE OF A MONTH */
SELECT CONCAT(SUM("EXPENSE"), ' tk') "TOTAL EXPENSE", TO_CHAR("TRANSACTION DATE",'MONTH') "MONTH"
FROM LD_TRANSACTION_AA_VIEW WHERE LOWER("DEALER DEALERSHIP NO.") = 'ld_0000001' OR "DEALER DEALERSHIP NO." = 'LD_0000001'
GROUP BY TO_CHAR("TRANSACTION DATE",'MONTH') 


/* MAX TRANSACTION IN A MONTH */
SELECT "NAME", "AREA AGENT ID", "TRANSACTION ID", TO_CHAR("TRANSACTION DATE", 'DD-MON-YYYY') "TRANSACTION DATE", CONCAT("EXPENSE", ' tk') "EXPENSE"
FROM LD_TRANSACTION_AA_VIEW 
WHERE "EXPENSE" = (SELECT MAX(EXPENSE) FROM LD_TRANSACTION_AA_VIEW WHERE LOWER("DEALER DEALERSHIP NO.") = 'ld_0000001' OR "DEALER DEALERSHIP NO." = 'LD_0000001' )

		
3. /* LOCAL DEALERS VIEW ABOUT COMPANIES */
CREATE OR REPLACE VIEW LOCAL_DEALERS_COMPANY_VIEW ("DEALER DEALERSHIP NO.","COMPANY NAME","TRADE NO.","WASTE TYPE","AMOUNT","PRICE PER UNIT","TOTAL INCOME","TRANSACTION ID","DATE")
AS SELECT dealer_dealership_no, NAME, COMPANY_TRADE_NUM, TYPES_WASTE, AMOUNT, PER_UNIT_PRICE, AMOUNT * PER_UNIT_PRICE,TRANSACTION_ID, TRANSACTION_DATE
FROM Local_Dealer JOIN LOCAL_DEALER_TRANSACTION USING (dealer_dealership_no)
		JOIN TRANSACTION_SUPPORT USING (TRANSACTION_ID,TRANSACTION_DATE)
		JOIN COMPANY_TRANSACTION USING (TRANSACTION_ID,TRANSACTION_DATE)
		JOIN COMPANY USING (COMPANY_TRADE_NUM);
		
		
/* DISPLAYING SQL */
SELECT "COMPANY NAME","TRADE NO.","WASTE TYPE", CONCAT("AMOUNT",' kg') "AMOUNT", CONCAT( "PRICE PER UNIT",' tk') "PRICE PER UNIT",CONCAT("TOTAL INCOME",' tk') "TOTAL INCOME", TO_CHAR("DATE", 'DD-MON-YYYY') "DATE"
FROM LOCAL_DEALERS_COMPANY_VIEW 
WHERE LOWER("DEALER DEALERSHIP NO.") = 'ld_0000001' OR "DEALER DEALERSHIP NO." = 'LD_0000001';




4. /* AREA AGENT VIEW ABOUT Local Waste Collector*/
CREATE OR REPLACE VIEW AA_LWC_VIEW ("AREA AGENT ID", "COLLECTOR ID", "NAME", "AREA", "TYPE OF WASTE", "CONTACT NO.", "COLLECTOR TYPE")
AS SELECT agent_id,Collector_ID, Collector_name, Collection_aera, Collector_type_of_waste, Collector_Contact_No, Collector_type
FROM Area_Agent JOIN AGGREGATOR USING (AGENT_ID)
		JOIN Local_Waste_Collector USING (Collector_ID);
		

/* DISPLAYING SQL */
SELECT "COLLECTOR ID", "NAME", "AREA", "TYPE OF WASTE", "CONTACT NO.", "COLLECTOR TYPE"
FROM AA_LWC_VIEW
WHERE LOWER("AREA AGENT ID") = 'aa_0000001' AND "AREA AGENT ID" = 'AA_0000001';


/* COUNTING DIFFERENT TYPES OF LOCAL WASTE COLLECTOR */
SELECT "COLLECTOR TYPE",CONCAT(COUNT("COLLECTOR ID"), ' PERSONS') "NUMBER OF COLLECTORS"
FROM AA_LWC_VIEW
WHERE LOWER("AREA AGENT ID") = 'aa_0000001' AND "AREA AGENT ID" = 'AA_0000001' 
GROUP BY "COLLECTOR TYPE";



5. /* COMPANY VIEW ABOUT LOCAL DAELER */
CREATE OR REPLACE VIEW CMP_LD_VIEW ("COMPANY TRADE NO.", "DEALERSHIP NO.", "NAME", "CITY", "DISTRICT", "CONTACT NO.")
AS SELECT COMPANY_TRADE_NUM, dealer_dealership_no,dealer_name,dealer_city,dealer_district,dealer_phone_no
FROM COMPANY JOIN COMPANY_TRANSACTION USING (COMPANY_TRADE_NUM)
		JOIN TRANSACTION_SUPPORT USING (TRANSACTION_ID,TRANSACTION_DATE)
		JOIN LOCAL_DEALER_TRANSACTION USING (TRANSACTION_ID,TRANSACTION_DATE)
		JOIN Local_Dealer LD USING (dealer_dealership_no)
		JOIN Dealer_Contact_No DCN USING (dealer_dealership_no)
WHERE TRANS_BUY_COMPANY IN (SELECT COMPANY_TRADE_NUM FROM COMPANY) 
ORDER BY COMPANY_TRADE_NUM;



/* DISPLAYING SQL */
SELECT "NAME", "DEALERSHIP NO.", "CITY", "DISTRICT", "CONTACT NO."
FROM CMP_LD_VIEW WHERE LOWER("COMPANY TRADE NO.") = 'COMP_00000001' OR "COMPANY TRADE NO." = 'COMP_00000001';




6. /* COMPANY VIEW ABOUT TRANSACTION WITH LOCAL DAELER */
CREATE OR REPLACE VIEW CMP_TRANSCATION_LD_VIEW ("COMPANY TRADE NO.", "DEALERSHIP NO.", "NAME", "TRANSACTION ID", "TRANSACTION DATE", "WASTE TYPE", "AMOUNT", "PRICE PER UNIT", "EXPENSE")
AS SELECT COMPANY_TRADE_NUM, dealer_dealership_no,dealer_name,TRANSACTION_ID, TRANSACTION_DATE, TYPES_WASTE, AMOUNT, PER_UNIT_PRICE, AMOUNT*PER_UNIT_PRICE
FROM COMPANY JOIN COMPANY_TRANSACTION USING (COMPANY_TRADE_NUM)
		JOIN TRANSACTION_SUPPORT USING (TRANSACTION_ID,TRANSACTION_DATE)
		JOIN LOCAL_DEALER_TRANSACTION USING (TRANSACTION_ID,TRANSACTION_DATE)
		JOIN Local_Dealer USING (dealer_dealership_no)
		JOIN Dealer_Contact_No USING (dealer_dealership_no)
WHERE TRANS_BUY_COMPANY IN (SELECT COMPANY_TRADE_NUM FROM COMPANY) 
ORDER BY COMPANY_TRADE_NUM;


/* DISPLAYING SQL */
SELECT "NAME",  "DEALERSHIP NO.", "TRANSACTION ID",TO_CHAR("TRANSACTION DATE", 'DD-MON-YYYY') "TRANSACTION DATE", "WASTE TYPE", CONCAT("AMOUNT", ' kg') "AMOUNT", CONCAT("PRICE PER UNIT", ' tk') "PRICE PER UNIT", CONCAT("EXPENSE", ' tk') "EXPENSE"
FROM CMP_TRANSCATION_LD_VIEW WHERE LOWER("COMPANY TRADE NO.") = 'COMP_00000001' OR "COMPANY TRADE NO." = 'COMP_00000001';





7. /* COMPANY VIEW ABOUT TRANSACTION WITH CLIENTS */
CREATE OR REPLACE VIEW CMP_TRANSCATION_LD_VIEW ("COMPANY TRADE NO.", "CLIENT TRADE NO.", "CLIENT'S COMPANY NAME", "TRANSACTION ID", "TRANSACTION DATE", "PRODUCT NAME", "PRODUCT TYPE", "AMOUNT", "PRICE PER UNIT", "EXPENSE")
AS SELECT CMP.COMPANY_TRADE_NUM, CLT.CLIENT_TRADE_NUM, CLIENTS_COMPANY_NAME,TS.TRANSACTION_ID, TS.TRANSACTION_DATE, PRD.PRODUCT_NAME, PRD.PRODUCT_TYPE, TS.AMOUNT, PRD.PRICE, TS.AMOUNT*PRD.PRICE
FROM COMPANY CMP JOIN PRODUCTION PDT ON CMP.COMPANY_TRADE_NUM = PDT.COMPANY_TRADE_NUM
		JOIN PRODUCT PRD ON PRD.PRODUCT_ID = PDT.PRODUCT_ID AND PRD.PRODUCT_DATE = PDT.PRODUCT_DATE
		JOIN PRODUCT_TRANSACTION PRDT ON PRD.PRODUCT_ID = PRDT.PRODUCT_ID AND PRD.PRODUCT_DATE = PRDT.PRODUCT_DATE
		JOIN TRANSACTION_SUPPORT TS ON TS.TRANSACTION_ID = PRDT.TRANSACTION_ID AND TS.TRANSACTION_DATE = PRDT.TRANSACTION_DATE
		JOIN CLIENTS_TRANSACTION CT ON TS.TRANSACTION_ID = CT.TRANSACTION_ID AND TS.TRANSACTION_DATE = CT.TRANSACTION_DATE
		JOIN CLIENTS CLT ON CLT.CLIENT_TRADE_NUM = CT.CLIENT_TRADE_NUM
WHERE TRANS_SELL_COMPANY IN (SELECT COMPANY_TRADE_NUM FROM COMPANY) 
ORDER BY CMP.COMPANY_TRADE_NUM;



/* DISPLAYING SQL */
SELECT  "CLIENT'S COMPANY NAME",  "CLIENT TRADE NO.", "TRANSACTION ID",TO_CHAR("TRANSACTION DATE", 'DD-MON-YYYY') "TRANSACTION DATE", "PRODUCT NAME", "PRODUCT TYPE", CONCAT("AMOUNT", ' kg') "AMOUNT", CONCAT("PRICE PER UNIT", ' tk') "PRICE PER UNIT", CONCAT("EXPENSE", ' tk') "EXPENSE"
FROM CMP_TRANSCATION_LD_VIEW WHERE LOWER("COMPANY TRADE NO.") = 'COMP_00000001' OR "COMPANY TRADE NO." = 'COMP_00000001';







