/* #1 */
SELECT * FROM SALES_ORDER;

/* #2 */
SELECT SALES_ORDER_ID FROM SALES_ORDER
WHERE ORDER_DATE > TO_DATE('2016-01-01', 'YYYY-MM-DD');

/* #3 */
SELECT SALES_ORDER_ID FROM SALES_ORDER
WHERE ORDER_DATE BETWEEN TO_DATE('2016-01-02', 'YYYY-MM-DD') AND TO_DATE('2016-07-14', 'YYYY-MM-DD');

/* #4 */
SELECT MANAGER_FIRST_NAME, MANAGER_LAST_NAME FROM MANAGER
WHERE MANAGER_FIRST_NAME = 'Henry';

/* #5 */
SELECT SALES_ORDER_ID, MANAGER_ID FROM SALES_ORDER
WHERE MANAGER_ID IN (
    SELECT MANAGER_ID FROM  MANAGER
    WHERE MANAGER_FIRST_NAME = 'Henry')
ORDER BY MANAGER_ID;

/* #6 */
SELECT DISTINCT COUNTRY FROM CITY;

/* #7 */
SELECT DISTINCT REGION, COUNTRY FROM CITY;

/* #8 */
SELECT COUNTRY, COUNT(DISTINCT CITY_NAME) AS CITY_NUM FROM CITY
GROUP BY COUNTRY;

/* #9 */
SELECT PRODUCT_QTY FROM SALES_ORDER_LINE
WHERE SALES_ORDER_ID IN (
    SELECT SALES_ORDER_ID
    FROM SALES_ORDER
    WHERE ORDER_DATE BETWEEN TO_DATE('2016-01-01', 'YYYY-MM-DD') AND TO_DATE('2016-01-30', 'YYYY-MM-DD')
);

/* #10 */
SELECT CITY_NAME FROM CITY
UNION
SELECT REGION FROM CITY
UNION
SELECT COUNTRY FROM CITY;

/* #11 */
SELECT MANAGER_FIRST_NAME, MANAGER_LAST_NAME
FROM MANAGER
         INNER JOIN (
    SELECT SO.SALES_ORDER_ID, MANAGER_ID, SUM_ORDER
    FROM SALES_ORDER SO
             INNER JOIN (
        SELECT SALES_ORDER_ID, SUM(PRODUCT_PRICE * PRODUCT_QTY) AS SUM_ORDER
        FROM SALES_ORDER_LINE
        GROUP BY SALES_ORDER_ID
    ) SUM_ORDERS ON (SO.SALES_ORDER_ID = SUM_ORDERS.SALES_ORDER_ID)
    WHERE SUM_ORDER = (
        SELECT MAX(SUM_ORDER)
        FROM (
                 SELECT SUM(PRODUCT_PRICE * PRODUCT_QTY) AS SUM_ORDER
                 FROM SALES_ORDER_LINE
                 WHERE SALES_ORDER_ID IN (
                     SELECT SALES_ORDER_ID
                     FROM SALES_ORDER
                     WHERE ORDER_DATE BETWEEN TO_DATE('2016-01-01', 'YYYY-MM-DD') AND TO_DATE('2016-01-31', 'YYYY-MM-DD')
                 )
                 GROUP BY SALES_ORDER_ID
             )
    )
) MAX_ORDER ON (MANAGER.MANAGER_ID = MAX_ORDER.MANAGER_ID)